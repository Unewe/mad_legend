import 'package:mad_legend/screens/screen_base.dart';
import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_legend/models/collections.dart';
import 'package:mad_legend/screen_blocks/cards_block.dart';
import 'package:mad_legend/services/game_logic.dart';
import 'package:mad_legend/main.dart';
import 'package:mad_legend/screen_blocks/player_bock.dart';
import 'package:mad_legend/store/player.dart';

class GameScreen extends Screen{

  GameLogic gameLogic;
  BottomBlock bottomBlock;

  Sprite leftPlayerSprite;
  Sprite rightPlayerSprite;
  SpriteComponent rightSpriteComponent;

  bool initiated = false;

  PlayerBlock leftPlayerBlock;
  PlayerBlock rightPlayerBlock;
  Rect endTurnButton;
  int foregroundOpacity = 255;

  GameScreen(FlameGame game) : super(game) {
    init();
    bgPaint.color = Color.fromRGBO(69, 184, 179, 1);
  }

  init() async {
    Player currentPlayer = await getPlayer();

    gameLogic = GameLogic(currentPlayer, Player("right", PlayerClass.DEFAULT), this);
    endTurnButton = Rect.fromLTWH(
        width - height * 0.05 - width * 0.1,
        height - height * 0.05 - height * 0.1,
        width * 0.1, height * 0.1);

    var imageLeft = await Flame.images.load("knight.png");
    var imageRight = await Flame.images.load("archer.png");
    leftPlayerSprite = Sprite.fromImage(imageLeft);
    leftPlayerBlock = PlayerBlock(this, leftPlayerSprite, false);
    rightPlayerSprite = Sprite.fromImage(imageRight);
    rightPlayerBlock = PlayerBlock(this, rightPlayerSprite, true);
    bottomBlock = BottomBlock(this, 0, height * 0.7, width, height * 0.3);
    initiated = true;
  }

  @override
  void render(Canvas c) {
    if(initiated) {
      c.drawRect(bgRect, bgPaint);
      c.drawRect(endTurnButton, Paint()..color = Color.fromRGBO(189, 31, 63, 1));
      leftPlayerBlock.render(c);
      rightPlayerBlock.render(c);
      bottomBlock.render(c);
      if(foregroundOpacity > 0) c.drawRect(bgRect, Paint()..color = Color.fromARGB(foregroundOpacity, 0, 0, 0));
    } else {
      c.drawRect(bgRect, Paint()..color = Colors.black);
    }
  }

  @override
  void update(double t) {
    if(initiated) {
      leftPlayerBlock.update(t);
      rightPlayerBlock.update(t);
      bottomBlock.update(t);
      foregroundOpacity -= 3;
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
    if(initiated) {
      bottomBlock.onTapUp(details);
    }
  }

  @override
  onTapDown(TapDownDetails details) {
    if(initiated) {
      bottomBlock.onTapDown(details);

      if(endTurnButton.contains(details.globalPosition)) {
        endTurn();
      }
    }
  }

  @override
  onVerticalUpdate(DragUpdateDetails details) {
    if(initiated) {
      bottomBlock.onVerticalUpdate(details);
    }
  }

  @override
  onVerticalStart(DragStartDetails details) {
    if(initiated) {
      bottomBlock.onStart(details);
    }
  }

  @override
  onVerticalEnd(DragEndDetails details) {
    if(initiated) {
      bottomBlock.onEnd(details);
    }
  }

  onHorizontalUpdate(DragUpdateDetails details) {
    if(initiated) {
      bottomBlock.onVerticalUpdate(details);
    }
  }
  onHorizontalStart(DragStartDetails details) {
    if(initiated) {
      bottomBlock.onStart(details);
    }
  }
  onHorizontalEnd(DragEndDetails details) {
    if(initiated) {
      bottomBlock.onEnd(details);
    }
  }

  @override
  bool loaded() {
    return true;
  }
}