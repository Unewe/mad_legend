import 'dart:math';

import 'package:mad_legend/screens.dart';
import 'package:mad_legend/collections.dart';

class GameLogic {
  GameScreen gameScreen;
  Random random = Random();

  Player leftPlayer;
  Player rightPlayer;

  Player current;
  Player opponent;

  GameLogic(this.leftPlayer, this.rightPlayer, this.gameScreen) {

    leftPlayer.setGameLogic(this);
    rightPlayer.setGameLogic(this);

    int r = random.nextInt(2);

    if (r == 0) {
      current = leftPlayer;
      opponent = rightPlayer;
      current.initiative = 1;
    } else {
      current = rightPlayer;
      opponent = leftPlayer;
      current.initiative = 1;
    }
  }

  dropCard(Cards card) async {

    // Универсальное определение урона
    int dmg = 0;
    if(random.nextInt(100) < card.chance * 100){
      dmg = random.nextInt(card.dmgHigh - card.dmgLow + 1) + card.dmgLow;
    }

    switch(card.costType) {

      case Cost.initiative:
        current.initiative -= card.costCount;
        break;
      case Cost.health:
        current._health -= card.costCount;
        break;
      case Cost.noCost:
        break;
    }

    switch (card.feature) {

      case Features.meleeDefault:
        if(current.getImprovements().length > 0) {
          current.getImprovements().forEach((improvement) =>
            dmg += (dmg * improvement.chance).round()
          );
        }
        current._improvements.clear();
        opponent.hit(dmg);
        break;
      case Features.rangedDefault:
        if(current.getImprovements().length > 0) {
          current.getImprovements().forEach((improvement) =>
          dmg += (dmg * improvement.chance).round()
          );
        }
        current._improvements.clear();
        opponent.hit(dmg);
        break;
      case Features.shieldDefault:
        if(current.getImprovements().length > 0) {
          current.getImprovements().forEach((improvement) =>
          dmg += (dmg * improvement.chance).round()
          );
        }
        current._improvements.clear();
        current.shieldUp(dmg);
        break;
      case Features.prepareDefault:
        if(current.initiative < 10) current.initiative++;
        //Кладем карту если есть пустое место
        int rndIndex = random.nextInt(current.currentTurnCards.length);
        if (this.gameScreen.bottomBlock.firstRect == null) {
          this.gameScreen.bottomBlock.firstRect = this.gameScreen.bottomBlock.firstRectBg;
          this.gameScreen.bottomBlock.currentCards
              .replaceRange(0, 1, List.of([current.currentTurnCards.elementAt(rndIndex)]));
          this.current.currentTurnCards.removeAt(rndIndex);
          this.gameScreen.bottomBlock.initCards(0);
        } else if (this.gameScreen.bottomBlock.secondRect == null) {
          this.gameScreen.bottomBlock.secondRect = this.gameScreen.bottomBlock.secondRectBg;
          this.gameScreen.bottomBlock.currentCards
              .replaceRange(1, 2, List.of([current.currentTurnCards.elementAt(rndIndex)]));
          this.current.currentTurnCards.removeAt(rndIndex);
          this.gameScreen.bottomBlock.initCards(1);
        } else if (this.gameScreen.bottomBlock.thirdRect == null) {
          this.gameScreen.bottomBlock.thirdRect = this.gameScreen.bottomBlock.thirdRectBg;
          this.gameScreen.bottomBlock.currentCards
              .replaceRange(2, 3, List.of([current.currentTurnCards.elementAt(rndIndex)]));
          this.current.currentTurnCards.removeAt(rndIndex);
          this.gameScreen.bottomBlock.initCards(2);
        } else if (this.gameScreen.bottomBlock.fourthRect == null) {
          this.gameScreen.bottomBlock.fourthRect = this.gameScreen.bottomBlock.fourthRectBg;
          this.gameScreen.bottomBlock.currentCards
              .replaceRange(3, 4, List.of([current.currentTurnCards.elementAt(rndIndex)]));
          this.current.currentTurnCards.removeAt(rndIndex);
          this.gameScreen.bottomBlock.initCards(3);
        }
        break;
      case Features.curseDefault:
        opponent.cards.add(Cards.simpleCurse());
        opponent.cards.add(Cards.simpleCurse());
        break;
      case Features.simpleCurse:
        current.cards.removeAt(current.cards.indexOf(card));
        break;
      case Features.improvementDefault:
        current.addImprovement(card);
        break;
      case Features.lastBreathDefault:
        int dmg = 0;
        for(Cards c in opponent.cards) {
          if(c.feature == Features.simpleCurse) {
            dmg += card.dmgHigh;
          }
        }
        opponent.hit(dmg);
        break;
    }

    this.gameScreen.bottomBlock.initAllCardsText();

    if(leftPlayer.getHealth() <= 0 && rightPlayer.getHealth() <= 0) {
      draw();
    } else if(leftPlayer.getHealth() <= 0) {
      endGame(leftPlayer);
    } else if(rightPlayer.getHealth() <= 0) {
      endGame(rightPlayer);
    }
  }

  endTurn() {
    Player tmp = current;
    current = opponent;
    opponent = tmp;
    current.currentTurnCards = List.of(current.cards);
    opponent.currentTurnCards = List.of(opponent.cards);

    current.initiative = 2;

    if(current == rightPlayer) {
      cpuTurn();
    } else {
      gameScreen.bottomBlock.initCardsFully();
    }
  }
  
