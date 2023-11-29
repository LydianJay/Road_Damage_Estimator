import 'package:flutter/material.dart';
import 'dart:io';

class EstimatePanel extends StatefulWidget {
  final String imgPath;
  final int dType, rType;
  final double volume;
  const EstimatePanel({
    super.key,
    required this.imgPath,
    required this.dType,
    required this.rType,
    required this.volume,
  });

  @override
  State<EstimatePanel> createState() => _EstimatePanelState();
}

class _EstimatePanelState extends State<EstimatePanel> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 41, 41, 41)),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(5),
                  child: Image.file(File(widget.imgPath)))
            ],
          ),
        ),
      ],
    );
  }
}
