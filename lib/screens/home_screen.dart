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

  Rect square;
  double degrees = 0;

  HomeScreen(MyGame game) : super(game) {
    bgPaint.color = Color.fromRGBO(236,97,74, 1);
    start = Rect.fromLTWH(
        w - h * 0.05 - w * 0.2,
        h - h * 0.05 - h * 0.2,
        w * 0.2, h * 0.2);

    initBackground();
  }

  initBackground() {
    square = Rect.fromLTWH(-50, -50, 100, 100);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(bgRect, bgPaint);
    startText..setByRect(start);
    startText.render(canvas);
    canvas.restore();
    canvas.save();

    canvas.translate(100, 100);
    canvas.rotate(degrees);
    canvas.drawRect(square, Paint()..color = Color(0xFFFFDBA5));
    canvas.restore();
    canvas.save();
  }

  @override
  void update(double t) {
    this.degrees += 0.1;
    if (this.degrees >= 360) this.degrees = 0;
  }

  @override
  onTapDown(TapDownDetails details) {
    if(start.contains(details.globalPosition)) {
      game.toScreen(GameScreen(game));
    }
  }
}