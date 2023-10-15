import 'package:flutter/material.dart';
import 'dart:io';
import 'input.dart';

class Report extends StatefulWidget {
  final String pathImg;
  final List<double> rType;
  final List<double> dType;
  const Report(
      {super.key,
      required this.pathImg,
      required this.rType,
      required this.dType});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  List<Widget> dTypeW = [];
  List<Widget> rTypeW = [];
  late Widget procceedOption;
  @override
  void initState() {
    super.initState();
    setState(() {
      rTypeW.add(const Text(
          style: TextStyle(
              color: Color.fromARGB(255, 43, 10, 134),
              fontFamily: 'New Times Roman',
              fontStyle: FontStyle.normal,
              fontSize: 24),
          "Road Type"));

      dTypeW.add(const Text(
          style: TextStyle(
              color: Color.fromARGB(255, 43, 10, 134),
              fontFamily: 'New Times Roman',
              fontStyle: FontStyle.normal,
              fontSize: 24),
          "Damage Type"));
      final List<String> rTypeName = ['Asphalt', 'Concrete'];

      final List<String> dTypeName = [
        'Crack',
        'Pothole',
        'Raveling',
        'No Damage'
      ];

      for (var i = 0; i < rTypeName.length; i++) {
        String txt =
            "${rTypeName[i]}: prediction confidence -> ${(widget.rType[i] * 100).toStringAsFixed(2)}%";
        rTypeW.add(Text(
          txt,
          style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Arial',
              fontStyle: FontStyle.normal,
              fontSize: 16),
        ));
      }

      int tIndex = widget.rType[0] >= widget.rType[1] ? 0 : 1;
      bool isDamage = false;
      int dIndex = 0;
      double highesVal = widget.dType[0];
      for (var i = 0; i < dTypeName.length; i++) {
        if (widget.dType[i] > widget.dType.last) {
          isDamage = true;
          if (widget.dType[i] > highesVal) {
            highesVal = widget.dType[i];
            dIndex = i;
          }
        }
        String txt =
            "${dTypeName[i]}: prediction confidence -> ${(widget.dType[i] * 100).toStringAsFixed(2)}%";
        dTypeW.add(Text(
          txt,
          style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Arial',
              fontStyle: FontStyle.normal,
              fontSize: 16),
        ));
      }

      if (isDamage) {
        procceedOption = ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InputPanel(
                            dIndex: dIndex,
                            tIndex: tIndex,
                            imgPath: widget.pathImg,
                          )));
            },
            child: const Text('Procceed'));
      } else {
        procceedOption = Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Color.fromARGB(31, 53, 193, 228),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromARGB(31, 39, 157, 187),
                  Colors.lightBlueAccent
                ], stops: [
                  0.0,
                  0.9
                ]),
              ),
              child: const Text(
                "NO DAMAGE WAS DECTED BY AI",
                style: TextStyle(
                    color: Color.fromARGB(255, 43, 10, 134),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman',
                    fontSize: 16,
                    fontStyle: FontStyle.normal),
              ),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Report"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
              padding: const EdgeInsets.all(5),
              child: Image.file(File(widget.pathImg))),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(166, 196, 196, 202),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  width: scrWidth,
                  decoration: BoxDecoration(
                    //color: const Color.fromARGB(31, 53, 193, 228),
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(31, 39, 157, 187),
                      Colors.lightBlueAccent
                    ], stops: [
                      0.0,
                      0.8
                    ]),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: const Color.fromARGB(31, 39, 157, 187)),
                  ),
                  child: Column(
                    children: rTypeW,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: scrWidth,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(31, 39, 157, 187),
                      Colors.lightBlueAccent
                    ], stops: [
                      0.0,
                      0.8
                    ]),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: const Color.fromARGB(31, 39, 157, 187)),
                  ),
                  child: Column(
                    children: dTypeW,
                  ),
                ),
                procceedOption,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
