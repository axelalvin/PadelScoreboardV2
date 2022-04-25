import 'package:flutter/material.dart';

import 'main.dart';

class Scoreboard extends StatefulWidget {
  const Scoreboard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _addPadding(30),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0.0, 15, 0.0),
              child: Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(64),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      Container(
                        height: 32,
                        color: Colors.green,
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Container(
                          height: 32,
                          width: 32,
                          color: Colors.red,
                        ),
                      ),
                      Container(
                        height: 64,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
                    children: <Widget>[
                      Container(
                        height: 64,
                        width: 128,
                        color: Colors.purple,
                      ),
                      Container(
                        height: 32,
                        color: Colors.yellow,
                      ),
                      Center(
                        child: Container(
                          height: 32,
                          width: 32,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Text('You are ugly'),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Padding _addPadding(double height) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(0.0),
        width: 80.0,
        height: height,
      ), //Container
    );
  }
}
