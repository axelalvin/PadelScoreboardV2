import 'package:flutter/material.dart';
import 'package:padel_scoreboard/Scoreboard/team.dart';
import 'match.dart';

class Scoreboard extends StatefulWidget {
  const Scoreboard({
    Key? key,
    required this.title,
    required this.maxSets,
    required this.goldenPoint,
    required this.team1Name,
    required this.team2Name,
  }) : super(key: key);

  final String title;
  final int maxSets;
  final bool goldenPoint;
  final String team1Name;
  final String team2Name;

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  static const double columnHeight = 60.0;
  static const double nameColumnWidth = 100.0;
  static const double scoreColumnWidth = 37.0;

  late Match match;

  late Team team1;
  late Team team2;

  late int maxSets;

  double buttonsWidth = 85;
  double buttonsHeight = 85;

  @override
  void initState() {
    team1 = Team(1, widget.team1Name, widget.maxSets);
    team2 = Team(2, widget.team2Name, widget.maxSets);

    match = Match(widget.maxSets, widget.goldenPoint, team1, team2);

    maxSets = widget.maxSets;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return porttraitMode();
        } else {
          return landscapeMode();
        }
      }),
      //porttraitMode(),
    );
  }

  Center porttraitMode() {
    return Center(
      child: Column(
        children: <Widget>[
          _addVertPadding(15),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0.0, 15, 0.0),
            child: Table(
              border: TableBorder.symmetric(
                inside: const BorderSide(width: 2, color: Colors.white),
              ),
              columnWidths: _initColumns(maxSets),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                TableRow(
                  children: () {
                    if (team1.hasServe) {
                      return _paintColumns(maxSets, team1, Colors.yellow);
                    } else {
                      return _paintColumns(maxSets, team1, Colors.white);
                    }
                  }(),
                ),
                TableRow(
                  children: () {
                    if (team2.hasServe) {
                      return _paintColumns(maxSets, team2, Colors.yellow);
                    } else {
                      return _paintColumns(maxSets, team2, Colors.white);
                    }
                  }(),
                ),
              ],
            ),
          ),
          _addVertPadding(30),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _addButtons(team1),
              _addHorizPadding(20),
              _addButtons(team2),
            ],
          ),
          _addVertPadding(100),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 192, 86, 78),
            ),
            onPressed: () {
              setState(() {
                match.resetScoreboard();
              });
            },
            child: const Text(
              'Reset scoreboard',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center landscapeMode() {
    return Center(
      child: Column(
        children: <Widget>[
          _addVertPadding(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    _addButtons(team1),
                  ],
                ),
              ),
              _addHorizPadding(20),
              Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0.0, 15, 0.0),
                      child: Table(
                        border: TableBorder.symmetric(
                          inside:
                              const BorderSide(width: 2, color: Colors.white),
                        ),
                        columnWidths: _initColumns(maxSets),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(
                            children: () {
                              if (team1.hasServe) {
                                return _paintColumns(
                                    maxSets, team1, Colors.yellow);
                              } else {
                                return _paintColumns(
                                    maxSets, team1, Colors.white);
                              }
                            }(),
                          ),
                          TableRow(
                            children: () {
                              if (team2.hasServe) {
                                return _paintColumns(
                                    maxSets, team2, Colors.yellow);
                              } else {
                                return _paintColumns(
                                    maxSets, team2, Colors.white);
                              }
                            }(),
                          ),
                        ],
                      ),
                    ),
                    _addVertPadding(50),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(255, 192, 86, 78),
                      ),
                      onPressed: () {
                        setState(() {
                          match.resetScoreboard();
                        });
                      },
                      child: const Text(
                        'Reset scoreboard',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _addHorizPadding(20),
              Center(
                child: Column(
                  children: <Widget>[
                    _addButtons(team2),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<int, TableColumnWidth>? _initColumns(int sets) {
    if (sets == 3) {
      return const <int, TableColumnWidth>{
        0: FixedColumnWidth(nameColumnWidth),
        1: FixedColumnWidth(scoreColumnWidth),
        2: FixedColumnWidth(scoreColumnWidth),
        3: FixedColumnWidth(scoreColumnWidth),
        4: FixedColumnWidth(scoreColumnWidth),
        5: FixedColumnWidth(scoreColumnWidth),
        6: FixedColumnWidth(scoreColumnWidth),
      };
    }
    if (sets == 5) {
      return const <int, TableColumnWidth>{
        0: FixedColumnWidth(nameColumnWidth),
        1: FixedColumnWidth(scoreColumnWidth),
        2: FixedColumnWidth(scoreColumnWidth),
        3: FixedColumnWidth(scoreColumnWidth),
        4: FixedColumnWidth(scoreColumnWidth),
        5: FixedColumnWidth(scoreColumnWidth),
        6: FixedColumnWidth(scoreColumnWidth),
        7: FixedColumnWidth(scoreColumnWidth),
        8: FixedColumnWidth(scoreColumnWidth),
      };
    }
    return null;
  }

  List<Widget>? _paintColumns(int sets, Team team, Color teamNameColor) {
    List<Widget>? list = [];
    //list.add(_paintContainer(team.teamName, Colors.blueGrey, teamNameColor));
    list.add(_paintClickableInkWell(
        team.teamName, team, Colors.blueGrey, teamNameColor));

    for (int i = 0; i < sets; i++) {
      list.add(_paintContainer(team.gameCount[i].toString(),
          const Color.fromARGB(255, 104, 145, 188), Colors.white));
    }

    list.add(_paintContainer(team.setCount.toString(),
        const Color.fromARGB(255, 192, 86, 78), Colors.white));

    list.add(
        _paintContainer(team.currentGameScore, Colors.blueGrey, Colors.yellow));

    return list;
  }

  Container _paintContainer(String text, Color? columnColor, Color? textColor) {
    return Container(
      height: columnHeight,
      //color: columnColor,
      decoration: BoxDecoration(
        color: columnColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  InkWell _paintClickableInkWell(
      String text, Team team, Color? columnColor, Color? textColor) {
    return InkWell(
      onTap: () {
        setState(() {
          match.setServe(team);
        });
      },
      child: Ink(
        height: columnHeight,
        //color: columnColor,
        decoration: BoxDecoration(
          color: columnColor,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Center _addButtons(Team team) {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            team.teamName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          _addVertPadding(5),
          const Text(
            'Point',
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: buttonsWidth, // <-- Your width
                height: buttonsHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: () {
                    if (!match.matchFinished) {
                      setState(() {
                        match.addPoint(team);
                      });
                    }
                  },
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              _addHorizPadding(5),
              SizedBox(
                width: buttonsWidth, // <-- Your width
                height: buttonsHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 192, 86, 78),
                  ),
                  onPressed: () {
                    if (!match.matchFinished) {
                      setState(() {
                        match.removePoint(team);
                      });
                    }
                  },
                  child: const Text(
                    '-',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          _addVertPadding(15),
          const Text(
            'Game',
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: buttonsWidth, // <-- Your width
                height: buttonsHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: () {
                    if (!match.matchFinished) {
                      setState(() {
                        match.addGame(team);
                      });
                    }
                  },
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              _addHorizPadding(5),
              SizedBox(
                width: buttonsWidth, // <-- Your width
                height: buttonsHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 192, 86, 78),
                  ),
                  onPressed: () {
                    if (!match.matchFinished) {
                      setState(() {
                        match.removeGame(team);
                      });
                    }
                  },
                  child: const Text(
                    '-',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding _addVertPadding(double height) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        padding: const EdgeInsets.all(0.0),
        width: 80.0,
        height: height,
      ), //Container
    );
  }

  Padding _addHorizPadding(double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        padding: const EdgeInsets.all(0.0),
        width: width,
        height: 10.0,
      ), //Container
    );
  }
}
