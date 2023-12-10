import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class EstimatePanel extends StatefulWidget {
  final String imgPath;
  final int dType, rType;
  final double volume, area;
  const EstimatePanel({
    super.key,
    required this.imgPath,
    required this.dType,
    required this.rType,
    required this.volume,
    required this.area,
  });

  @override
  State<EstimatePanel> createState() => _EstimatePanelState();
}

class _EstimatePanelState extends State<EstimatePanel> {
  final Color yCol = const Color.fromARGB(255, 255, 163, 26);
  final ctrlScr = ScreenshotController();
  final TextStyle tStyle = const TextStyle(
    color: Color.fromARGB(255, 255, 163, 26),
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    fontFamily: 'Arial',
    decoration: TextDecoration.none,
  );
  Map<String, double> costPerUnit = {};

  @override
  void initState() {
    super.initState();
  }

  Future<Widget> displayRepairMethods() async {
    String fileData = ' ';
    String title = ' ';

    const String init =
        'Before initiating any road repair, its essential to ensure that the selected materials are suitable for the specific type and severity of the damage. Local climate conditions, traffic loads, and other factors should also be considered in material selection.';

    switch (widget.dType) {
      case 0: // pothole
        fileData = await rootBundle.loadString('assets/data/m_crack.txt');
        title = 'Crack Repair:';

        break;
      case 1: // crack
        fileData = await rootBundle.loadString('assets/data/m_pothole.txt');
        title = 'Pothole Repair:';
        break;
      case 2: //raveling
        fileData = await rootBundle.loadString('assets/data/m_raveling.txt');
        title = 'Raveling Repair:';
        break;
    }

    return Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Calibre',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: yCol,
                      decoration: TextDecoration.none,
                    ),
                  ),
                )
              ],
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  fileData,
                  style: const TextStyle(
                    fontFamily: 'Times new roman',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                )),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text(
                init,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Times new roman',
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ));
  }

  Map<String, double> getCost() {
    Map<String, double> ret = Map.from(costPerUnit);

    debugPrint('Uni cost lenth: ${costPerUnit.length}');

    ret.forEach((name, value) {
      ret[name] = 0;
    });

    costPerUnit.forEach((name, price) {
      debugPrint('Item name: $name  : price $price');
    });

    switch (widget.dType) {
      case 0: //crack
        ret['Rubberized Asphalt'] =
            widget.area * 2.5 * costPerUnit['Rubberized Asphalt']!;
        ret['Rubberized Asphalt Used'] = widget.area * 2.5;
        break;
      case 1: // pothole
        ret['Cold Mix Asphalt'] =
            widget.volume * 558.8 * costPerUnit['Cold Mix Asphalt']!;
        ret['Cold Mix Asphalt Used'] = widget.volume * 558.8;
        break;
      case 2: // raveling
        ret['Cold Mix Asphalt'] =
            (widget.volume * 0.25) * 558.8 * costPerUnit['Cold Mix Asphalt']!;
        ret['Cold Mix Asphalt Used'] = (widget.volume * 0.25) * 558.8;
        ret['Fine Aggregate'] =
            (widget.volume * 0.75) * costPerUnit['Fine Aggregate']!;
        ret['Fine Aggregate Used'] =
            (widget.volume * 0.75) * costPerUnit['Fine Aggregate']!;
        break;
    }

    return ret;
  }

  Future<void> parseString(String raw) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    costPerUnit = {};
    raw.split('\n').forEach((line) {
      int count = 0;

      String itemName = 'NULL';
      line.split('\t').forEach((cell) {
        debugPrint('count: $count');
        if (count == 0) {
          itemName = cell;
        }
        if (count == 2) {
          double? test = prefs.getDouble(itemName);
          cell = cell.replaceAll(r',', '');
          if (test != null) {
            cell = test.toString();
            debugPrint('adding cost');
            costPerUnit[itemName] = test;
          }
        }
        count++;
      });
    });
    debugPrint('Done parsing, length: ${costPerUnit.length}');
  }

  Future<Table> createCostTable() async {
    String raw = await rootBundle.loadString('assets/data/cement.data');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await parseString(raw);

    debugPrint('Count:  ${costPerUnit.length}');
    costPerUnit.forEach((key, value) {
      debugPrint("Key: $key, Value: $value");
    });

    List<TableRow> rows = [
      TableRow(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 27, 27, 27),
          border: Border.all(color: Colors.black),
        ),
        children: [
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
          ),
          Text(
            'Used per unit',
            textAlign: TextAlign.center,
            style: tStyle,
          ),
          Text(
            'Cost',
            textAlign: TextAlign.center,
            style: tStyle,
          ),
        ],
      )
    ];
    double totalCost = 0;
    raw.split('\n').forEach((line) {
      List<Widget> rowConent = [];
      int count = 0;

      String itemName = 'NULL';

      line.split('\t').forEach((cell) {
        if (count == 0) {
          itemName = cell;
        }
        if (count == 2) {
          double? test = prefs.getDouble(itemName);
          cell = cell.replaceAll(r',', '');
          if (test != null) {
            cell = test.toString();

            costPerUnit[itemName] = test;

            debugPrint('Read default saved value! $itemName');
          }

          rowConent.add(Text(
            cell,
            textAlign: TextAlign.center,
            style: tStyle,
          ));
        } else {
          rowConent.add(Container(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Text(
              cell,
              textAlign: TextAlign.center,
              style: tStyle,
            ),
          ));
        }
        count++;
      });
      // dummy for now
      var mapVal = getCost();
      totalCost += mapVal[itemName]!;

      for (var element in mapVal.keys) {
        debugPrint('[keys:$element]');
      }
      rowConent.add(
        Text(
          mapVal.containsKey('$itemName Used')
              ? mapVal['$itemName Used']!.toStringAsFixed(2)
              : '0',
          textAlign: TextAlign.center,
          style: tStyle,
        ),
      );
      rowConent.add(Text(
        mapVal[itemName]!.toStringAsFixed(2),
        textAlign: TextAlign.center,
        style: tStyle,
      ));
      TableRow r = TableRow(
        children: rowConent,
      );

      rows.add(r);
    });

    rows.add(
      TableRow(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 41, 41, 41),
          border: Border.all(color: Colors.blueAccent),
        ),
        children: [
          Text(
            'Total Estimated cost',
            textAlign: TextAlign.center,
            style: tStyle,
          ),
          Text(
            ' ',
            textAlign: TextAlign.center,
            style: tStyle,
          ),
          Text(
            ' ',
            textAlign: TextAlign.center,
            style: tStyle,
          ),
          Text(
            ' ',
            textAlign: TextAlign.center,
            style: tStyle,
          ),
          Text(
            totalCost.toStringAsFixed(2),
            textAlign: TextAlign.center,
            style: tStyle,
          ),
        ],
      ),
    );
    debugPrint('Row count ${rows.length}');

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth()
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(color: Colors.white),
      children: rows,
    );
  }

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
                child: Image.file(File(widget.imgPath)),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: displayRepairMethods(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                  child: snapshot.requireData);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
        ),
        FutureBuilder(
          future: createCostTable(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Screenshot(
                    controller: ctrlScr,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Text(
                              'Estimated Cost',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 163, 26),
                                fontSize: 24,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial',
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          snapshot.requireData,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: FilledButton(
                      onPressed: () {
                        ctrlScr.capture().then((img) {
                          //File('captured.png').writeAsBytes(img!.toList());
                          ImageGallerySaver.saveImage(img!);
                        });
                      },
                      style: const ButtonStyle(
                        foregroundColor:
                            MaterialStatePropertyAll<Color>(Colors.black),
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromARGB(255, 255, 163, 26)),
                        enableFeedback: true,
                      ),
                      child: const Text(
                        'Save Table As Image',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Calibre',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ],
    );
  }
}