  lastWord(Player player) {
    
  }

  endGame(Player player) {
    gameScreen.game.toScreen(EndGameScreen(this.gameScreen.game, leftPlayer, leftPlayer != player));
  }

  draw() {
    print("Ничья");
  }

  getCurrentCards() {
    return current.cards;
  }

  cpuTurn() {
    List<Cards> cpuHand = List();

    for(int i = 0; i < 5; i++) {
      int value = random.nextInt(current.currentTurnCards.length);
      cpuHand.add(current.currentTurnCards.elementAt(value));
      current.currentTurnCards.removeAt(value);
    }

    for(int i = 0; i <= 5; i++) {
      
      if(cpuHand.contains(Cards.simpleCurse()) && _isEnough(Cards.simpleCurse())) {
        dropCard(cpuHand.removeAt(cpuHand.indexOf(Cards.simpleCurse())));
      } else if(cpuHand.contains(Cards.defaultImprovementCard()) && _isEnough(Cards.defaultImprovementCard())) {
        dropCard(cpuHand.removeAt(cpuHand.indexOf(Cards.defaultImprovementCard())));
      } else if(cpuHand.contains(Cards.defaultPrepareCard()) && _isEnough(Cards.defaultPrepareCard())) {
        dropCard(cpuHand.removeAt(cpuHand.indexOf(Cards.defaultPrepareCard())));
      } else if(cpuHand.contains(Cards.defaultMeleeCard()) && _isEnough(Cards.defaultMeleeCard())) {
        dropCard(cpuHand.removeAt(cpuHand.indexOf(Cards.defaultMeleeCard())));
      } else if(cpuHand.contains(Cards.defaultRangedCard()) && _isEnough(Cards.defaultRangedCard())) {
        dropCard(cpuHand.removeAt(cpuHand.indexOf(Cards.defaultRangedCard())));
      } else if(cpuHand.contains(Cards.defaultShieldCard()) && _isEnough(Cards.defaultShieldCard())) {
        dropCard(cpuHand.removeAt(cpuHand.indexOf(Cards.defaultShieldCard())));
      } else if(cpuHand.contains(Cards.defaultCurseCard()) && _isEnough(Cards.defaultCurseCard())) {
        dropCard(cpuHand.removeAt(cpuHand.indexOf(Cards.defaultCurseCard())));
      }
    }

    endTurn();
  }

  bool _isEnough(Cards card) {
    bool tmp;
    switch(card.costType) {

      case Cost.initiative:
        tmp = current.initiative >=card.costCount;
        break;
      case Cost.health:
        tmp = current.getHealth() >= (current.getHealth() * 0.2);
        break;
      case Cost.noCost:
        tmp = true;
        break;
    }

    return tmp;
  }
}

class Player {
  GameLogic _gameLogic;
  final String name;
  int _health;
  int _shield;
  PlayerClass playerClass;
  List<Cards> _improvements = List();
  List<Cards> _degradations = List();
  int firstTurnInitiative;
  int initiative;

  List<Cards> cards;
  List<Cards> currentTurnCards;
  Cards lastBreathCard;

  Player(this.name, this.playerClass) {
    switch (playerClass) {
      case PlayerClass.DEFAULT :
        this._health = 50;
        this.firstTurnInitiative = 1;
        this.initiative = 2;
        this._shield = 0;
        this.cards = Cards.getDefaultCollection();
        this.currentTurnCards = Cards.getDefaultCollection();
        this.lastBreathCard = Cards.defaultLastBreathCard();
        break;
      case PlayerClass.KNIGHT:
        this._health = 70;
        this.firstTurnInitiative = 1;
        this.initiative = 2;
        this._shield = 0;
        this.cards = Cards.getDefaultCollection();
        this.currentTurnCards = Cards.getDefaultCollection();
        this.lastBreathCard = Cards.defaultLastBreathCard();
        break;
      case PlayerClass.ARCHER:
        this._health = 60;
        this.firstTurnInitiative = 1;
        this.initiative = 2;
        this._shield = 0;
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

    if(dmg <= _shield) {
      _shield -= dmg;
      dmg = 0;
    } else {
      dmg -= _shield;
      _shield = 0;
    }

    _health = _health - dmg;
    if(_health < 8) {
      _gameLogic.lastWord(this);
    }
    else if(_health < 0) {
      _gameLogic.endGame(this);
    }
  }

  shieldUp(int count) {
    this._shield += count;
  }

  getHealth() {
    return _health;
  }

  getShield() {
    return _shield;
  }

  addImprovement(Cards improvement) {
    this._improvements.add(improvement);
  }

  List<Cards> getImprovements() {
    return this._improvements;
  }

  addDegradation(Cards degradation) {
    this._degradations.add(degradation);
  }

  List<Cards> getDegradations() {
    return this._degradations;
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Player &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              playerClass == other.playerClass;

  @override
  int get hashCode =>
      name.hashCode ^
      playerClass.hashCode;

}

enum PlayerClass {
  DEFAULT,
  KNIGHT,
  ARCHER
}

enum Turn {
  LEFT, RIGHT
}