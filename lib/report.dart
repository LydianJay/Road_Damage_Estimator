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
      List<String> className = [
        'asphalt',
        'concrete',
        'crack',
        'pothole',
        'raveling',
        'no_damage'
      ];
      for (int i = 0; i < widget.value.length; i++) {
        String text = "${className[i]} : ${widget.value[i]}";
        double r = (widget.value[i] * 255.0);
        double g = (255.0 - (widget.value[i] * 255.0));
        Color color = Color.fromRGBO(r.toInt(), g.toInt(), r.toInt(), 1.0);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Image.file(File(widget.pathImg)),
          Column(children: content),
        ],
      ),
    );
  }
}
