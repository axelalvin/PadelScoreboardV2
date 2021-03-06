import 'package:flutter/material.dart';

import 'Scoreboard/scoreboard.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Padel Scoreboard',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> _playerNameControllers = [
    for (int i = 0; i < 4; i++) TextEditingController()
  ];

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
              _addTitle('Enter players', 20),
              _addVertPadding(20),
              _addTitle('Team 1', 15),
              _addTeamContainer(_playerNameControllers[0],
                  _playerNameControllers[1], 'Player 1 Name', 'Player 2 Name'),
              _addTitle('Team 2', 15),
              _addTeamContainer(_playerNameControllers[2],
                  _playerNameControllers[3], 'Player 1 Name', 'Player 2 Name'),
              _addVertPadding(20),
              _addTitle('Select game mode', 20),
              _addVertPadding(10),
              _addTitle('Number of sets', 15),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, //Center Row contents horizontally,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _addIntRadios(),
              ),
              _addVertPadding(10),
              _addTitle('Deuce mode', 15),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, //Center Row contents horizontally,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _addBoolRadios(),
              ),
              _addVertPadding(20),
              Center(
                child: ElevatedButton(
                  child: const Text('Start match'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scoreboard(
                                  title: 'Match',
                                  numberOfSets: _numberOfSets,
                                  goldenPoint: _goldenPoint,
                                  team1Name: _formatTeamName(
                                      _getInitals(
                                          _playerNameControllers[0].text),
                                      _getInitals(
                                          _playerNameControllers[1].text)),
                                  team2Name: _formatTeamName(
                                      _getInitals(
                                          _playerNameControllers[2].text),
                                      _getInitals(
                                          _playerNameControllers[3].text)),
                                )),
                      );
                    } // Navigate to second route when tapped.
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
    if (nameSplit.last.isEmpty) {
      nameSplit.remove(nameSplit.last);
    }
    if (nameSplit.isNotEmpty) {
      String inital = '';
      for (int i = 0; i < nameSplit.last.length; i++) {
        inital += nameSplit.last[i];
        if (inital.length == 3) break;
      }
      return inital.toUpperCase();
    }
    return '';
  }

  String _formatTeamName(String player1Initials, String player2Initials) {
    if (player2Initials.isNotEmpty) {
      return player1Initials + '/' + player2Initials;
    } else {
      return player1Initials;
    }
  }

  Text _addTitle(String titleText, double fontSize) {
    return Text(
      titleText,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  List<Widget> _addIntRadios() {
    return <Widget>[
      Radio<int>(
        value: 3,
        groupValue: _numberOfSets,
        onChanged: (int? value) {
          setState(() {
            _numberOfSets = value!;
          });
        },
      ),
      _addRadioTitle('3'),
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
      _addRadioTitle('5'),
    ];
  }

  List<Widget> _addBoolRadios() {
    return <Widget>[
      Radio<bool>(
        value: true,
        groupValue: _goldenPoint,
        onChanged: (bool? value) {
          setState(() {
            _goldenPoint = value!;
          });
        },
      ),
      _addRadioTitle('Golden point'),
      _addHorizPadding(5),
      Radio<bool>(
        value: false,
        groupValue: _goldenPoint,
        onChanged: (bool? value) {
          setState(() {
            _goldenPoint = value!;
          });
        },
      ),
      _addRadioTitle('Advantage'),
    ];
  }

  Text _addRadioTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  TextFormField _addPlayerNameTextField(
      TextEditingController nameController, String playerName, bool _required) {
    if (_required) {
      return TextFormField(
        controller: nameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: playerName,
          isDense: true, // Added this
          contentPadding: const EdgeInsets.all(8), // Added this
        ),
      );
    } else {
      return TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: playerName,
          isDense: true, // Added this
          contentPadding: const EdgeInsets.all(8), // Added this
        ),
      );
    }
  }

  Container _addTeamContainer(
      TextEditingController name1Controller,
      TextEditingController name2Controller,
      String player1Name,
      String player2Name) {
    return Container(
      //padding: EdgeInsets.all(12),
      padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
      child: Column(
        children: <Widget>[
          _addPlayerNameTextField(name1Controller, player1Name, true),
          _addVertPadding(10),
          _addPlayerNameTextField(name2Controller, player2Name, false),
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
