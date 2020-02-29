import 'dart:math';
import 'dart:ui';
import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/text_box_component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_legend/models/collections.dart';
import 'package:mad_legend/screens/game_screen.dart';

class BottomBlock extends Component {
  Random random = Random();

  GameScreen gameScreen;

  var x, y, w, h;
  List<Cards> currentCards;

  var firstX, firstY;
  var secondX, secondY;
  var thirdX, thirdY;
  var fourthX, fourthY;
  var width;
  Rect firstRect, secondRect, thirdRect, fourthRect;
  Rect firstRectBg, secondRectBg, thirdRectBg, fourthRectBg;
  Sprite cardBg;

  Rect opponentCard, opponentCardStartPosition;
  bool opponentAnimation = false;

  Rect selectedRect;
  var selectedX, selectedY, toChangeX, toChangeY, selected;
  var dragYPosition;
  bool isGameJustStarted = true;

  CardTextBox firstTextBox, secondTextBox, thirdTextBox, fourthTextBox;

  Paint paint = Paint()..color = Color.fromRGBO(102, 59, 147, 1);
  Paint paintBg = Paint()..color = Colors.black26;

  BottomBlock(this.gameScreen, this.x, this.y, this.w, this.h) {
    firstY = secondY = thirdY = fourthY = y;

    width = h * 0.7;

    firstX = w / 2 - width - width - h * 0.025 - h * 0.05;
    secondX = w / 2 - width - h * 0.025;
    thirdX = w / 2 + h * 0.025;
    fourthX = w / 2 + width + h * 0.05 + h * 0.025;

    firstRectBg = Rect.fromLTWH(firstX, firstY, width, h * 0.95);
    secondRectBg = Rect.fromLTWH(secondX, secondY, width, h * 0.95);
    thirdRectBg = Rect.fromLTWH(thirdX, thirdY, width, h * 0.95);
    fourthRectBg = Rect.fromLTWH(fourthX, fourthY, width, h * 0.95);

    cardBg = Sprite('card_shadow.png');
    initCardsFully();

    opponentCard = opponentCardStartPosition = Rect.fromLTWH(w/2 - width/2, -10, width, h * 0.95);
  }

  initCardsFully() {
    firstRect = firstRectBg;
    secondRect = secondRectBg;
    thirdRect = thirdRectBg;
    fourthRect = fourthRectBg;
    currentCards = drawCards();
  }

