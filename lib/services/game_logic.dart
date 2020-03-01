import 'dart:math';
import 'package:mad_legend/models/collections.dart';
import 'package:mad_legend/services/player-logic.dart';
import 'package:mad_legend/screen_blocks/cards_block.dart';
import 'package:mad_legend/screens/end_game_screen.dart';
import 'package:mad_legend/screens/game_screen.dart';
import 'package:mad_legend/services/game_context.dart';

class GameLogic {
  GameScreen gameScreen;
  Random random = Random();

  Player leftPlayer;
  Player rightPlayer;

  Player current;
  Player opponent;

  GameLogic(this.leftPlayer, this.rightPlayer, this.gameScreen) {
    GameContext.gameLogic = this;
    leftPlayer.setGameLogic(this);
    rightPlayer.setGameLogic(this);

    int r = random.nextInt(2);

    if (r == 0) {
      current = leftPlayer;
      opponent = rightPlayer;
      current.initiative = current.firstTurnInitiative;
    } else {
      current = rightPlayer;
      opponent = leftPlayer;
      current.initiative = current.firstTurnInitiative;
    }
  }

  dropCard(Cards card) {
    /// Универсальное определение урона
    int dmg = 0;
    if (random.nextInt(100) < card.chance * 100) {
      dmg = random.nextInt(card.dmgHigh - card.dmgLow + 1) + card.dmgLow;
    }

    switch (card.costType) {
      case Cost.initiative:
        current.initiative -= card.costCount;
        break;
      case Cost.health:
        current.health -= card.costCount;
        break;
      case Cost.noCost:
        break;
    }

    switch (card.feature) {
      case Features.meleeDefault:
        if (current.getImprovements().length > 0) {
          current.getImprovements().forEach(
              (improvement) => dmg += (dmg * improvement.chance).round());
        }
        current.improvements.clear();
        opponent.hit(dmg);
        break;
      case Features.rangedDefault:
        if (current.getImprovements().length > 0) {
          current.getImprovements().forEach(
              (improvement) => dmg += (dmg * improvement.chance).round());
        }
        current.improvements.clear();
        opponent.hit(dmg);
        break;
      case Features.shieldDefault:

        ///Убрал улучшение щита!
//        if (current.getImprovements().length > 0) {
//          current.getImprovements().forEach(
//              (improvement) => dmg += (dmg * improvement.chance).round());
//        }
//        current._improvements.clear();
        current.shieldUp(dmg);
        break;
      case Features.prepareDefault:
        if (current.initiative < 10) current.initiative++;

        ///Кладем карту если есть пустое место
        int rndIndex = random.nextInt(current.currentTurnCards.length);
        if (this.gameScreen.bottomBlock.firstRect == null) {
          this.gameScreen.bottomBlock.firstRect =
              this.gameScreen.bottomBlock.firstRectBg;
          this.gameScreen.bottomBlock.currentCards.replaceRange(
              0, 1, List.of([current.currentTurnCards.elementAt(rndIndex)]));
          this.current.currentTurnCards.removeAt(rndIndex);
        } else if (this.gameScreen.bottomBlock.secondRect == null) {
          this.gameScreen.bottomBlock.secondRect =
              this.gameScreen.bottomBlock.secondRectBg;
          this.gameScreen.bottomBlock.currentCards.replaceRange(
              1, 2, List.of([current.currentTurnCards.elementAt(rndIndex)]));
          this.current.currentTurnCards.removeAt(rndIndex);
        } else if (this.gameScreen.bottomBlock.thirdRect == null) {
          this.gameScreen.bottomBlock.thirdRect =
              this.gameScreen.bottomBlock.thirdRectBg;
          this.gameScreen.bottomBlock.currentCards.replaceRange(
              2, 3, List.of([current.currentTurnCards.elementAt(rndIndex)]));
          this.current.currentTurnCards.removeAt(rndIndex);
        } else if (this.gameScreen.bottomBlock.fourthRect == null) {
          this.gameScreen.bottomBlock.fourthRect =
              this.gameScreen.bottomBlock.fourthRectBg;
          this.gameScreen.bottomBlock.currentCards.replaceRange(
              3, 4, List.of([current.currentTurnCards.elementAt(rndIndex)]));
          this.current.currentTurnCards.removeAt(rndIndex);
        }
        break;
      case Features.curseDefault:
        for (int i = 0; i < Cards.defaultCurseCard().dmgHigh; i++) {
          opponent.cards.add(Cards.simpleCurse());
        }
        break;
      case Features.simpleCurse:
        current.cards.removeAt(current.cards.indexOf(card));
        break;
      case Features.improvementDefault:
        current.addImprovement(card);
        break;
      case Features.lastBreathDefault:
        int dmg = 0;
        for (Cards c in opponent.cards) {
          if (c.feature == Features.simpleCurse) {
            dmg += card.dmgHigh;
          }
        }
        opponent.hit(dmg);
        break;
    }

    if (leftPlayer.getHealth() <= 0 && rightPlayer.getHealth() <= 0) {
      draw();
    } else if (leftPlayer.getHealth() <= 0) {
      endGame(leftPlayer);
    } else if (rightPlayer.getHealth() <= 0) {
      endGame(rightPlayer);
    }
  }

