import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class FrontPanel extends StatelessWidget {
  final List<CameraDescription> cameras;
  const FrontPanel({super.key, required this.cameras});

  final String text =
      "This application utilizes advanced algorithms to classify images as either asphalt or concrete. However, it is essential to note that certain random images or pictures that do not depict roads or surfaces may generate inaccurate results. Factors such as lighting conditions, image quality, and varying perspectives can affect the classification accuracy."
      "The app's performance is optimized for identifying road surfaces, specifically asphalt and concrete. It might produce false positives when analyzing unrelated or dissimilar images. Users should be aware that the accuracy of classifications depends on the quality and relevance of the input images."
      "This app is designed for informational purposes and should not be solely relied upon for critical decision-making or safety-related assessments. Users are encouraged to use their judgment and not solely rely on the app's classifications, especially when the images deviate significantly from typical road surfaces."
      "By using this application, you acknowledge and accept the possibility of false positive results for images not representative of road surfaces.";

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
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
      ),
    );
  }
}