  @override
  void render(Canvas c) async {
    cardBg.renderRect(c, firstRectBg);
    cardBg.renderRect(c, secondRectBg);
    cardBg.renderRect(c, thirdRectBg);
    cardBg.renderRect(c, fourthRectBg);

    if (!isGameJustStarted &&
        this.gameScreen.gameLogic.leftPlayer ==
            this.gameScreen.gameLogic.current) {
      if (firstRect != null) {
        currentCards.elementAt(0).img.renderRect(c, firstRect);
        ///Dmg
        TextComponent(
            currentCards
                .elementAt(0)
                .getShortDescription(this.gameScreen.gameLogic.leftPlayer),
            config: TextConfig(
                color: Colors.black, fontSize: 10, textAlign: TextAlign.right))
          ..anchor = Anchor.topRight
          ..x = firstRect.topRight.dx - 5
          ..y = firstRect.topRight.dy + 5
          ..render(c);
        c..restore()
          ..save();
        ///Cost
        TextComponent(
            currentCards
                .elementAt(0)
                .costCount.toString(),
            config: TextConfig(
                color: Colors.black, fontSize: 10, textAlign: TextAlign.right))
          ..anchor = Anchor.topLeft
          ..x = firstRect.topLeft.dx + 5
          ..y = firstRect.topLeft.dy + 5
          ..render(c);
        c..restore()
          ..save();

        ///Name
        TextComponent(
            currentCards
                .elementAt(0)
                .name,
            config: TextConfig(
                color: Colors.black, fontSize: 10, textAlign: TextAlign.center))
          ..anchor = Anchor.bottomCenter
          ..x = firstRect.bottomCenter.dx
          ..y = firstRect.bottomCenter.dy - 5
          ..render(c);
        c..restore()
          ..save();
      }
      if (secondRect != null) {
        currentCards.elementAt(1).img.renderRect(c, secondRect);
        TextComponent(
            currentCards
                .elementAt(1)
                .getShortDescription(this.gameScreen.gameLogic.leftPlayer),
            config: TextConfig(
                color: Colors.black, fontSize: 10, textAlign: TextAlign.right))
          ..anchor = Anchor.topRight
          ..x = secondRect.topRight.dx - 5
          ..y = secondRect.topRight.dy + 5
          ..render(c);
        c..restore()
          ..save();

        ///Cost
        TextComponent(
            currentCards
                .elementAt(1)
                .costCount.toString(),
            config: TextConfig(
                color: Colors.black, fontSize: 10, textAlign: TextAlign.right))
          ..anchor = Anchor.topLeft
          ..x = secondRect.topLeft.dx + 5
          ..y = secondRect.topLeft.dy + 5
          ..render(c);
        c..restore()
          ..save();

        ///Name
        TextComponent(
            currentCards
                .elementAt(1)
                .name,
            config: TextConfig(
                color: Colors.black, fontSize: 10, textAlign: TextAlign.center))
          ..anchor = Anchor.bottomCenter
          ..x = secondRect.bottomCenter.dx
          ..y = secondRect.bottomCenter.dy - 5
          ..render(c);
        c..restore()
          ..save();
      }
      if (thirdRect != null) {
        currentCards.elementAt(2).img.renderRect(c, thirdRect);
        TextComponent(
            currentCards
                .elementAt(2)
                .getShortDescription(this.gameScreen.gameLogic.leftPlayer),
            config: TextConfig(
                color: Colors.black, fontSize: 10, textAlign: TextAlign.right))
          ..anchor = Anchor.topRight
          ..x = thirdRect.topRight.dx - 5
          ..y = thirdRect.topRight.dy + 5
          ..render(c);
        c..restore()
          ..save();

        ///Cost
        TextComponent(
            currentCards
                .elementAt(2)
                .costCount.toString(),
            config: TextConfig(
                color: Colors.black, fontSize: 10, textAlign: TextAlign.right))
          ..anchor = Anchor.topLeft
          ..x = thirdRect.topLeft.dx + 5
          ..y = thirdRect.topLeft.dy + 5
          ..render(c);
        c..restore()
          ..save();

        ///Name
        TextComponent(
            currentCards
                .elementAt(2)
                .name,
            config: TextConfig(
                color: Colors.black, fontSize: 10, textAlign: TextAlign.center))
          ..anchor = Anchor.bottomCenter
          ..x = thirdRect.bottomCenter.dx
          ..y = thirdRect.bottomCenter.dy - 5
          ..render(c);
        c..restore()
          ..save();
      }

      if (fourthRect != null) {
        currentCards.elementAt(3).img.renderRect(c, fourthRect);
        TextComponent(
            currentCards
                .elementAt(3)
                .getShortDescription(this.gameScreen.gameLogic.leftPlayer),
            config: TextConfig(
                color: Colors.black, fontSize: 10, textAlign: TextAlign.right))
          ..anchor = Anchor.topRight
          ..x = fourthRect.topRight.dx - 5
          ..y = fourthRect.topRight.dy + 5
          ..render(c);
        c..restore()
          ..save();

        ///Cost
        TextComponent(
            currentCards
                .elementAt(3)
                .costCount.toString(),
            config: TextConfig(
                color: Colors.black, fontSize: 10, textAlign: TextAlign.right))
          ..anchor = Anchor.topLeft
          ..x = fourthRect.topLeft.dx + 5
          ..y = fourthRect.topLeft.dy + 5
          ..render(c);
        c..restore()
          ..save();

        ///Name
        TextComponent(
            currentCards
                .elementAt(3)
                .name,
            config: TextConfig(
                color: Colors.black, fontSize: 10, textAlign: TextAlign.center))
          ..anchor = Anchor.bottomCenter
          ..x = fourthRect.bottomCenter.dx
          ..y = fourthRect.bottomCenter.dy - 5
          ..render(c);
        c..restore()
          ..save();
      }
    }
  }

  @override
  void update(double t) {
    if (isGameJustStarted &&
        this.gameScreen.gameLogic.rightPlayer ==
            this.gameScreen.gameLogic.current) {
      this.gameScreen.gameLogic.cpuTurn();
      this.isGameJustStarted = false;
    }
    if (this.isGameJustStarted) {
      this.isGameJustStarted = false;
    }
  }

  onVerticalUpdate(DragUpdateDetails details) {
    var dx;
    var dy;
    if (selected != null) {
      dx = selectedRect.topLeft.dx + (details.globalPosition.dx - toChangeX);
      dy = selectedRect.topLeft.dy + (details.globalPosition.dy - toChangeY);
    }
    if (selected == 0) {
      firstRect = Rect.fromLTWH(dx, dy, firstRect.width, firstRect.height);
    } else if (selected == 1) {
      secondRect = Rect.fromLTWH(dx, dy, secondRect.width, secondRect.height);
    } else if (selected == 2) {
      thirdRect = Rect.fromLTWH(dx, dy, thirdRect.width, thirdRect.height);
    } else if (selected == 3) {
      fourthRect = Rect.fromLTWH(dx, dy, fourthRect.width, fourthRect.height);
    }
    dragYPosition = details.globalPosition.dy;
  }

