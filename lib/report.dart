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
  String textContent = "";

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
        textContent += "${className[i]} : ${widget.value[i]}\n";
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
          Center(
            child: Text(textContent),
          ),
        ],
      ),
    );
  }
}
