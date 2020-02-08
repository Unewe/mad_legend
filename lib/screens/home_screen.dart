import 'package:mad_legend/screens/game_screen.dart';
import 'package:mad_legend/screens/screen_base.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_legend/main.dart';

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

  }

  @override
  onTapDown(TapDownDetails details) {
    if(start.contains(details.globalPosition)) {
      game.toScreen(GameScreen(game));
    }
  }
}