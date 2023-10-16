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
  final ButtonStyle bStyle = const ButtonStyle(
    iconColor:
        MaterialStatePropertyAll<Color>(Color.fromARGB(255, 255, 163, 26)),
    backgroundColor:
        MaterialStatePropertyAll<Color>(Color.fromARGB(255, 41, 41, 41)),
  );
  @override
  void initState() {
    super.initState();
    setState(() {
      rTypeW.add(const Text(
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'New Times Roman',
              fontStyle: FontStyle.normal,
              fontSize: 24),
          "Road Type"));

      dTypeW.add(const Text(
          style: TextStyle(
              color: Colors.white,
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
              color: Color.fromARGB(255, 156, 156, 156),
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
              color: Color.fromARGB(255, 156, 156, 156),
              fontFamily: 'Arial',
              fontStyle: FontStyle.normal,
              fontSize: 16),
        ));
      }

      if (isDamage) {
        procceedOption = ElevatedButton.icon(
          style: bStyle,
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
          icon: const Icon(Icons.arrow_circle_right_rounded),
          label: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(),
                  color: const Color.fromARGB(255, 255, 163, 26)),
              child: const Text(
                'Proceed',
                style: TextStyle(
                    fontFamily: 'Helvetica',
                    color: Color.fromARGB(255, 0, 0, 0)),
              )),
        );
      } else {
        procceedOption = Container(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 128, 128, 128),
              ),
              child: const Text(
                "NO DAMAGE WAS DECTED BY AI",
                style: TextStyle(
                    color: Colors.black,
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
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        title: Container(
          padding: EdgeInsets.all(scrWidth / 8),
          child: Row(children: [
            const Text('Image '),
            Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(),
                    color: const Color.fromARGB(255, 255, 163, 26)),
                child: const Text(
                  'Report',
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      color: Color.fromARGB(255, 0, 0, 0)),
                )),
          ]),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            color: const Color.fromARGB(255, 27, 27, 27),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(5),
                    child: Image.file(File(widget.pathImg))),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 27, 27, 27),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: scrWidth,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 41, 41, 41),
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
                          color: const Color.fromARGB(255, 41, 41, 41),
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
          )
        ],
      ),
    );
  }
}
