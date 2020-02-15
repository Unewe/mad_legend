library screen.base;
import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_legend/main.dart';

abstract class Screen extends Component {

  double previousX, previousY;
  var width,height;
  Rect bgRect;
  Paint bgPaint;
  FlameGame game;

  Screen(this.game) {
    width = game.size.width;
    height = game.size.height;
    bgRect = Rect.fromLTWH(0, 0, height * 4, height);
    bgPaint = Paint()..color = Color(0xff222a5c);
  }

  onTapDown(TapDownDetails details) {}
  onTapUp(TapUpDetails details) {}

  onVerticalUpdate(DragUpdateDetails details) {}
  onVerticalStart(DragStartDetails details) {}
  onVerticalEnd(DragEndDetails details) {}

  onHorizontalUpdate(DragUpdateDetails details) {}
  onHorizontalStart(DragStartDetails details) {}
  onHorizontalEnd(DragEndDetails details) {}

  flutterWidgetAction() {}

  @override
  void render(Canvas canvas) {
    canvas.drawRect(bgRect, bgPaint);
  }

  @override
  void resize(Size size) {
    super.resize(size);
    width = size.width;
    height = size.height;
    bgRect = Rect.fromLTWH(0, 0, height * 3, height);
  }
}