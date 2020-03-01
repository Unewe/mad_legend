import 'package:mad_legend/services/game_logic.dart';

import '../models/collections.dart';

class Player {
  GameLogic _gameLogic;
  final String name;
  int health;
  int shield;
  PlayerClass playerClass;
  List<Cards> improvements = List();
  List<Cards> degradations = List();
  int firstTurnInitiative;
  int initiative;
  int defaultInitiative;

  List<Cards> cards;
  List<Cards> currentTurnCards;
  Cards lastBreathCard;

  List<String> dmgTextList = List();

  Player(this.name, this.playerClass) {
    switch (playerClass) {
      case PlayerClass.DEFAULT:
        this.health = 30;
        this.firstTurnInitiative = 1;
        this.initiative = defaultInitiative = 3;
        this.shield = 0;
        this.cards = Cards.getDefaultCollection();
        this.currentTurnCards = Cards.getDefaultCollection();
        this.lastBreathCard = Cards.defaultLastBreathCard();
        break;
      case PlayerClass.KNIGHT:
        this.health = 70;
        this.firstTurnInitiative = 1;
        this.initiative = defaultInitiative = 3;
        this.shield = 0;
        this.cards = Cards.getDefaultCollection();
        this.currentTurnCards = Cards.getDefaultCollection();
        this.lastBreathCard = Cards.defaultLastBreathCard();
        break;
      case PlayerClass.ARCHER:
        this.health = 60;
        this.firstTurnInitiative = 1;
        this.initiative = defaultInitiative = 3;
        this.shield = 0;
        this.cards = Cards.getDefaultCollection();
        this.currentTurnCards = Cards.getDefaultCollection();
        this.lastBreathCard = Cards.defaultLastBreathCard();
        break;
    }
  }

  setGameLogic(GameLogic gameLogic) {
    this._gameLogic = gameLogic;
  }

  hit(int dmg) {
    if (dmg <= shield) {
      shield -= dmg;
      dmg = 0;
    } else {
      dmg -= shield;
      shield = 0;
    }

    health = health - dmg;
    if (health < 8) {
      _gameLogic.lastWord(this);
    } else if (health < 0) {
      _gameLogic.endGame(this);
    }
  }

  shieldUp(int count) {
    this.shield += count;
  }

  getHealth() {
    return health;
  }

  getShield() {
    return shield;
  }

  addImprovement(Cards improvement) {
    this.improvements.add(improvement);
  }

  List<Cards> getImprovements() {
    return this.improvements;
  }

  addDegradation(Cards degradation) {
    this.degradations.add(degradation);
  }

  List<Cards> getDegradations() {
    return this.degradations;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Player &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              playerClass == other.playerClass;

  @override
  int get hashCode => name.hashCode ^ playerClass.hashCode;
}

enum PlayerClass { DEFAULT, KNIGHT, ARCHER }

enum Turn { LEFT, RIGHT }
