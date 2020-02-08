import 'package:mad_legend/screens/screen_base.dart';
import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_legend/models/collections.dart';
import 'package:mad_legend/screen_bocks/cards_block.dart';
import 'package:mad_legend/services/game_logic.dart';
import 'package:mad_legend/main.dart';
import 'package:mad_legend/screen_bocks/player_bock.dart';

class GameScreen extends Screen{

  GameLogic gameLogic;
  BottomBlock bottomBlock;

  Sprite leftPlayerSprite;
  Sprite rightPlayerSprite;
  SpriteComponent rightSpriteComponent;

  bool download = true;

  PlayerBlock leftPlayerBlock;
  PlayerBlock rightPlayerBlock;
  Rect endTurnButton;

  GameScreen(MyGame game) : super(game) {
    init();
    bgPaint.color = Color.fromRGBO(69, 184, 179, 1);
    bottomBlock = BottomBlock(this, 0, h * 0.7, w, h * 0.3);
  }

  init() async {

    gameLogic = GameLogic(Player("Left", PlayerClass.DEFAULT), Player("right", PlayerClass.DEFAULT), this);
    endTurnButton = Rect.fromLTWH(
        w - h * 0.05 - w * 0.1,
        h - h * 0.05 - h * 0.1,
        w * 0.1, h * 0.1);

    var imageLeft = await Flame.images.load("knight.png");
    var imageRight = await Flame.images.load("archer.png");
    leftPlayerSprite = Sprite.fromImage(imageLeft);
    leftPlayerBlock = PlayerBlock(this, leftPlayerSprite, false);
    rightPlayerSprite = Sprite.fromImage(imageRight);
    rightPlayerBlock = PlayerBlock(this, rightPlayerSprite, true);
    download = false;
  }

  @override
  void render(Canvas c) {
    if(!download) {
      c.drawRect(bgRect, bgPaint);
      c.drawRect(endTurnButton, Paint()..color = Color.fromRGBO(189, 31, 63, 1));
      leftPlayerBlock.render(c);
      rightPlayerBlock.render(c);
      bottomBlock.render(c);
    } else {
      c.drawRect(bgRect, Paint()..color = Colors.pink);
    }
  }

  @override
  void update(double t) {
    if(!download) {
      leftPlayerBlock.update(t);
      rightPlayerBlock.update(t);

      bottomBlock.update(t);
    }
  }

  cardAction(Cards card) {
    gameLogic.dropCard(card);
  }

  endTurn() {
    gameLogic.endTurn();
  }

  @override
  onTapUp(TapUpDetails details) {
    bottomBlock.onTapUp(details);
  }

  @override
  onTapDown(TapDownDetails details) {
    bottomBlock.onTapDown(details);

    if(endTurnButton.contains(details.globalPosition)) {
      endTurn();
    }
  }

  @override
  onVerticalUpdate(DragUpdateDetails details) {
    bottomBlock.onVerticalUpdate(details);
  }

  onStart(DragStartDetails details) {
    bottomBlock.onStart(details);
  }
  onEnd(DragEndDetails details) {
    bottomBlock.onEnd(details);
  }

  @override
  bool loaded() {
    return true;
  }
}