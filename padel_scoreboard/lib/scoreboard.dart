import 'package:flutter/material.dart';

import 'main.dart';

class Scoreboard extends StatefulWidget {
  const Scoreboard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Scoreboard> createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  static const double columnHeight = 60.0;
  static const double nameColumnWidth = 100.0;
  static const double scoreColumnWidth = 37.0;

  int max_sets = 5;
  bool golden_point = false;

  bool gameDeuce = false;
  bool setDeuce = false;
  bool tieBreak = false;
  bool match_finished = false;

  String team1 = 'ALV/PET';
  String team2 = 'PET/ALV';

  int currSet = 0;
  List<int> team1GameCount = [];
  List<int> team2GameCount = [];

  int team1SetCount = 0;
  int team2SetCount = 0;

  List<int> scoreList = [0, 15, 30, 40, 41];
  String team1CurrentGameScore = '0';
  int team1ScorePos = 0;
  String team2CurrentGameScore = '0';
  int team2ScorePos = 0;

  @override
  void initState() {
    team1CurrentGameScore = scoreList[team1ScorePos].toString();
    team2CurrentGameScore = scoreList[team2ScorePos].toString();

    for (int i = 0; i < max_sets; i++) {
      team1GameCount.add(0);
      team2GameCount.add(0);
    }
    super.initState();
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
            _addVertPadding(15),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0.0, 15, 0.0),
              child: Table(
                border: TableBorder.all(),
                columnWidths: _initColumns(max_sets),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: _paintColumns(max_sets, team1, 1),
                  ),
                  TableRow(
                    children: _paintColumns(max_sets, team2, 2),
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
                Text(
                  team1,
                ),
                _addHorizPadding(35),
                Text(
                  team2,
                ),
              ],
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  //style: style,
                  onPressed: () {
                    if (gameDeuce)
                      _addDeucePoint(1);
                    else if (!match_finished && !gameDeuce) _addPoint(1);
                  },
                  child: const Text('Point'),
                ),
                _addHorizPadding(20),
                ElevatedButton(
                  //style: style,
                  onPressed: () {
                    if (gameDeuce)
                      _addDeucePoint(2);
                    else if (!match_finished && !gameDeuce) _addPoint(2);
                  },
                  child: const Text('Point'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  //style: style,
                  onPressed: () {
                    if (setDeuce)
                      _addDeuceGame(1);
                    else if (!match_finished && !setDeuce) _addGame(1);
                  },
                  child: const Text('Game'),
                ),
                _addHorizPadding(20),
                ElevatedButton(
                  //style: style,
                  onPressed: () {
                    if (setDeuce)
                      _addDeuceGame(2);
                    else if (!match_finished && !setDeuce) _addGame(2);
                  },
                  child: const Text('Game'),
                ),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _addPoint(int team) {
    setState(() {
      if (team == 1) {
        team1ScorePos++;
        if (scoreList[team1ScorePos] == 41) {
          //end of game
          _addGame(team);
        } else {
          team1CurrentGameScore = scoreList[team1ScorePos].toString();
        }
      } else {
        team2ScorePos++;
        if (scoreList[team2ScorePos] == 41) {
          //end of game
          _addGame(team);
        } else {
          team2CurrentGameScore = scoreList[team2ScorePos].toString();
        }
      }
      if (!golden_point) {
        if (scoreList[team1ScorePos] == 40 && scoreList[team2ScorePos] == 40) {
          gameDeuce = true;
        }
      }
    });
  }

  void _addDeucePoint(int team) {
    bool deuce = false, team1adv = false, team2adv = false;
    String adv = 'Adv';
    if (team1CurrentGameScore == '40' && team2CurrentGameScore == '40') {
      deuce = true;
    }
    if (team1CurrentGameScore == adv) {
      team1adv = true;
    }
    if (team2CurrentGameScore == adv) {
      team2adv = true;
    }
    setState(() {
      if (team == 1) {
        if (deuce) {
          team1CurrentGameScore = adv;
          team2CurrentGameScore = '';
        } else {
          if (team1adv) {
            _addGame(team);
            gameDeuce = false;
          } else {
            team1CurrentGameScore = scoreList[team1ScorePos].toString();
            team2CurrentGameScore = scoreList[team2ScorePos].toString();
          }
        }
      } else {
        if (deuce) {
          team2CurrentGameScore = adv;
          team1CurrentGameScore = '';
        } else {
          if (team2adv) {
            _addGame(team);
            gameDeuce = false;
          } else {
            team1CurrentGameScore = scoreList[team1ScorePos].toString();
            team2CurrentGameScore = scoreList[team2ScorePos].toString();
          }
        }
      }
    });
  }

  void _resetPoints() {
    team1ScorePos = 0;
    team2ScorePos = 0;

    setState(() {
      team1CurrentGameScore = scoreList[team1ScorePos].toString();
      team2CurrentGameScore = scoreList[team2ScorePos].toString();
    });
  }

  void _addGame(int team) {
    setState(() {
      _resetPoints();
      if (team == 1) {
        team1GameCount[currSet]++;
        if (team1GameCount[currSet] == 6) {
          if (currSet < max_sets - 1) {
            team1SetCount++;
            currSet++;
          } else {
            team1SetCount++;
            match_finished = true;
          }
        }
      } else {
        team2GameCount[currSet]++;
        if (team2GameCount[currSet] == 6) {
          if (currSet < max_sets - 1) {
            team2SetCount++;
            currSet++;
          } else {
            team2SetCount++;
            match_finished = true;
          }
        }
      }

      if (team1GameCount[currSet] == 5 && team2GameCount[currSet] == 5) {
        setDeuce = true;
      }
    });
  }

  void _addDeuceGame(int team) {
    setState(() {
      _resetPoints();
      if (team == 1) {
      } else {}
    });
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
  }

  List<Widget>? _paintColumns(int sets, String teamName, int team) {
    List<Widget>? list = [];
    list.add(_paintContainer(teamName, Colors.blue));

    for (int i = 0; i < sets; i++) {
      if (team == 1) {
        list.add(_paintContainer(team1GameCount[i].toString(), Colors.green));
      } else {
        list.add(_paintContainer(team2GameCount[i].toString(), Colors.green));
      }
    }
    if (team == 1) {
      list.add(_paintContainer(team1SetCount.toString(), Colors.red));
    } else {
      list.add(_paintContainer(team2SetCount.toString(), Colors.red));
    }
    if (team == 1) {
      list.add(_paintContainer(team1CurrentGameScore, Colors.yellow));
    } else {
      list.add(_paintContainer(team2CurrentGameScore, Colors.yellow));
    }

    return list;
  }

  Container _paintContainer(String text, Color? color) {
    return Container(
      height: columnHeight,
      color: color,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(),
        ),
      ),
    );
  }

  Padding _addVertPadding(double height) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(0.0),
        width: 80.0,
        height: height,
      ), //Container
    );
  }

  Padding _addHorizPadding(double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(0.0),
        width: width,
        height: 10.0,
      ), //Container
    );
  }
}
