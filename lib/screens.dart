import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_legend/collections.dart';
import 'package:mad_legend/bottom_cards.dart';
import 'package:mad_legend/game_logic.dart';
import 'package:mad_legend/main.dart';

abstract class Screen extends Component {
  var w,h;
  Rect bgRect;
  Paint bgPaint;
  MyGame game;
  Screen(this.game) {
    w = game.size.width;
    h = game.size.height;
    bgRect = Rect.fromLTWH(0, 0, w, h);
    bgPaint = Paint()..color = Colors.green;
  }

  onVerticalUpdate(DragUpdateDetails details) {}
  onTapDown(TapDownDetails details) {}
  onTapUp(TapUpDetails details) {}
  onStart(DragStartDetails details) {}
  onEnd(DragEndDetails details) {}

  @override
  void resize(Size size) {
    super.resize(size);
    w = size.width;
    h = size.height;
  }
}

/*
 * Main paige screen
 */
class HomeScreen extends Screen{
  Rect start;
  TextComponent startText = TextComponent("Start", config: TextConfig(
      color: Color.fromRGBO(57, 83, 192, 1),
      fontSize: 40
  ));

  HomeScreen(MyGame game) : super(game) {
    bgPaint.color = Color.fromRGBO(236,97,74, 1);
    start = Rect.fromLTWH(
        w - h * 0.05 - w * 0.2,
        h - h * 0.05 - h * 0.2,
        w * 0.2, h * 0.2);
  }

  @override
  void render(Canvas c) {
    c.drawRect(bgRect, bgPaint);
    startText..setByRect(start);
    startText.render(c);
  }

  @override
  void update(double t) {
    // TODO: implement update
  }

  @override
  onTapDown(TapDownDetails details) {
    if(start.contains(details.globalPosition)) {
      game.toScreen(GameScreen(game));
    }
  }
}

/*
 * Screen for Game
 * with 2 characters
 */
class GameScreen extends Screen{

  GameLogic gameLogic;
  // Блок с картами
  BottomBlock bottomBlock;

  Sprite leftPlayerSprite;
  Sprite rightPlayerSprite;
  SpriteComponent rightSpriteComponent;

  // Загрузка спрайтов
  bool download = true;
  // Персонажи
  PlayerBlock leftPlayerBlock;
  PlayerBlock rightPlayerBlock;

  Rect endTurnButton;

  GameScreen(MyGame game) : super(game) {
    init();
    bgPaint.color = Color.fromRGBO(69, 184, 179, 1);
    bottomBlock = BottomBlock(this, 0, h * 0.7, w, h * 0.3);
  }

  // Загрузка
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

/*
 * Screen for shopping
 */
class ShopScreen extends Screen{
  ShopScreen(MyGame game) : super(game);

  @override
  void render(Canvas c) {
    // TODO: implement render
  }

  @override
  void update(double t) {
    // TODO: implement update
  }
}

/*
 * Screen for end game
 */
class EndGameScreen extends Screen{

  Player player;
  TextComponent textComponent;

  EndGameScreen(MyGame game, this.player, win) : super(game) {
    bgPaint = Paint()..color = Color.fromRGBO(56,0,44, 1);
    textComponent = TextComponent( win ? "Победа" : "Поражение", config: win ? TextConfig(
        color: Color.fromRGBO(70, 198, 87, 1),
        fontSize: 40
    ) : TextConfig(
        color: Color.fromRGBO(189, 31, 63, 1),
        fontSize: 40
    ));
    textComponent.setByRect(Rect.fromLTWH(w * 0.1, h * 0.1, w * 0.8, h * 0.8));
  }

  @override
  void render(Canvas c) {
    c.drawRect(bgRect, bgPaint);
    textComponent.render(c);
  }

  @override
  void update(double t) {
    // TODO: implement update
  }

  @override
  onTapDown(TapDownDetails details) {
    this.game.toScreen(HomeScreen(game));
  }
}

/*
 * playerBlock
 */
class PlayerBlock extends PositionComponent {
  GameScreen screen;
  Sprite sprite;
  Rect rect;
  bool upBreath = false;
  bool rightPlayer = false;

