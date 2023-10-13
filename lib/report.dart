import 'package:flutter/material.dart';
import 'dart:io';

class Report extends StatefulWidget {
  final String pathImg;
  final List<double> value;
  const Report({super.key, required this.pathImg, required this.value});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  late List<Widget> content = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      final List<String> className = [
        'asphalt',
        'concrete',
        'crack',
        'pothole',
        'raveling',
        'no_damage'
      ];
      for (int i = 0; i < widget.value.length; i++) {
        String text =
            "${className[i]} : ${(widget.value[i] * 100.0).toStringAsFixed(2)}";
        double v = (widget.value[i] * 255.0);
        double iv = (255.0 - (widget.value[i] * 255.0));

        Color color = Color.fromRGBO(iv.toInt(), v.toInt(), 0, 1.0);
        content.add(Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25.0)),
            border: Border.all(color: color),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: color,
                fontFamily: 'New Times Roman',
                fontStyle: FontStyle.normal,
                fontSize: 16),
          ),
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
        title: const Text("Report"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Image.file(File(widget.pathImg)),
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(166, 196, 196, 202),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(25),
                  width: scrWidth,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(31, 53, 193, 228),
                    border: Border.all(color: Color.fromARGB(31, 39, 157, 187)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                          style: TextStyle(
                              color: Color.fromARGB(255, 43, 10, 134),
                              fontFamily: 'New Times Roman',
                              fontStyle: FontStyle.normal,
                              fontSize: 24),
                          "Road Type"),
                      Text(
                        "Confidence 10%",
                        style: basicStyle,
                      ),
                      Text(
                        "Confidence 20%",
                        style: basicStyle,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [Text('Damage Type'), Text('Raveling')],
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
