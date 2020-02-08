import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_legend/services/game_logic.dart';
import 'package:mad_legend/screens/game_screen.dart';


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