import 'package:flutter/material.dart';

class InputPanel extends StatefulWidget {
  const InputPanel({super.key});

  @override
  State<InputPanel> createState() => _InputPanelState();
}

class _InputPanelState extends State<InputPanel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Text("Template"),
    ));
  }
}
