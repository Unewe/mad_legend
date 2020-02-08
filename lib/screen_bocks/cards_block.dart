import 'dart:math';
import 'dart:ui';
import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/text_box_component.dart';
import 'package:flame/text_config.dart';
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

    firstX = w/2 - width - width - h * 0.025 - h * 0.05;
    secondX = w/2 - width - h * 0.025;
    thirdX = w/2 + h * 0.025;
    fourthX = w/2 + width + h * 0.05 + h * 0.025;

    firstRectBg =  Rect.fromLTWH(firstX, firstY, width, h * 0.95);
    secondRectBg = Rect.fromLTWH(secondX, secondY, width, h * 0.95);
    thirdRectBg = Rect.fromLTWH(thirdX, thirdY, width, h * 0.95);
    fourthRectBg = Rect.fromLTWH(fourthX, fourthY, width, h * 0.95);
    initCardsFully();
  }

  initCards(int index) {
    if(index == 0) firstTextBox = CardTextBox(currentCards.elementAt(0).getDescription(gameScreen.gameLogic.leftPlayer), firstRect);
    if(index == 1) secondTextBox = CardTextBox(currentCards.elementAt(1).getDescription(gameScreen.gameLogic.leftPlayer), secondRect);
    if(index == 2) thirdTextBox = CardTextBox(currentCards.elementAt(2).getDescription(gameScreen.gameLogic.leftPlayer), thirdRect);
    if(index == 3) fourthTextBox = CardTextBox(currentCards.elementAt(3).getDescription(gameScreen.gameLogic.leftPlayer), fourthRect);
  }

  initAllCardsText() async {
    if (firstRect != null && _needToRedraw(currentCards.elementAt(0)) && _isTextEqual(firstTextBox, currentCards.elementAt(0)) )
      firstTextBox = CardTextBox(currentCards.elementAt(0).getDescription(
          gameScreen.gameLogic.leftPlayer), firstRect);
    if (secondRect != null && _needToRedraw(currentCards.elementAt(1)) && _isTextEqual(secondTextBox, currentCards.elementAt(1)))
      secondTextBox = CardTextBox(currentCards.elementAt(1).getDescription(
          gameScreen.gameLogic.leftPlayer), secondRect);
    if (thirdRect != null && _needToRedraw(currentCards.elementAt(2)) && _isTextEqual(thirdTextBox, currentCards.elementAt(2)))
      thirdTextBox = CardTextBox(currentCards.elementAt(2).getDescription(
          gameScreen.gameLogic.leftPlayer), thirdRect);
    if (fourthRect != null && _needToRedraw(currentCards.elementAt(3)) && _isTextEqual(fourthTextBox, currentCards.elementAt(3)))
      fourthTextBox = CardTextBox(currentCards.elementAt(3).getDescription(
          gameScreen.gameLogic.leftPlayer), fourthRect);

  }

  bool _needToRedraw(Cards card) {
    return card.feature == Features.meleeDefault ||
        card.feature == Features.rangedDefault ||
        card.feature == Features.shieldDefault;
  }

  bool _isTextEqual(TextBoxComponent textBox, Cards card) {
    return textBox.text !=  card.getDescription(
        gameScreen.gameLogic.leftPlayer);
  }

  initCardsFully() {
    firstRect = firstRectBg;
    secondRect = secondRectBg;
    thirdRect = thirdRectBg;
    fourthRect = fourthRectBg;
    currentCards = drawCards();
    firstTextBox = CardTextBox(currentCards.elementAt(0).getDescription(gameScreen.gameLogic.leftPlayer), firstRect);
    secondTextBox = CardTextBox(currentCards.elementAt(1).getDescription(gameScreen.gameLogic.leftPlayer), secondRect);
    thirdTextBox = CardTextBox(currentCards.elementAt(2).getDescription(gameScreen.gameLogic.leftPlayer), thirdRect);
    fourthTextBox = CardTextBox(currentCards.elementAt(3).getDescription(gameScreen.gameLogic.leftPlayer), fourthRect);
  }

  @override
  void render(Canvas c) async {

    c.drawRRect(RRect.fromRectAndRadius(firstRectBg, Radius.circular(10)), paintBg);
    c.drawRRect(RRect.fromRectAndRadius(secondRectBg, Radius.circular(10)), paintBg);
    c.drawRRect(RRect.fromRectAndRadius(thirdRectBg, Radius.circular(10)), paintBg);
    c.drawRRect(RRect.fromRectAndRadius(fourthRectBg, Radius.circular(10)), paintBg);

    if(!isGameJustStarted && this.gameScreen.gameLogic.leftPlayer == this.gameScreen.gameLogic.current) {
      if(firstRect != null) c.drawRRect(RRect.fromRectAndRadius(firstRect, Radius.circular(10)), paint);
      if(secondRect != null) c.drawRRect(RRect.fromRectAndRadius(secondRect, Radius.circular(10)), paint);
      if(thirdRect != null) c.drawRRect(RRect.fromRectAndRadius(thirdRect, Radius.circular(10)), paint);
      if(fourthRect != null) c.drawRRect(RRect.fromRectAndRadius(fourthRect, Radius.circular(10)), paint);

      if(firstRect != null) {
        firstTextBox
          ..anchor = Anchor.topLeft
          ..x = firstRect.topLeft.dx
          ..y = firstRect.topLeft.dy
          ..render(c);
        c.restore();
        c.save();
      }

      if(secondRect != null) {
        secondTextBox
          ..anchor = Anchor.topLeft
          ..x = secondRect.topLeft.dx
          ..y = secondRect.topLeft.dy
          ..render(c);
        c.restore();
        c.save();
      }

      if(thirdRect != null) {
        thirdTextBox
          ..anchor = Anchor.topLeft
          ..x = thirdRect.topLeft.dx
          ..y = thirdRect.topLeft.dy
          ..render(c);
        c.restore();
        c.save();
      }

      if(fourthRect != null) {
        fourthTextBox
          ..anchor = Anchor.topLeft
          ..x = fourthRect.topLeft.dx
          ..y = fourthRect.topLeft.dy
          ..render(c);
        c.restore();
        c.save();
      }
    }
  }

  @override
  void update(double t) {
    if(isGameJustStarted && this.gameScreen.gameLogic.rightPlayer == this.gameScreen.gameLogic.current) {
      this.gameScreen.gameLogic.cpuTurn();
      this.isGameJustStarted = false;
    }
    if(this.isGameJustStarted) {
      this.isGameJustStarted = false;
    }

    firstTextBox.update(t);
    secondTextBox.update(t);
    thirdTextBox.update(t);
    fourthTextBox.update(t);
  }

  onVerticalUpdate(DragUpdateDetails details) {
    var dx;
    var dy;
    if(selected != null) {
      dx = selectedRect.topLeft.dx + (details.globalPosition.dx - toChangeX);
      dy = selectedRect.topLeft.dy + (details.globalPosition.dy - toChangeY);
    }
    if(selected == 0) {
      firstRect = Rect.fromLTWH(dx, dy, width, h);
    } else if(selected == 1) {
      secondRect = Rect.fromLTWH(dx, dy, width, h);
    } else if(selected == 2) {
      thirdRect = Rect.fromLTWH(dx, dy, width, h);
    } else if(selected == 3) {
      fourthRect = Rect.fromLTWH(dx, dy, width, h);
    }
    dragYPosition = details.globalPosition.dy;
  }

  onTapDown(TapDownDetails details) {
    if(firstRect != null && firstRect.contains(details.globalPosition)) {
      selectedRect = firstRect;
      selected = 0;
    } else if(secondRect != null && secondRect.contains(details.globalPosition)) {
      selectedRect = secondRect;
      selected = 1;
    } else if(thirdRect != null && thirdRect.contains(details.globalPosition)) {
      selectedRect = thirdRect;
      selected = 2;
    } else if(fourthRect != null && fourthRect.contains(details.globalPosition)) {
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
    if(firstRect != null && firstRect.contains(details.globalPosition)) {
      selectedRect = firstRect;
      selected = 0;
    } else if(secondRect != null && secondRect.contains(details.globalPosition)) {
      selectedRect = secondRect;
      selected = 1;
    } else if(thirdRect != null && thirdRect.contains(details.globalPosition)) {
      selectedRect = thirdRect;
      selected = 2;
    } else if(fourthRect != null && fourthRect.contains(details.globalPosition)) {
      selectedRect = fourthRect;
      selected = 3;
    }

    toChangeX = details.globalPosition.dx;
    toChangeY = details.globalPosition.dy;
  }
  onEnd(DragEndDetails details) {
    if(selected != null) {
      if(dragYPosition < y && _canIUse(currentCards.elementAt(selected))) {
        /*
         *Выполняем ход!
         */
        if(selected == 0) {
          firstRect = null;
        } else if(selected == 1) {
          secondRect = null;
        } else if(selected == 2) {
          thirdRect = null;
        } else if(selected == 3) {
          fourthRect = null;
        }
        gameScreen.cardAction(currentCards.elementAt(selected));
      } else {
        if(selected == 0) {
          firstRect = firstRectBg;
        } else if(selected == 1) {
          secondRect = secondRectBg;
        } else if(selected == 2) {
          thirdRect = thirdRectBg;
        } else if(selected == 3) {
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
    this.gameScreen.gameLogic.leftPlayer.currentTurnCards = List.of(this.gameScreen.gameLogic.current.cards);
    List<Cards> list = List();
    for(int i = 0; i < 5; i++) {
      int value = random.nextInt(this.gameScreen.gameLogic.leftPlayer.currentTurnCards.length);
      list.add(this.gameScreen.gameLogic.leftPlayer.currentTurnCards.elementAt(value));
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
    canvas.drawRRect(RRect.fromRectAndRadius(bgRect, Radius.circular(10)), paintBg);
    canvas.drawRRect(RRect.fromRectAndRadius(cardRect, Radius.circular(10)), paint);
  }
}

class CardTextBox extends TextBoxComponent {

  Rect rect;

  CardTextBox(String text, this.rect)
      : super(text,
      config: TextConfig(fontSize: 10.0, fontFamily: 'Awesome Font', color: Colors.white), boxConfig: TextBoxConfig(maxWidth: rect.width, margin: 10));

  @override
  void drawBackground(Canvas c) {
    c.drawRect(rect, Paint()..color = Colors.transparent);
  }
}