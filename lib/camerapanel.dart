import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:pothole/report.dart';

class CameraPanel extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPanel({Key? key, required this.cameras}) : super(key: key);
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<CameraPanel> {
  late CameraController camController;
  late Future<void> initControlerFuture;
  late Interpreter rTypeInterpreter;
  late Interpreter dTypeInterpreter;
  late List<double> rTypeVal;
  late List<double> dTypeVal;
  String imagePath = ' ';
  @override
  void initState() {
    super.initState();

    camController = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
    );
    initControlerFuture = camController.initialize();

    loadModel();
  }

  void loadModel() async {
    try {
      rTypeInterpreter = await Interpreter.fromAsset('assets/rType.tflite');
      dTypeInterpreter = await Interpreter.fromAsset('assets/dType.tflite');
      debugPrint("Models Loaded!");
    } catch (e) {
      debugPrint("ERROR loading models: $e");
    }
  }

  Future<void> captureImage() async {
    try {
      final imgPath = await camController.takePicture();
      imagePath = imgPath.path;
      await predict(imgPath.path);
    } catch (e) {
      debugPrint('Image capture failed!: $e');
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
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
      rTypeVal = rOut.first;
      dTypeVal = dOut.first;
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
    const ButtonStyle bStyle = ButtonStyle(
      iconColor:
          MaterialStatePropertyAll<Color>(Color.fromARGB(255, 255, 163, 26)),
      backgroundColor:
          MaterialStatePropertyAll<Color>(Color.fromARGB(255, 41, 41, 41)),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        title: Container(
          padding: EdgeInsets.all(scrWidth / 8),
          child: Row(children: [
            const Text('Road '),
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(),
                    color: const Color.fromARGB(255, 255, 163, 26)),
                child: const Text(
                  'Budgify',
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      color: Color.fromARGB(255, 0, 0, 0)),
                )),
          ]),
        ),
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
                          ElevatedButton.icon(
                            style: bStyle,
                            onPressed: () {
                              captureImage().then((value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Report(
                                              pathImg: imagePath,
                                              rType: rTypeVal,
                                              dType: dTypeVal,
                                            )));
                              });
                            },
                            icon: const Icon(Icons.camera_sharp),
                            label: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(),
                                    color: const Color.fromARGB(
                                        255, 255, 163, 26)),
                                child: const Text(
                                  'Capture',
                                  style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                )),
                          ),
                          ElevatedButton.icon(
                            style: bStyle,
                            onPressed: () {
                              pickImage().then((value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Report(
                                              pathImg: imagePath,
                                              rType: rTypeVal,
                                              dType: dTypeVal,
                                            )));
                              });
                            },
                            icon: const Icon(Icons.image),
                            label: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(),
                                    color: const Color.fromARGB(
                                        255, 255, 163, 26)),
                                child: const Text(
                                  'Galery',
                                  style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                )),
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
