/// All Rights Reserved
///
/// Copyright (c) 2023 LydianJay (Lloyd Jay Arpilleda Edradan)
///
/// THE CONTENTS OF THIS PROJECT ARE PROPRIETARY AND CONFIDENTIAL.
/// UNAUTHORIZED COPYING, TRANSFERRING OR REPRODUCTION OF THE CONTENTS OF THIS PROJECT, VIA ANY MEDIUM IS STRICTLY PROHIBITED.
///
/// The receipt or possession of the source code and/or any parts thereof does not convey or imply any right to use them
/// for any purpose other than the purpose for which they were provided to you.
///
/// The software is provided "AS IS", without warranty of any kind, express or implied, including but not limited to
/// the warranties of merchantability, fitness for a particular purpose and non infringement.
/// In no event shall the authors or copyright holders be liable for any claim, damages or other liability,
/// whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software
/// or the use or other dealings in the software.

/// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:pothole/frontpanel.dart';
import 'camerapanel.dart';
import 'package:pothole/priceconfigpanel.dart';

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
        '/config': (context) => const PriceConfigPanel(),
      },
    );
  }
}
