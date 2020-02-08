import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:mad_legend/screens/home_screen.dart';
import 'screens/screen_base.dart';

void main() async {
  MyGame game = MyGame();

  runApp(game.widget);

  Util flameUtil = Util();
  flameUtil.setLandscape();
  flameUtil.fullScreen();

  VerticalDragGestureRecognizer verticalDrag = VerticalDragGestureRecognizer();
  verticalDrag.onUpdate = game.onVerticalUpdate;
  verticalDrag.onStart = game.onStart;
  verticalDrag.onEnd = game.onEnd;
  flameUtil.addGestureRecognizer(verticalDrag);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  tapper.onTapUp = game.onTapUp;
  flameUtil.addGestureRecognizer(tapper);
}

class MyGame extends Game {
  Size size;
  Screen screen;

  MyGame() {}

  @override
  void render(Canvas canvas) {
    if (screen != null) screen.render(canvas);
  }

  @override
  void update(double t) {
    if (screen != null) screen.update(t);
  }

  @override
  void resize(Size size) {
    this.size = size;
    if (this.screen == null && size.width > size.height)
      screen = HomeScreen(this);
    if (screen != null) screen.resize(size);
  }

  toScreen(Screen screen) {
    this.screen = screen;
  }

  onVerticalUpdate(DragUpdateDetails details) {
    screen.onVerticalUpdate(details);
  }

  onTapDown(TapDownDetails details) {
    screen.onTapDown(details);
  }

  onTapUp(TapUpDetails details) {
    screen.onTapUp(details);
  }

  onStart(DragStartDetails details) {
    screen.onStart(details);
  }

  onEnd(DragEndDetails details) {
    screen.onEnd(details);
  }
}
