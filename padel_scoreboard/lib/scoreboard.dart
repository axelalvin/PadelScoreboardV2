import 'package:flutter/material.dart';

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

  late int maxSets;
  late bool goldenPoint = false;

  late String team1Name;
  late String team2Name;

  bool gameDeuce = false;
  bool setDeuce = false;
  bool tieBreak = false;
  bool tieBreakDeuce = false;
  int team1TieBreakScore = 0;
  int team2TieBreakScore = 0;
  bool matchFinished = false;

  int currSet = 0;
  List<int> team1GameCount = [];
  List<int> team2GameCount = [];

  int team1SetCount = 0;
  int team2SetCount = 0;

  List<int> scoreList = [0, 15, 30, 40, 41];
  late String team1CurrentGameScore;
  int team1ScorePos = 0;
  late String team2CurrentGameScore;
  int team2ScorePos = 0;

  @override
  void initState() {
    maxSets = widget.maxSets;
    goldenPoint = widget.goldenPoint;
    team1Name = widget.team1Name;
    team2Name = widget.team2Name;
    team1CurrentGameScore = scoreList[team1ScorePos].toString();
    team2CurrentGameScore = scoreList[team2ScorePos].toString();

    for (int i = 0; i < maxSets; i++) {
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
              child: Container(
                child: Table(
                  //border: TableBorder.all(),
                  border: TableBorder.symmetric(
                    inside: BorderSide(width: 2, color: Colors.white),
                    //outside: BorderSide(width: 1)
                  ),
                  columnWidths: _initColumns(maxSets),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      children: _paintColumns(maxSets, team1Name, 1),
                    ),
                    TableRow(
                      children: _paintColumns(maxSets, team2Name, 2),
                    ),
                  ],
                ),
              ),
            ),
            _addVertPadding(30),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _addButtons(team1Name, 1),
                _addHorizPadding(30),
                _addButtons(team2Name, 2),
              ],
            ),
            _addVertPadding(30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 192, 86, 78),
              ),
              onPressed: () {
                _resetScoreboard();
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _addPoint(int team) {
    if (gameDeuce) {
      _addDeucePoint(team);
    } else {
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
        if (!goldenPoint) {
          if (scoreList[team1ScorePos] == 40 &&
              scoreList[team2ScorePos] == 40) {
            gameDeuce = true;
          }
        }
      });
    }
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
    if (setDeuce) {
      _addDeuceGame(team);
    } else {
      setState(() {
        _resetPoints();
        if (team == 1) {
          team1GameCount[currSet]++;
          if (team1GameCount[currSet] == 6) {
            _addSet(team);
          }
        } else {
          team2GameCount[currSet]++;
          if (team2GameCount[currSet] == 6) {
            _addSet(team);
          }
        }

        if (team1GameCount[currSet] == 5 && team2GameCount[currSet] == 5) {
          setDeuce = true;
        }
      });
    }
  }

  void _addDeuceGame(int team) {
    bool team1adv = false;
    bool team2adv = false;
    if (team1GameCount[currSet] == 6 && team2GameCount[currSet] == 5) {
      team1adv = true;
    }
    if (team1GameCount[currSet] == 5 && team2GameCount[currSet] == 6) {
      team2adv = true;
    }
    setState(() {
      _resetPoints();
      if (team == 1) {
        if (team1adv) {
          team1GameCount[currSet]++;
          team1SetCount++;
          currSet++;
          setDeuce = false;
        } else if (team2adv) {
          //tie break
          setDeuce = false;
          tieBreak = true;
          team1GameCount[currSet]++;
        } else {
          team1GameCount[currSet]++;
        }
      } else {
        if (team2adv) {
          team2GameCount[currSet]++;
          team2SetCount++;
          currSet++;
          setDeuce = false;
        } else if (team1adv) {
          //tie break
          setDeuce = false;
          tieBreak = true;
          team2GameCount[currSet]++;
        } else {
          team2GameCount[currSet]++;
        }
      }
    });
  }

  void _addTieBreakPoint(int team) {
    if (tieBreakDeuce) {
      _addTieBreakDeucePoint(team);
    } else {
      setState(() {
        if (team == 1) {
          team1TieBreakScore++;
          team1CurrentGameScore = team1TieBreakScore.toString();
          if (team1TieBreakScore == 7 && !tieBreakDeuce) {
            _tieBreakFinished(team);
          }
        } else {
          team2TieBreakScore++;
          team2CurrentGameScore = team2TieBreakScore.toString();
          if (team2TieBreakScore == 7 && !tieBreakDeuce) {
            _tieBreakFinished(team);
          }
        }
      });
      if (team1TieBreakScore == 6 && team2TieBreakScore == 6) {
        tieBreakDeuce = true;
      }
    }
  }

  void _addTieBreakDeucePoint(int team) {
    bool deuce = false, team1adv = false, team2adv = false;
    String adv = 'Adv';
    if (team1CurrentGameScore == '6' && team2CurrentGameScore == '6') {
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
            _tieBreakFinished(team);
            tieBreakDeuce = false;
          } else {
            team1CurrentGameScore = team1TieBreakScore.toString();
            team2CurrentGameScore = team2TieBreakScore.toString();
          }
        }
      } else {
        if (deuce) {
          team2CurrentGameScore = adv;
          team1CurrentGameScore = '';
        } else {
          if (team2adv) {
            _tieBreakFinished(team);
            tieBreakDeuce = false;
          } else {
            team1CurrentGameScore = team1TieBreakScore.toString();
            team2CurrentGameScore = team2TieBreakScore.toString();
          }
        }
      }
    });
  }

  void _tieBreakFinished(int team) {
    if (team == 1) {
      team1GameCount[currSet]++;
      _addSet(team);
    } else {
      team2GameCount[currSet]++;
      _addSet(team);
    }

    team1TieBreakScore = 0;
    team2TieBreakScore = 0;
    tieBreak = false;
    _resetPoints();
  }

  void _addSet(int team) {
    int setsToWin = (maxSets / 2).ceil();
    setState(() {
      if (team == 1) {
        team1SetCount++;
        if (team1SetCount == setsToWin) {
          matchFinished = true;
        } else {
          currSet++;
        }
      } else {
        team2SetCount++;
        if (team2SetCount == setsToWin) {
          matchFinished = true;
        } else {
          currSet++;
        }
      }
    });
  }

  void _removePoint(int team) {
    setState(() {
      if (team == 1 && team1ScorePos > 0) {
        if (team1CurrentGameScore == 'Adv') {
          team1CurrentGameScore = scoreList[team1ScorePos].toString();
          team2CurrentGameScore = scoreList[team2ScorePos].toString();
        } else {
          team1ScorePos--;
          team1CurrentGameScore = scoreList[team1ScorePos].toString();
        }
      } else if (team == 2 && team2ScorePos > 0) {
        if (team2CurrentGameScore == 'Adv') {
          team2CurrentGameScore = scoreList[team2ScorePos].toString();
          team1CurrentGameScore = scoreList[team1ScorePos].toString();
        } else {
          team2ScorePos--;
          team2CurrentGameScore = scoreList[team2ScorePos].toString();
        }
      }
    });
  }

  void _removeGame(int team) {
    setState(() {
      if (team == 1 && team1GameCount[currSet] > 0) {
        team1GameCount[currSet]--;
      } else if (team == 2 && team2GameCount[currSet] > 0) {
        team2GameCount[currSet]--;
      }
    });
  }

  void _resetScoreboard() {
    setState(() {
      gameDeuce = false;
      setDeuce = false;
      tieBreak = false;
      tieBreakDeuce = false;
      team1TieBreakScore = 0;
      team2TieBreakScore = 0;
      matchFinished = false;

      currSet = 0;

      team1SetCount = 0;
      team2SetCount = 0;

      team1ScorePos = 0;
      team2ScorePos = 0;

      team1CurrentGameScore = scoreList[team1ScorePos].toString();
      team2CurrentGameScore = scoreList[team2ScorePos].toString();

      for (int i = 0; i < maxSets; i++) {
        team1GameCount[i] = 0;
        team2GameCount[i] = 0;
      }
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
    return null;
  }

  List<Widget>? _paintColumns(int sets, String teamName, int team) {
    List<Widget>? list = [];
    list.add(_paintContainer(teamName, Colors.blueGrey, Colors.white));

    for (int i = 0; i < sets; i++) {
      if (team == 1) {
        list.add(_paintContainer(team1GameCount[i].toString(),
            Color.fromARGB(255, 104, 145, 188), Colors.white));
      } else {
        list.add(_paintContainer(team2GameCount[i].toString(),
            Color.fromARGB(255, 104, 145, 188), Colors.white));
      }
    }
    if (team == 1) {
      list.add(_paintContainer(team1SetCount.toString(),
          Color.fromARGB(255, 192, 86, 78), Colors.white));
    } else {
      list.add(_paintContainer(team2SetCount.toString(),
          Color.fromARGB(255, 192, 86, 78), Colors.white));
    }
    if (team == 1) {
      list.add(_paintContainer(
          team1CurrentGameScore, Colors.blueGrey, Colors.yellow));
    } else {
      list.add(_paintContainer(
          team2CurrentGameScore, Colors.blueGrey, Colors.yellow));
    }

    return list;
  }

  Container _paintContainer(String text, Color? columnColor, Color? textColor) {
    return Container(
      height: columnHeight,
      //color: columnColor,
      decoration: BoxDecoration(
        color: columnColor,
        borderRadius: BorderRadius.all(Radius.circular(4)),
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

  Center _addButtons(String teamName, int team) {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            teamName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          _addVertPadding(5),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            onPressed: () {
              if (tieBreak) {
                _addTieBreakPoint(team);
              } else if (!matchFinished) {
                _addPoint(team);
              }
            },
            child: const Text(
              'Add point',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          _addVertPadding(10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            onPressed: () {
              if (tieBreak) {
                _addTieBreakPoint(team);
              } else if (!matchFinished) {
                _addGame(team);
              }
            },
            child: const Text(
              'Add game',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          _addVertPadding(10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 192, 86, 78),
            ),
            onPressed: () {
              if (!matchFinished) {
                _removePoint(team);
              }
            },
            child: const Text(
              'Remove point',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          _addVertPadding(10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 192, 86, 78),
            ),
            onPressed: () {
              if (!matchFinished) {
                _removeGame(team);
              }
            },
            child: const Text(
              'Remove game',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
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
