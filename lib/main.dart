import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({Key? key, required this.cameras}) : super(key: key);
  @override
  Widget build(BuildContext) {
    return MaterialApp(
      title: 'Road Reporting Tool',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: HomePage(cameras: cameras),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const HomePage({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Road Reporting Tool"),
      ),
    );
  }

  @override
  _state createState() => _state();
}

class _state extends State<HomePage> {
  late CameraController camController;
  late Future<void> initControlerFuture;
  late Interpreter interpreter;
  double value = 0;
  Tensor? inputTensor;
  Tensor? outputTensor;
  @override
  void initState() {
    super.initState();
    debugPrint('[initState] Initiliazation');

    camController = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
    );
    initControlerFuture = camController.initialize();

    loadModel();
  }

  loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/model.tflite');
      inputTensor = interpreter.getInputTensor(0);
      outputTensor = interpreter.getOutputTensor(0);
      debugPrint("Assets loaded!");
    } catch (e) {
      debugPrint("ERROR loading assets: $e");
    }
  }

  Future<void> captureImage() async {
    try {
      final image = await camController.takePicture();

      final bytes = await File(image.path).readAsBytes();
      final img.Image? capturedImage = img.decodeImage(bytes);

      if (capturedImage != null) {
        // Scale the image to 200x200 pixels
        interpreter.allocateTensors();
        final scaledImage =
            img.copyResize(capturedImage, width: 200, height: 200);

        final imageMatrix = List.generate(
          scaledImage.height,
          (y) => List.generate(
            scaledImage.width,
            (x) {
              final pixel = scaledImage.getPixel(x, y);
              return [pixel.r / 255, pixel.g / 255, pixel.b / 255];
            },
          ),
        );

        print('image matrix: $imageMatrix');
        final input = [imageMatrix];
        final output = [List<double>.filled(1, 0)];

        interpreter.run(input, output);
        debugPrint('Output: $output');
        setState(() {
          value = output.first.first;
        });
      } else {
        debugPrint('Captured Image was null!');
      }
    } catch (e) {
      debugPrint('Error Occured!: $e');
    }
  }

  @override
  void dispose() {
    interpreter.close();
    camController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Road Reporting Tool'),
      ),
      body: FutureBuilder<void>(
        future: initControlerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: CameraPreview(camController),
                ),
                ElevatedButton(
                  onPressed: captureImage,
                  child: Text('Capture Image'),
                ),
                Text('$value'),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
