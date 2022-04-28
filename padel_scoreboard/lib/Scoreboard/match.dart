import 'team.dart';

class Match {
  final int maxSets;
  final bool goldenPoint;
  Team team1;
  Team team2;

  bool matchFinished = false;

  bool gameDeuce = false;
  bool setDeuce = false;
  bool tieBreak = false;
  bool tieBreakDeuce = false;

  int currSet = 0;

  Match(this.maxSets, this.goldenPoint, this.team1, this.team2);

  Team _getOtherTeam(Team currTeam) {
    if (currTeam == team1) {
      return team2;
    } else {
      return team1;
    }
  }

  void _checkGameDeuce() {
    if (!goldenPoint) {
      if (team1.getCurrentGameScore() == '40' &&
          team2.getCurrentGameScore() == '40') {
        gameDeuce = true;
      }
    }
  }

  void _addDeucePoint(Team team) {
    bool deuce = false;
    Team otherTeam = _getOtherTeam(team);
    if (team.getCurrentGameScore() == '40' &&
        otherTeam.getCurrentGameScore() == '40') {
      deuce = true;
    }
    if (deuce) {
      team.setGameAdv(true);
      otherTeam.setCurrentGameScore('');
    } else {
      if (team.gameAdv) {
        gameDeuce = false;
        addGame(team);
      } else {
        team.setGameAdv(false);
        otherTeam.setGameAdv(false);
      }
    }
  }

  void _swapServe() {
    team1.setServe();
    team2.setServe();
  }

  void _addDeuceGame(Team team) {
    Team otherTeam = _getOtherTeam(team);
    bool teamAdv = false;
    bool otherTeamAdv = false;
    if (team.gameCount[currSet] == 6 && otherTeam.gameCount[currSet] == 5) {
      teamAdv = true;
    }
    if (team.gameCount[currSet] == 5 && otherTeam.gameCount[currSet] == 6) {
      otherTeamAdv = true;
    }
    team.resetPoints();
    otherTeam.resetPoints();

    if (teamAdv) {
      team.gameCount[currSet]++;
      addSet(team);
      setDeuce = false;
    } else if (otherTeamAdv) {
      //tie break
      _swapServe();
      setDeuce = false;
      tieBreak = true;
      team.gameCount[currSet]++;
    } else {
      _swapServe();
      team.gameCount[currSet]++;
    }
  }

  void _addTieBreakPoint(Team team) {
    Team otherTeam = _getOtherTeam(team);
    if (tieBreakDeuce) {
      _addTieBreakDeucePoint(team);
    } else {
      team.tieBreakScore++;
      team.setCurrentGameScore(team.tieBreakScore.toString());
      if (team.tieBreakScore == 7 && !tieBreakDeuce) {
        addGame(team);
        addSet(team);
        team.tieBreakScore = 0;
        otherTeam.tieBreakScore = 0;
        tieBreak = false;
      }
      if (team1.tieBreakScore == 6 && team2.tieBreakScore == 6) {
        tieBreakDeuce = true;
      }
    }
  }

  void _addTieBreakDeucePoint(Team team) {
    bool deuce = false;
    Team otherTeam = _getOtherTeam(team);
    if (team.getCurrentGameScore() == '6' &&
        otherTeam.getCurrentGameScore() == '6') {
      deuce = true;
    }
    if (deuce) {
      team.setTiebreakAdv(true);
      otherTeam.setCurrentGameScore('');
    } else {
      if (team.gameAdv) {
        addGame(team);
        addSet(team);
        team.tieBreakScore = 0;
        otherTeam.tieBreakScore = 0;
        tieBreakDeuce = false;
        tieBreak = false;
      } else {
        team.setTiebreakAdv(false);
        otherTeam.setTiebreakAdv(false);
      }
    }
  }

  void _removeTieBreakPoint(Team team) {
    Team otherTeam = _getOtherTeam(team);
    if (team.tieBreakScore > 0) {
      if (team.gameAdv || otherTeam.gameAdv) {
        team.setCurrentGameScore(team.tieBreakScore.toString());
        otherTeam.setCurrentGameScore(otherTeam.tieBreakScore.toString());
      } else {
        team.tieBreakScore--;
        team.setCurrentGameScore(team.tieBreakScore.toString());
      }
    }
  }

  void addPoint(Team team) {
    if (gameDeuce) {
      _addDeucePoint(team);
    } else if (tieBreak) {
      _addTieBreakPoint(team);
    } else {
      team.scorePos++;
      if (team.scoreList[team.scorePos] == 41) {
        //end of game
        _checkGameDeuce();
        addGame(team);
      } else {
        team.setCurrentGameScore(team.scoreList[team.scorePos].toString());
        _checkGameDeuce();
      }
    }
  }

  void addGame(Team team) {
    Team otherTeam = _getOtherTeam(team);
    if (setDeuce) {
      _addDeuceGame(team);
    } else {
      _swapServe();
      team.resetPoints();
      otherTeam.resetPoints();
      team.gameCount[currSet]++;

      if (team.gameCount[currSet] == 5 && otherTeam.gameCount[currSet] == 5) {
        setDeuce = true;
      }
      if (team.gameCount[currSet] == 6) {
        addSet(team);
      }
    }
  }

  void addSet(Team team) {
    team.setCount++;
    Team otherTeam = _getOtherTeam(team);
    if (team.setCount + otherTeam.setCount == maxSets) {
      matchFinished = true;
    } else {
      currSet++;
      /*if (currSet.isEven) {
        _setServe(initServe);
      } else {
        _setServe(!initServe);
      }*/
    }
  }

  void removePoint(Team team) {
    Team otherTeam = _getOtherTeam(team);
    if (tieBreak) {
      _removeTieBreakPoint(team);
    } else {
      if (team.scorePos > 0) {
        if (team.gameAdv || otherTeam.gameAdv) {
          team.setCurrentGameScore(team.scoreList[team.scorePos].toString());
          otherTeam.setCurrentGameScore(
              otherTeam.scoreList[otherTeam.scorePos].toString());
        } else {
          team.scorePos--;
          team.setCurrentGameScore(team.scoreList[team.scorePos].toString());
        }
      }
    }
  }

  void removeGame(Team team) {
    if (tieBreak) {
      tieBreak = false;
      setDeuce = true;
      if (tieBreakDeuce) tieBreakDeuce = false;
      if (team.gameCount[currSet] > 0) {
        team.gameCount[currSet]--;
      }
    } else {
      if (team.gameCount[currSet] > 0) {
        team.gameCount[currSet]--;
      }
    }
  }

  void resetScoreboard() {
    gameDeuce = false;
    setDeuce = false;
    tieBreak = false;
    tieBreakDeuce = false;
    team1.tieBreakScore = 0;
    team2.tieBreakScore = 0;
    matchFinished = false;

    currSet = 0;

    team1.setCount = 0;
    team2.setCount = 0;

    team1.scorePos = 0;
    team2.scorePos = 0;

    team1.currentGameScore = team1.scoreList[team1.scorePos].toString();
    team2.currentGameScore = team2.scoreList[team2.scorePos].toString();

    //team1Serve = initServe;

    for (int i = 0; i < maxSets; i++) {
      team1.gameCount[i] = 0;
      team2.gameCount[i] = 0;
    }
  }
}