  endTurn() {
    Player tmp = current;
    current = opponent;
    opponent = tmp;
    current.currentTurnCards = List.of(current.cards);
    opponent.currentTurnCards = List.of(opponent.cards);

    current.initiative = current.defaultInitiative;

    if (current == rightPlayer) {
      GameContext.yourTurn = false;
      cpuTurn();
    } else {
      GameContext.yourTurn = true;
      gameScreen.bottomBlock.initCardsFully();
    }
  }

  lastWord(Player player) {}

  endGame(Player player) async {
    await Future.delayed(Duration(seconds: 3), () => {});
    gameScreen.game.toScreen(
        EndGameScreen(this.gameScreen.game, leftPlayer, leftPlayer != player));
  }

  draw() {
    print("Ничья");
  }

  getCurrentCards() {
    return current.cards;
  }

  cpuTurn({bool noDelay = true}) async {
    GameContext.yourTurn = false;
    List<Cards> cpuHand = List();
    int duration = 1;

    bool isFirstCard = noDelay;

    for (int i = 0; i < 4; i++) {
      int value = random.nextInt(current.currentTurnCards.length);
      cpuHand.add(current.currentTurnCards.elementAt(value));
      current.currentTurnCards.removeAt(value);
    }

    for (int i = 0; i <= 5; i++) {
      if (cpuHand.contains(Cards.simpleCurse()) &&
          _isEnough(Cards.simpleCurse())) {
        if (!isFirstCard)
          await Future.delayed(Duration(seconds: duration), () => {});
        GameContext.cardsBlock.opponentCards.add(CardItem(
            Cards.simpleCurse(), GameContext.cardsBlock.opponentCard,
            isOpponent: true));
        dropCard(cpuHand.removeAt(cpuHand.indexOf(Cards.simpleCurse())));
      } else if (cpuHand.contains(Cards.defaultPrepareCard()) &&
          _isEnough(Cards.defaultPrepareCard())) {
        if (!isFirstCard)
          await Future.delayed(Duration(seconds: duration), () => {});
        GameContext.cardsBlock.opponentCards.add(CardItem(
            Cards.defaultPrepareCard(), GameContext.cardsBlock.opponentCard,
            isOpponent: true));
        dropCard(cpuHand.removeAt(cpuHand.indexOf(Cards.defaultPrepareCard())));
      } else if (cpuHand.contains(Cards.defaultImprovementCard()) &&
          _isEnough(Cards.defaultImprovementCard())) {
        if (!isFirstCard)
          await Future.delayed(Duration(seconds: duration), () => {});
        GameContext.cardsBlock.opponentCards.add(CardItem(
            Cards.defaultImprovementCard(), GameContext.cardsBlock.opponentCard,
            isOpponent: true));
        dropCard(
            cpuHand.removeAt(cpuHand.indexOf(Cards.defaultImprovementCard())));
      } else if (cpuHand.contains(Cards.defaultMeleeCard()) &&
          _isEnough(Cards.defaultMeleeCard())) {
        if (!isFirstCard)
          await Future.delayed(Duration(seconds: duration), () => {});
        GameContext.cardsBlock.opponentCards.add(CardItem(
            Cards.defaultMeleeCard(), GameContext.cardsBlock.opponentCard,
            isOpponent: true));
        dropCard(cpuHand.removeAt(cpuHand.indexOf(Cards.defaultMeleeCard())));
      } else if (cpuHand.contains(Cards.defaultRangedCard()) &&
          _isEnough(Cards.defaultRangedCard())) {
        if (!isFirstCard)
          await Future.delayed(Duration(seconds: duration), () => {});
        GameContext.cardsBlock.opponentCards.add(CardItem(
            Cards.defaultRangedCard(), GameContext.cardsBlock.opponentCard,
            isOpponent: true));
        dropCard(cpuHand.removeAt(cpuHand.indexOf(Cards.defaultRangedCard())));
      } else if (cpuHand.contains(Cards.defaultShieldCard()) &&
          _isEnough(Cards.defaultShieldCard())) {
        if (!isFirstCard)
          await Future.delayed(Duration(seconds: duration), () => {});
        GameContext.cardsBlock.opponentCards.add(CardItem(
            Cards.defaultShieldCard(), GameContext.cardsBlock.opponentCard,
            isOpponent: true));
        dropCard(cpuHand.removeAt(cpuHand.indexOf(Cards.defaultShieldCard())));
      } else if (cpuHand.contains(Cards.defaultCurseCard()) &&
          _isEnough(Cards.defaultCurseCard())) {
        if (!isFirstCard)
          await Future.delayed(Duration(seconds: duration), () => {});
        GameContext.cardsBlock.opponentCards.add(CardItem(
            Cards.defaultCurseCard(), GameContext.cardsBlock.opponentCard,
            isOpponent: true));
        dropCard(cpuHand.removeAt(cpuHand.indexOf(Cards.defaultCurseCard())));
      }
      isFirstCard = false;
    }

    endTurn();
  }

  bool _isEnough(Cards card) {
    bool tmp;
    switch (card.costType) {
      case Cost.initiative:
        tmp = current.initiative >= card.costCount;
        break;
      case Cost.health:
        tmp = current.getHealth() >= (10);
        break;
      case Cost.noCost:
        tmp = true;
        break;
    }

    return tmp;
  }
}