  Rect healthBorder;
  Rect health;

  TextComponent healthText;
  TextComponent shield;

  Player player;

  Paint black = Paint()..color = Colors.black;
  Paint red = Paint()..color = Colors.red;

  double defaultHealthLineLength;
  int previousHealth, defaultHealth;

  PlayerBlock(this.screen, this.sprite, this.rightPlayer) {
    rect = Rect.fromLTWH(screen.h * 0.1, screen.h * 0.1, screen.h * 0.45, rightPlayer ? screen.h * 0.6 : screen.h * 0.61 );
    healthBorder = Rect.fromLTWH(screen.h * 0.1, screen.h * 0.01, screen.h * 0.45, screen.h * 0.08);
    health = Rect.fromLTWH(screen.h * 0.11, screen.h * 0.02, screen.h * 0.43, screen.h * 0.06);
    this.player = rightPlayer ? screen.gameLogic.rightPlayer : screen.gameLogic.leftPlayer;
    previousHealth = defaultHealth = player.getHealth();
    defaultHealthLineLength = screen.h * 0.43;
    shield = TextComponent("", config: TextConfig(color: BasicPalette.white.color))
      ..anchor = Anchor.topLeft;
    healthText = TextComponent("", config: TextConfig(color: BasicPalette.white.color))
      ..anchor = Anchor.topLeft;

    if(rightPlayer) {
      healthText
        ..x = screen.w - screen.h * 0.1 - screen.h * 0.25
        ..y = screen.h * 0.02;
      shield
        ..x = screen.w - screen.h * 0.1 - screen.h * 0.58
        ..y = screen.h * 0.02;
    } else {
      healthText
        ..x = screen.h * 0.29
        ..y = screen.h * 0.02;
      shield
        ..x = screen.h * 0.6
        ..y = screen.h * 0.02;
    }
  }

  @override
  void render(Canvas canvas) {
    if(rightPlayer) {
      canvas.translate(screen.w, 0);
      canvas.scale(-1.0, 1.0);
    }
    canvas.drawRect(healthBorder, black);
    canvas.drawRect(health, red);
    sprite.renderRect(canvas, rect);

    for(int i = 0; i < player.initiative; i++) {
      canvas.drawRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(screen.h * 0.5 - (i * screen.h * 0.06), screen.h * 0.1, screen.h * 0.03, screen.h * 0.03),
          Radius.circular(10)), Paint()..color = Colors.red);
    }

    if(rightPlayer) {
      canvas.translate(screen.w, 0);
      canvas.scale(-1.0, 1.0);
    }

    if(rightPlayer) {
      healthText.text = player.getHealth().toString();
      healthText.render(canvas);
      canvas.translate(-screen.w + screen.h * 0.1 + screen.h * 0.25, -screen.h * 0.02);

      shield.text = "+${player.getShield()}";
      shield.render(canvas);
      canvas.translate(-screen.w + screen.h * 0.1 + screen.h * 0.58, -screen.h * 0.02);
    } else {
      healthText.text = player.getHealth().toString();
      healthText.render(canvas);
      canvas.translate(-screen.h * 0.29, -screen.h * 0.02);

      shield.text = "+${player.getShield()}";
      shield.render(canvas);
      canvas.translate(-screen.h * 0.6, -screen.h * 0.02);
    }
  }

  @override
  void update(double t) {
    if(previousHealth != player.getHealth()) {
      health = Rect.fromLTWH(screen.h * 0.11, screen.h * 0.02, defaultHealthLineLength * (player.getHealth() / (defaultHealth / 100) / 100), screen.h * 0.06);
      previousHealth = player.getHealth();
    }

    if(rect.height > screen.h * 0.62) {
      upBreath = false;
    } else if (rect.height < screen.h * 0.6){
      upBreath = true;
    }

    rect = upBreath ? Rect.fromLTWH(rect.left, rect.top - 0.10, rect.width, rect.height + 0.10)
        : Rect.fromLTWH(rect.left, rect.top + 0.05, rect.width, rect.height - 0.05);
  }
}