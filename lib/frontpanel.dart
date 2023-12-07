import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart' show rootBundle;

class FrontPanel extends StatefulWidget {
  final List<CameraDescription> cameras;
  const FrontPanel({super.key, required this.cameras});

  @override
  State<FrontPanel> createState() => _FrontPanelState();
}

class _FrontPanelState extends State<FrontPanel> {
  Future<Widget> loadFrontWidget(double scrWidth, double scrHeight) async {
    String text = await rootBundle.loadString('assets/data/disclosure.txt');

    return ListView(
      children: [
        Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 41, 41, 41)),
          child: Column(
            children: [
              Container(
                width: scrWidth,
                margin: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                padding: const EdgeInsets.all(10),
                height: scrHeight * 0.45,
                foregroundDecoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/splash.png"),
                      fit: BoxFit.fitWidth),
                ),
              ),
              Container(
                width: scrWidth,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(45.5))),
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text(
                      'Disclaimer: Image Classification Accuracy:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Calibre',
                      ),
                    ),
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Calibre',
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/camerapanel');
                      },
                      style: const ButtonStyle(
                        foregroundColor:
                            MaterialStatePropertyAll<Color>(Colors.black),
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromARGB(255, 255, 163, 26)),
                        enableFeedback: true,
                      ),
                      child: const Text(
                        'I UNDERSTAND',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Calibre',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    margin: const EdgeInsets.all(10),
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/config');
                      },
                      style: const ButtonStyle(
                        foregroundColor:
                            MaterialStatePropertyAll<Color>(Colors.black),
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromARGB(255, 255, 163, 26)),
                        enableFeedback: true,
                      ),
                      child: const Text(
                        'Configure Prices',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Calibre',
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: FutureBuilder(
            future: loadFrontWidget(scrWidth, scrHeight),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return snapshot.requireData;
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            })));
  }
}
