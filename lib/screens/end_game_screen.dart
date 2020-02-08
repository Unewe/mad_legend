import 'package:flame/components/text_component.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_legend/services/game_logic.dart';
import 'package:mad_legend/main.dart';
import 'package:mad_legend/screens/home_screen.dart';
import 'package:mad_legend/screens/screen_base.dart';

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