  onTapDown(TapDownDetails details) {
    if (firstRect != null && firstRect.contains(details.globalPosition)) {
      selectedRect = firstRect;
      selected = 0;
    } else if (secondRect != null &&
        secondRect.contains(details.globalPosition)) {
      selectedRect = secondRect;
      selected = 1;
    } else if (thirdRect != null &&
        thirdRect.contains(details.globalPosition)) {
      selectedRect = thirdRect;
      selected = 2;
    } else if (fourthRect != null &&
        fourthRect.contains(details.globalPosition)) {
      selectedRect = fourthRect;
      selected = 3;
    }

    toChangeX = details.globalPosition.dx;
    toChangeY = details.globalPosition.dy;
  }

  onTapUp(TapUpDetails details) {
    selectedRect = null;
    selected = null;
  }

  onStart(DragStartDetails details) {
    if (firstRect != null && firstRect.contains(details.globalPosition)) {
      selectedRect = firstRect;
      selected = 0;
    } else if (secondRect != null &&
        secondRect.contains(details.globalPosition)) {
      selectedRect = secondRect;
      selected = 1;
    } else if (thirdRect != null &&
        thirdRect.contains(details.globalPosition)) {
      selectedRect = thirdRect;
      selected = 2;
    } else if (fourthRect != null &&
        fourthRect.contains(details.globalPosition)) {
      selectedRect = fourthRect;
      selected = 3;
    }

    toChangeX = details.globalPosition.dx;
    toChangeY = details.globalPosition.dy;
  }

  onEnd(DragEndDetails details) {
    if (selected != null) {
      if (dragYPosition < y && _canIUse(currentCards.elementAt(selected))) {
        /*
         *Выполняем ход!
         */
        if (selected == 0) {
          firstRect = null;
        } else if (selected == 1) {
          secondRect = null;
        } else if (selected == 2) {
          thirdRect = null;
        } else if (selected == 3) {
          fourthRect = null;
        }
        gameScreen.cardAction(currentCards.elementAt(selected));
      } else {
        if (selected == 0) {
          firstRect = firstRectBg;
        } else if (selected == 1) {
          secondRect = secondRectBg;
        } else if (selected == 2) {
          thirdRect = thirdRectBg;
        } else if (selected == 3) {
          fourthRect = fourthRectBg;
        }
      }
    }
    selectedRect = null;
    selected = null;
  }

  bool _canIUse(Cards card) {
    bool tmp;
    tmp = card.costType != Cost.initiative ||
        gameScreen.gameLogic.leftPlayer.initiative >= card.costCount;
    return tmp;
  }

  List<Cards> drawCards() {
    this.gameScreen.gameLogic.leftPlayer.currentTurnCards =
        List.of(this.gameScreen.gameLogic.current.cards);
    List<Cards> list = List();
    for (int i = 0; i < 5; i++) {
      int value = random.nextInt(
          this.gameScreen.gameLogic.leftPlayer.currentTurnCards.length);
      list.add(this
          .gameScreen
          .gameLogic
          .leftPlayer
          .currentTurnCards
          .elementAt(value));
      this.gameScreen.gameLogic.leftPlayer.currentTurnCards.removeAt(value);
    }
    return list;
  }
}

class PlayerView extends PositionComponent {
  @override
  void render(Canvas c) {
    // TODO: implement render
  }

  @override
  void update(double t) {
    // TODO: implement update
  }
}

class CardItem {
  Paint paint = Paint()..color = Color.fromRGBO(34, 42, 92, 1);
  Paint paintBg = Paint()..color = Colors.black26;
  Rect bgRect;
  Rect cardRect;

  CardItem(Rect rect) {
    bgRect = cardRect = rect;
  }

  render(Canvas canvas) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(bgRect, Radius.circular(10)), paintBg);
    canvas.drawRRect(
        RRect.fromRectAndRadius(cardRect, Radius.circular(10)), paint);
  }
}

class CardTextBox extends TextBoxComponent {
  Rect rect;

  CardTextBox(String text, this.rect)
      : super(text,
            config: TextConfig(
                fontSize: 10.0,
                fontFamily: 'Awesome Font',
                color: Colors.white),
            boxConfig: TextBoxConfig(maxWidth: rect.width, margin: 10));

  @override
  void drawBackground(Canvas c) {
    c.drawRect(rect, Paint()..color = Colors.transparent);
  }
}
