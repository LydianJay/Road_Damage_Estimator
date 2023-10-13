import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:pothole/report.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({Key? key, required this.cameras}) : super(key: key);
  @override
  Widget build(context) {
    return MaterialApp(
      title: 'Road Damage Estimator Tool',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: HomePage(cameras: cameras),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const HomePage({Key? key, required this.cameras}) : super(key: key);
  @override
  _state createState() => _state();
}

class _state extends State<HomePage> {
  late CameraController camController;
  late Future<void> initControlerFuture;
  late Interpreter rTypeInterpreter;
  late Interpreter dTypeInterpreter;
  List<double> value = List<double>.filled(4, 0);
  late String imagePath;
  @override
  void initState() {
    super.initState();
    debugPrint('[initState] Initiliazation');

    camController = CameraController(
      widget.cameras[0],
      ResolutionPreset.veryHigh,
    );
    initControlerFuture = camController.initialize();

    loadModel();
  }

  loadModel() async {
    try {
      rTypeInterpreter = await Interpreter.fromAsset('assets/rType.tflite');
      dTypeInterpreter = await Interpreter.fromAsset('assets/dType.tflite');
      debugPrint("Assets loaded!");
    } catch (e) {
      debugPrint("ERROR loading assets: $e");
    }
  }

  Future<void> captureImage() async {
    try {
      final image = await camController.takePicture();
      imagePath = image.path;
      await predict(image.path);
    } catch (e) {
      debugPrint('Error Occured!: $e');
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
        source: ImageSource
            .gallery); // You can also use ImageSource.camera to open the camera.
    final path = pickedImage!.path;
    imagePath = path;
    await predict(path);
  }

  Future<void> predict(String path) async {
    final bytes = await File(path).readAsBytes();
    final img.Image? capturedImage = img.decodeImage(bytes);

    if (capturedImage != null) {
      rTypeInterpreter.allocateTensors();
      dTypeInterpreter.allocateTensors();
      final scaledImage =
          img.copyResize(capturedImage, width: 256, height: 256);

      final imageMatrix = List.generate(
        scaledImage.height,
        (y) => List.generate(
          scaledImage.width,
          (x) {
            final pixel = scaledImage.getPixel(x, y);
            return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
          },
        ),
      );

      final input = [imageMatrix];
      final rOut = [List<double>.filled(2, 0)];
      final dOut = [List<double>.filled(4, 0)];
      rTypeInterpreter.run(input, rOut);
      dTypeInterpreter.run(input, dOut);
      setState(() {
        value = rOut.first;
        List<double> value2 = dOut.first;

        for (int i = 0; i < value2.length; i++) {
          value.add(value2[i]);
        }
      });
    }
  }

  @override
  void dispose() {
    rTypeInterpreter.close();
    dTypeInterpreter.close();
    camController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Road Estimator Tool'),
        centerTitle: true,
      ),
      body: FutureBuilder<void>(
        future: initControlerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox(
                  width: scrWidth,
                  height: scrHeight,
                  child: AspectRatio(
                    aspectRatio: camController.value.aspectRatio,
                    child: CameraPreview(camController),
                  ),
                ),
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              captureImage().then((value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Report(
                                            pathImg: imagePath,
                                            value: this.value)));
                              });
                            },
                            child: const Text('Capture'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              pickImage().then((value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Report(
                                            pathImg: imagePath,
                                            value: this.value)));
                              });
                            },
                            child: const Text('Gallery'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
