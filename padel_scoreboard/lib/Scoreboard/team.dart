class Team {
  final int id;
  final String teamName;
  final int maxSets;

  List<int> gameCount = [];
  int setCount = 0;

  List<int> scoreList = [0, 15, 30, 40, 41];
  late String currentGameScore;
  int scorePos = 0;

  int tieBreakScore = 0;

  bool gameAdv = false;
  bool hasServe = false;

  Team(this.id, this.teamName, this.maxSets) {
    currentGameScore = scoreList[scorePos].toString();

    for (int i = 0; i < maxSets; i++) {
      gameCount.add(0);
    }
  }

  void setServe() {
    hasServe = !hasServe;
  }

  void resetPoints() {
    scorePos = 0;
    setCurrentGameScore(scoreList[scorePos].toString());
  }

  String getCurrentGameScore() {
    return currentGameScore;
  }

  void setCurrentGameScore(String score) {
    currentGameScore = score;
  }

  int getGameCount(int set) {
    return gameCount[set];
  }

  void setGameAdv(bool adv) {
    gameAdv = adv;
    if (!adv) {
      setCurrentGameScore(scoreList[scorePos].toString());
    } else {
      setCurrentGameScore('Adv');
    }
  }

  void setTiebreakAdv(bool adv) {
    gameAdv = adv;
    if (!adv) {
      setCurrentGameScore(tieBreakScore.toString());
    } else {
      setCurrentGameScore('Adv');
    }
  }
}
