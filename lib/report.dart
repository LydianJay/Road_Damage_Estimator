import 'package:flutter/material.dart';
import 'dart:io';

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

      for (var i = 0; i < dTypeName.length; i++) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    TextStyle basicStyle = const TextStyle(
        color: Colors.black,
        fontFamily: 'New Times Roman',
        fontStyle: FontStyle.normal,
        fontSize: 16);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Report"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color.fromARGB(166, 196, 196, 202),
              ),
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
                    color: Color.fromARGB(31, 53, 193, 228),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Color.fromARGB(31, 39, 157, 187)),
                  ),
                  child: Column(
                    children: rTypeW,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: scrWidth,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(31, 53, 193, 228),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Color.fromARGB(31, 39, 157, 187)),
                  ),
                  child: Column(
                    children: dTypeW,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
