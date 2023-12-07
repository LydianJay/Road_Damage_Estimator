import 'package:flutter/material.dart';
import 'dart:io';

import 'package:pothole/estimationpanel.dart';

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
  final TextEditingController ctrlLength = TextEditingController();
  final TextEditingController ctrlWidth = TextEditingController();
  final TextEditingController ctrlDepth = TextEditingController();
  @override
  void initState() {
    super.initState();
    dSelect = widget.dIndex;
    rSelect = widget.tIndex;
  }

  Future<void> _showAlertDialog() async {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Empty Fields'),
          content: SizedBox(
            width: scrWidth,
            height: scrHeight * 0.15,
            child: const Text('Please enter the necessary input fields'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        title: Container(
          padding: EdgeInsets.all(scrWidth / 8),
          child: Row(children: [
            const Text('Configure '),
            Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(),
                    color: const Color.fromARGB(255, 255, 163, 26)),
                child: const Text(
                  'Image',
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      color: Color.fromARGB(255, 0, 0, 0)),
                )),
          ]),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            width: scrWidth,
            color: const Color.fromARGB(255, 27, 27, 27),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      color: const Color.fromARGB(255, 128, 128, 128)),
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'New Times Roman',
                              fontStyle: FontStyle.normal,
                              fontSize: 24),
                          "Road Type"),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 163, 26),
                          border: Border.all(color: Colors.white),
                        ),
                        child: DropdownMenu<String>(
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
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      color: const Color.fromARGB(255, 128, 128, 128)),
                  margin: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'New Times Roman',
                              fontStyle: FontStyle.normal,
                              fontSize: 24),
                          "Damage Type"),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 163, 26),
                          border: Border.all(color: Colors.white),
                        ),
                        child: DropdownMenu<String>(
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
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(5),
                    child: Image.file(File(widget.imgPath))),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        color: const Color.fromARGB(255, 128, 128, 128)),
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.all(3),
                            child: const Text('Width')),
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: SizedBox(
                            width: (scrWidth * 0.55),
                            child: TextField(
                              controller: ctrlWidth,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: 'meters',
                                  hintStyle: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        color: const Color.fromARGB(255, 128, 128, 128)),
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.all(3),
                            child: const Text('Length')),
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: SizedBox(
                            width: (scrWidth * 0.55),
                            child: TextField(
                              controller: ctrlLength,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: 'meters',
                                  hintStyle: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        color: const Color.fromARGB(255, 128, 128, 128)),
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.all(3),
                            child: const Text('Depth')),
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: SizedBox(
                            width: (scrWidth * 0.55),
                            child: TextField(
                              controller: ctrlDepth,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: 'meters',
                                  hintStyle: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.all(25),
                  child: FilledButton(
                    onPressed: () {
                      if (double.tryParse(ctrlDepth.text) == null ||
                          double.tryParse(ctrlLength.text) == null ||
                          double.tryParse(ctrlWidth.text) == null) {
                        _showAlertDialog();
                      }

                      double vol = double.parse(ctrlDepth.text) *
                          double.parse(ctrlLength.text) *
                          double.parse(ctrlWidth.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EstimatePanel(
                                    imgPath: widget.imgPath,
                                    dType: dSelect,
                                    rType: rSelect,
                                    volume: vol,
                                    area: double.parse(ctrlLength.text) *
                                        double.parse(ctrlWidth.text),
                                  )));
                    },
                    style: const ButtonStyle(
                      foregroundColor:
                          MaterialStatePropertyAll<Color>(Colors.black),
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Color.fromARGB(255, 255, 163, 26)),
                      enableFeedback: true,
                    ),
                    child: const Text('SUBMIT'),
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
