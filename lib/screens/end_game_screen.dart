import 'package:flame/anchor.dart';
import 'package:flame/components/text_box_component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_legend/screen_blocks/cards_block.dart';
import 'package:mad_legend/services/player-logic.dart';
import 'package:mad_legend/main.dart';
import 'package:mad_legend/screens/home_screen.dart';
import 'package:mad_legend/screens/screen_base.dart';

class EndGameScreen extends Screen {
  Player player;
  TextComponent textComponent;

  EndGameScreen(FlameGame game, this.player, win) : super(game) {
    bgPaint = Paint()..color = Color.fromRGBO(56, 0, 44, 1);
    textComponent = TextComponent(win ? "Победа" : "Поражение",
        config: win
            ? TextConfig(color: Color.fromRGBO(70, 198, 87, 1), fontSize: 40)
            : TextConfig(color: Color.fromRGBO(189, 31, 63, 1), fontSize: 40));
    textComponent.setByRect(
        Rect.fromLTWH(width * 0.1, height * 0.1, width * 0.8, height * 0.8));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(bgRect, bgPaint);
    textComponent.render(canvas);
  }

  @override
  void update(double t) {}

  @override
  onTapDown(TapDownDetails details) {
    this.game.toScreen(HomeScreen(game));
  }
}
