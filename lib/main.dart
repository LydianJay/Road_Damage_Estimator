import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:pothole/frontpanel.dart';
import 'camerapanel.dart';

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
      initialRoute: '/frontpanel',
      routes: {
        '/frontpanel': (context) => FrontPanel(
              cameras: cameras,
            ),
        '/camerapanel': (context) => CameraPanel(cameras: cameras),
      },
    );
  }
}
