import 'package:flutter/material.dart';
import 'dart:io';

class InputPanel extends StatefulWidget {
  final int dIndex, tIndex;
  final String imgPath;
  const InputPanel(
      {super.key,
      required this.dIndex,
      required this.tIndex,
      required this.imgPath});

  @override
  State<InputPanel> createState() => _InputPanelState();
}

class _InputPanelState extends State<InputPanel> {
  late int dSelect, rSelect;
  @override
  void initState() {
    super.initState();
    dSelect = widget.dIndex;
    rSelect = widget.tIndex;
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    const List<String> rTypeName = ['Asphalt', 'Concrete'];
    const List<String> dTypeName = [
      'Crack',
      'Pothole',
      'Raveling',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configure"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            width: scrWidth,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [
                Color.fromARGB(31, 39, 157, 187),
                Colors.lightBlueAccent
              ], stops: [
                0.0,
                0.8
              ]),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color.fromARGB(31, 39, 157, 187)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black54)),
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                          style: TextStyle(
                              color: Color.fromARGB(255, 43, 10, 134),
                              fontFamily: 'New Times Roman',
                              fontStyle: FontStyle.normal,
                              fontSize: 24),
                          "Road Type"),
                      DropdownMenu<String>(
                          initialSelection: rTypeName[widget.tIndex],
                          onSelected: (String? val) {
                            setState(() {
                              rSelect = rTypeName.indexOf(val!);
                            });
                          },
                          dropdownMenuEntries: rTypeName
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black54)),
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                          style: TextStyle(
                              color: Color.fromARGB(255, 43, 10, 134),
                              fontFamily: 'New Times Roman',
                              fontStyle: FontStyle.normal,
                              fontSize: 24),
                          "Damage Type"),
                      DropdownMenu<String>(
                          onSelected: (String? val) {
                            setState(() {
                              dSelect = dTypeName.indexOf(val!);
                            });
                          },
                          initialSelection: dTypeName[widget.dIndex],
                          dropdownMenuEntries: dTypeName
                              .map<DropdownMenuEntry<String>>((String value) {
                            return DropdownMenuEntry<String>(
                                value: value, label: value);
                          }).toList()),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(5),
                    child: Image.file(File(widget.imgPath))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
