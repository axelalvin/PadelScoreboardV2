import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'scoreboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('My App');
    setWindowMaxSize(const Size(768, 1024));
    setWindowMinSize(const Size(600, 800));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Padel Scoreboard',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final player1NameController = TextEditingController();
  final player2NameController = TextEditingController();
  final player3NameController = TextEditingController();
  final player4NameController = TextEditingController();

  int _numberOfSets = 3;
  bool _goldenPoint = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Padel Scoreboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(4),
            children: <Widget>[
              const Text(
                'Enter players',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _addVertPadding(20),
              const Text(
                'Team 1',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                //padding: EdgeInsets.all(12),
                padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: player1NameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Player 1 Name',
                        isDense: true, // Added this
                        contentPadding: EdgeInsets.all(8), // Added this
                      ),
                    ),
                    _addVertPadding(10),
                    TextField(
                      controller: player2NameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Player 2 Name',
                        isDense: true, // Added this
                        contentPadding: EdgeInsets.all(8), // Added this
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Team 2',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                //padding: EdgeInsets.all(12),
                padding: EdgeInsets.fromLTRB(30, 12, 30, 12),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: player3NameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Player 1 Name',
                        isDense: true, // Added this
                        contentPadding: EdgeInsets.all(8), // Added this
                      ),
                    ),
                    _addVertPadding(10),
                    TextField(
                      controller: player4NameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Player 2 Name',
                        isDense: true, // Added this
                        contentPadding: EdgeInsets.all(8), // Added this
                      ),
                    ),
                  ],
                ),
              ),
              _addVertPadding(20),
              const Text(
                'Select game mode',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _addVertPadding(10),
              const Text(
                'Number of sets',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, //Center Row contents horizontally,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Radio<int>(
                    value: 3,
                    groupValue: _numberOfSets,
                    onChanged: (int? value) {
                      setState(() {
                        _numberOfSets = value!;
                      });
                    },
                  ),
                  const Text(
                    '3',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _addHorizPadding(5),
                  Radio<int>(
                    value: 5,
                    groupValue: _numberOfSets,
                    onChanged: (int? value) {
                      setState(() {
                        _numberOfSets = value!;
                      });
                    },
                  ),
                  const Text(
                    '5',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              _addVertPadding(10),
              const Text(
                'Deuce mode',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, //Center Row contents horizontally,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Radio<bool>(
                    value: true,
                    groupValue: _goldenPoint,
                    onChanged: (bool? value) {
                      setState(() {
                        _goldenPoint = value!;
                      });
                    },
                  ),
                  const Text(
                    'Golden point',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Radio<bool>(
                    value: false,
                    groupValue: _goldenPoint,
                    onChanged: (bool? value) {
                      setState(() {
                        _goldenPoint = value!;
                      });
                    },
                  ),
                  const Text(
                    'Advantage',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              _addVertPadding(20),
              Center(
                child: ElevatedButton(
                  child: const Text('Start match'),
                  onPressed: () {
                    _getInitals(player1NameController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scoreboard(
                                title: 'Match',
                                maxSets: _numberOfSets,
                                goldenPoint: _goldenPoint,
                                team1Name: _formatTeamName(
                                    _getInitals(player1NameController.text),
                                    _getInitals(player2NameController.text)),
                                team2Name: _formatTeamName(
                                    _getInitals(player3NameController.text),
                                    _getInitals(player4NameController.text)),
                              )),
                    );
                    // Navigate to second route when tapped.
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitals(String name) {
    final nameSplit = name.split(' ');
    if (nameSplit.isNotEmpty) {
      String inital = '';
      for (int i = 0; i < nameSplit[nameSplit.length - 1].length; i++) {
        inital += nameSplit[nameSplit.length - 1][i];
        if (inital.length == 3) break;
      }
      return inital.toUpperCase();
    }
    return 'XXX';
  }

  String _formatTeamName(String player1Initials, String player2Initials) {
    return player1Initials + '/' + player2Initials;
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
