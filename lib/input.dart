import 'package:flutter/material.dart';

class InputPanel extends StatefulWidget {
  final int dIndex, tIndex;
  const InputPanel({
    super.key,
    required this.dIndex,
    required this.tIndex,
  });

  @override
  State<InputPanel> createState() => _InputPanelState();
}

class _InputPanelState extends State<InputPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Metrics"),
        centerTitle: true,
      ),
      body: ListView(
        children: [Text("${widget.dIndex}\n${widget.tIndex}")],
      ),
    );
  }
}
