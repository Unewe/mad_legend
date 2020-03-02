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
import 'package:mad_legend/screens/end_game_screen.dart';
import 'package:mad_legend/screens/game_screen.dart';
import 'package:mad_legend/services/game_context.dart';

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
  Rect firstRect, secondRect, thirdRect, fourthRect, infoRect;
  Rect firstRectBg, secondRectBg, thirdRectBg, fourthRectBg;
  Sprite cardBg;

  int infoIndex;
  CardItem infoCard;
  CardTextBox textBox = CardTextBox(
      "Hola Mundo Hola Mundo Hola Mundo Hola Mundo Hola Mundo Hola Mundo",
      Rect.fromLTWH(200, 200, 200, 200));

  Rect opponentCard, opponentCardStartPosition;
  bool opponentAnimation = false;

  Rect selectedRect;
  var selectedX, selectedY, toChangeX, toChangeY, selected;
  var dragYPosition;
  bool isGameJustStarted = true;

  Paint paint = Paint()..color = Color.fromRGBO(102, 59, 147, 1);
  Paint paintBg = Paint()..color = Colors.black26;

  List<CardItem> opponentCards = List();

  BottomBlock(this.gameScreen, this.x, this.y, this.w, this.h) {
    GameContext.cardsBlock = this;
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

    opponentCard = opponentCardStartPosition =
        Rect.fromLTWH(w / 2 - width / 2, -h * 0.95, width, h * 0.95);
  }

  initCardsFully() {
    firstRect = firstRectBg;
    secondRect = secondRectBg;
    thirdRect = thirdRectBg;
    fourthRect = fourthRectBg;
    currentCards = drawCards();
  }

  @override
  void render(Canvas canvas) async {
    cardBg.renderRect(canvas, firstRectBg);
    cardBg.renderRect(canvas, secondRectBg);
    cardBg.renderRect(canvas, thirdRectBg);
    cardBg.renderRect(canvas, fourthRectBg);

    if (!isGameJustStarted &&
        this.gameScreen.gameLogic.leftPlayer ==
            this.gameScreen.gameLogic.current) {
      if (firstRect != null && selected != 0) {
        CardItem(currentCards.elementAt(0), firstRect)..render(canvas);
      }
      if (secondRect != null && selected != 1) {
        CardItem(currentCards.elementAt(1), secondRect)..render(canvas);
      }
      if (thirdRect != null && selected != 2) {
        CardItem(currentCards.elementAt(2), thirdRect)..render(canvas);
      }
      if (fourthRect != null && selected != 3) {
        CardItem(currentCards.elementAt(3), fourthRect)..render(canvas);
      }

      if (selected != null) {
        Rect tmp;
        if (selected == 0) {
          tmp = firstRect;
        } else if (selected == 1) {
          tmp = secondRect;
        } else if (selected == 2) {
          tmp = thirdRect;
        } else if (selected == 3) {
          tmp = fourthRect;
        }
        CardItem(currentCards.elementAt(selected), tmp)..render(canvas);
      }

      if (infoIndex != null) {
        infoCard.render(canvas);
      }
    }

    ///RenderOpponentCard
    if (this.opponentCards.length > 0) {
      opponentCards.forEach((card) => card..render(canvas));
    }
  }

  @override
  void update(double t) {
    if (isGameJustStarted &&
        this.gameScreen.gameLogic.rightPlayer ==
            this.gameScreen.gameLogic.current) {
      this.gameScreen.gameLogic.cpuTurn(noDelay: false);
      this.isGameJustStarted = false;
    }
    if (this.isGameJustStarted) {
      this.isGameJustStarted = false;
    }

    if (this.opponentCards.length > 0) {
      for (int i = 0; i < opponentCards.length; i++) {
        if (i == 0 || opponentCards[i - 1].speed <= 0.5)
          opponentCards[i].update(t);

        if (opponentCards[i].speed <= 0.1) {
          opponentCards.removeAt(i);
        }
      }
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
    if (infoIndex != null && !infoRect.contains(details.globalPosition)) {
      infoIndex = null;
      infoRect = null;
      infoCard = null;
    }

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
    if (infoIndex != null) {
      infoIndex = null;
      infoRect = null;
      infoCard = null;
    } else if (firstRect != null &&
        firstRect.contains(details.globalPosition) &&
        selected == 0 &&
        infoIndex == null) {
      infoIndex = 0;
      infoRect = Rect.fromLTWH(
          firstRect.topLeft.dx - firstRect.width / 2,
          firstRect.topLeft.dy - firstRect.height,
          firstRect.width * 2,
          firstRect.height * 2);
      infoCard =
          CardItem(currentCards.elementAt(infoIndex), infoRect, isInfo: true);
    } else if (secondRect != null &&
        secondRect.contains(details.globalPosition) &&
        selected == 1 &&
        infoIndex == null) {
      infoIndex = 1;
      infoRect = Rect.fromLTWH(
          secondRect.topLeft.dx - secondRect.width / 2,
          secondRect.topLeft.dy - secondRect.height,
          secondRect.width * 2,
          secondRect.height * 2);
      infoCard =
          CardItem(currentCards.elementAt(infoIndex), infoRect, isInfo: true);
    } else if (thirdRect != null &&
        thirdRect.contains(details.globalPosition) &&
        selected == 2 &&
        infoIndex == null) {
      infoIndex = 2;
      infoRect = Rect.fromLTWH(
          thirdRect.topLeft.dx - thirdRect.width / 2,
          thirdRect.topLeft.dy - thirdRect.height,
          thirdRect.width * 2,
          thirdRect.height * 2);
      infoCard =
          CardItem(currentCards.elementAt(infoIndex), infoRect, isInfo: true);
    } else if (fourthRect != null &&
        fourthRect.contains(details.globalPosition) &&
        selected == 3 &&
        infoIndex == null) {
      infoIndex = 3;
      infoRect = Rect.fromLTWH(
          fourthRect.topLeft.dx - fourthRect.width / 2,
          fourthRect.topLeft.dy - fourthRect.height,
          fourthRect.width * 2,
          fourthRect.height * 2);
      infoCard =
          CardItem(currentCards.elementAt(infoIndex), infoRect, isInfo: true);
    }
    selected = null;
    selectedRect = null;
  }

  onStart(DragStartDetails details) {
    infoIndex = null;
    infoRect = null;
    infoCard = null;
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

  startOpponentAnimation() {
    this.opponentAnimation = true;
  }
}

///CardItem ********************************************************************
class CardItem {
  Paint paint = Paint()..color = Color.fromRGBO(34, 42, 92, 1);
  Paint paintBg = Paint()..color = Colors.black26;
  Rect cardRect;
  Cards card;
  bool isOpponent;
  double angle = 0;
  double rotation = (Random().nextDouble() - 0.45) / 100;
  double speed = 20;
  int actualDmg = 0;
  bool isInfo;
  TextBoxComponent textBoxComponent;

  CardItem(this.card, this.cardRect,
      {this.isOpponent = false, this.isInfo = false}) {
    textBoxComponent = CardTextBox(
        "${card.getDescription(GameContext.gameLogic.current)}", cardRect);
  }

  render(Canvas canvas) {
    if (!isOpponent) {
      ///Img
      card.img.renderRect(canvas, cardRect);

      ///Dmg
      TextComponent(card.getShortDescription(GameContext.gameLogic.current),
          config: TextConfig(
              color: Colors.black,
              fontSize: isInfo ? 20 : 10,
              textAlign: TextAlign.right))
        ..anchor = Anchor.topRight
        ..x = cardRect.topRight.dx - (isInfo ? 10 : 5)
        ..y = cardRect.topRight.dy + (isInfo ? 10 : 5)
        ..render(canvas);
      canvas
        ..restore()
        ..save();

      ///Cost
      TextComponent(card.costCount.toString(),
          config: TextConfig(
              color: Colors.black,
              fontSize: isInfo ? 20 : 10,
              textAlign: TextAlign.right))
        ..anchor = Anchor.topLeft
        ..x = cardRect.topLeft.dx + (isInfo ? 10 : 5)
        ..y = cardRect.topLeft.dy + (isInfo ? 10 : 5)
        ..render(canvas);
      canvas
        ..restore()
        ..save();

      ///Name
      TextComponent(card.name,
          config: TextConfig(
              color: Colors.black,
              fontSize: isInfo ? 20 : 10,
              textAlign: TextAlign.center))
        ..anchor = Anchor.bottomCenter
        ..x = cardRect.bottomCenter.dx
        ..y = cardRect.bottomCenter.dy - (isInfo ? 10 : 5)
        ..render(canvas);
      canvas
        ..restore()
        ..save();

      if (isInfo) {
        textBoxComponent
          ..anchor = Anchor.center
          ..drawBackground(canvas)
          ..x = cardRect.center.dx
          ..y = cardRect.center.dy
          ..render(canvas);
        canvas
          ..restore()
          ..save();
      }
    } else {
      ///Opponents cards animation !!!
      Rect opponentR = Rect.fromLTWH(-cardRect.width / 2, -cardRect.height / 2,
          cardRect.width, cardRect.height);
      canvas.translate(cardRect.center.dx, cardRect.center.dy);
      canvas.rotate(angle);

      ///Img
      card.img.renderRect(canvas, opponentR);

      ///Dmg
      TextComponent(card.getShortDescription(GameContext.gameLogic.current),
          config: TextConfig(
              color: Colors.black, fontSize: 10, textAlign: TextAlign.right))
        ..anchor = Anchor.topRight
        ..x = opponentR.topRight.dx - 5
        ..y = opponentR.topRight.dy + 5
        ..render(canvas);
      canvas
        ..restore()
        ..save();
      canvas.translate(cardRect.center.dx, cardRect.center.dy);
      canvas.rotate(angle);

      ///Cost
      TextComponent(card.costCount.toString(),
          config: TextConfig(
              color: Colors.black, fontSize: 10, textAlign: TextAlign.right))
        ..anchor = Anchor.topLeft
        ..x = opponentR.topLeft.dx + 5
        ..y = opponentR.topLeft.dy + 5
        ..render(canvas);
      canvas
        ..restore()
        ..save();
      canvas.translate(cardRect.center.dx, cardRect.center.dy);
      canvas.rotate(angle);

      ///Name
      TextComponent(card.name,
          config: TextConfig(
              color: Colors.black, fontSize: 10, textAlign: TextAlign.center))
        ..anchor = Anchor.bottomCenter
        ..x = opponentR.bottomCenter.dx
        ..y = opponentR.bottomCenter.dy - 5
        ..render(canvas);
      canvas
        ..restore()
        ..save();
    }
  }

  update(double t) {
    this.cardRect = this.cardRect.translate(0, speed);
    angle += rotation;
    if (speed >= 0.1) speed -= speed * 0.085;
  }
}

class CardTextBox extends TextBoxComponent {
  Rect rect;

  CardTextBox(String text, this.rect)
      : super(text,
            config: TextConfig(
                fontSize: 15.0,
                color: Colors.white,
                textAlign: TextAlign.center),
            boxConfig: TextBoxConfig(maxWidth: rect.width, margin: 10));

  @override
  void drawBackground(Canvas c) {
    c.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(10)),
        Paint()..color = Color(0xaa000000));
  }
}
