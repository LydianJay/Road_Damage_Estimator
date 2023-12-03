import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

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
  final Color yCol = const Color.fromARGB(255, 255, 163, 26);

  final String temp =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

  final TextStyle tStyle = const TextStyle(
    color: Color.fromARGB(255, 255, 163, 26),
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    fontFamily: 'Arial',
    decoration: TextDecoration.none,
  );

  List<double> unitCost = [];
  List<double> usedPerUnit = [];

  @override
  void initState() {
    super.initState();
  }

  Future<Widget> displayRepairMethods() async {
    String fileData = ' ';
    String title = ' ';

    const String init =
        'Before initiating any road repair, its essential to ensure that the selected materials are suitable for the specific type and severity of the damage. Local climate conditions, traffic loads, and other factors should also be considered in material selection. Consulting with local road maintenance professionals or authorities can provide valuable guidance on the most appropriate materials for your specific situation.';

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
          ],
        ));
  }

  List<double> getUsedPerUnit() {
    return [];
  }

  Future<Table> createCostTable() async {
    String raw = await rootBundle.loadString('assets/data/cement.data');
    SharedPreferences prefs = await SharedPreferences.getInstance();

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
      rowConent.add(Text(
        '0.5',
        textAlign: TextAlign.center,
        style: tStyle,
      ));
      rowConent.add(Text(
        '200',
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
            '600', // to be change (total Cost)
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
              return Container(
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
                  ));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ],
    );
  }
}
