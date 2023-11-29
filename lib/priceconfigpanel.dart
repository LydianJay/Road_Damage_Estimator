import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class PriceConfigPanel extends StatefulWidget {
  const PriceConfigPanel({super.key});

  @override
  State<PriceConfigPanel> createState() => _PriceConfigPanelState();
}

class _PriceConfigPanelState extends State<PriceConfigPanel> {
  List<List<String>> priceData = [];
  List<TextEditingController> priceControllers = [];

  Table table = Table();
  late SharedPreferences prefs;
  Future<String> loadTextFiles() async {
    return await rootBundle.loadString('assets/data/cement.data');
  }

  void loadConfig() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    loadConfig();
    loadTextFiles().then((raw) => {
          setState(() {
            const TextStyle tStyle = TextStyle(
              color: Color.fromARGB(255, 255, 163, 26),
              fontSize: 22,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arial',
            );
            List<TableRow> rows = [
              TableRow(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 27, 27, 27),
                  border: Border.all(color: Colors.black),
                ),
                children: const [
                  Text(
                    'Material Description',
                    textAlign: TextAlign.center,
                    style: tStyle,
                  ),
                  Text(
                    'Unit',
                    textAlign: TextAlign.center,
                    style: tStyle,
                  ),
                  Text(
                    'Price (PHP)',
                    textAlign: TextAlign.center,
                    style: tStyle,
                  )
                ],
              )
            ];

            raw.split('\n').forEach((String line) {
              List<Widget> rowConent = [];
              int count = 0;

              String itemName = 'NULL';
              line.split('\t').forEach((str) {
                if (count == 0) {
                  itemName = str;
                }
                if (count == 2) {
                  double? test = prefs.getDouble(itemName);
                  str = str.replaceAll(r',', '');
                  if (test != null) {
                    str = test.toString();
                    debugPrint('Read default saved value! $itemName');
                  }

                  prefs.setDouble(itemName, double.parse(str)).then((value) => {
                        debugPrint(value
                            ? 'successfully saved $itemName'
                            : 'failed saving')
                      });

                  priceControllers.add(TextEditingController(text: str));
                  rowConent.add(TextField(
                    controller: priceControllers.last,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onSubmitted: (String subVal) {
                      setState(() {
                        prefs.setDouble(itemName, double.parse(subVal));
                        priceControllers.last.text = subVal;
                      });
                    },
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial',
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Peso',
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ));
                } else {
                  rowConent.add(Container(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Text(
                      str,
                      textAlign: TextAlign.center,
                      style: tStyle,
                    ),
                  ));
                }
                count++;
              });

              TableRow r = TableRow(
                children: rowConent,
              );
              rows.add(r);
            });

            table = Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(color: Colors.white),
              children: rows,
            );
          })
        });
  }

  @override
  void dispose() {
    super.dispose();
    for (var d in priceControllers) {
      d.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    //double scrHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        title: Container(
          padding: EdgeInsets.all(scrWidth / 8),
          child: Row(children: [
            const Text('Price '),
            Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(),
                    color: const Color.fromARGB(255, 255, 163, 26)),
                child: const Text(
                  'List',
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
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 41, 41, 41)),
            child: Column(
              children: [
                table,
                /*TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  
                  decoration: InputDecoration(
                    label: Text('Asphalt:'),
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 163, 26),
                        fontSize: 20,
                        fontFamily: 'Calibre',
                        fontWeight: FontWeight.bold),
                    hintText: 'meters',
                    hintStyle: TextStyle(fontSize: 12),
                  ),
                ),
                TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    label: Text('Concrete Mix:'),
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 163, 26),
                        fontSize: 20,
                        fontFamily: 'Calibre',
                        fontWeight: FontWeight.bold),
                    hintText: 'meters',
                    hintStyle: TextStyle(fontSize: 12),
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
