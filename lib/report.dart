import 'package:flutter/material.dart';
import 'dart:io';

class Report extends StatefulWidget {
  final String data;
  final String pathImg;
  const Report({super.key, required this.data, required this.pathImg});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String textContent = "Fuck";

  @override
  void initState() {
    super.initState();
    setState(() {
      textContent = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: 600.0, // Set the desired width
              height: 400.0, // Set the desired height
              child: Image.file(
                  File(widget.pathImg)), // Replace with your image asset
            ),
            Center(
              child: Text(textContent),
            ),
          ],
        ),
      ),
    );
  }
}
