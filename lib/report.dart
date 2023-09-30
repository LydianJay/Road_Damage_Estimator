import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  final String data;
  const Report({super.key, required this.data});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  String textContent = "Fuck";

  void updateValue() {
    setState(() {
      textContent = widget.data;
    });
  }

  @override
  void initState() {
    super.initState();
    updateValue();
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
            Center(
              child: Text(textContent),
            ),
          ],
        ),
      ),
    );
  }
}
