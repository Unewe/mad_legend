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
  verticalDrag.onStart = game.onVerticalStart;
  verticalDrag.onEnd = game.onVerticalEnd;
  flameUtil.addGestureRecognizer(verticalDrag);

  HorizontalDragGestureRecognizer horizontalDrag = HorizontalDragGestureRecognizer();
  horizontalDrag.onUpdate = game.onHorizontalUpdate;
  horizontalDrag.onStart = game.onHorizontalStart;
  horizontalDrag.onEnd = game.onHorizontalEnd;
  flameUtil.addGestureRecognizer(horizontalDrag);

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

  onTapDown(TapDownDetails details) {
    if(screen != null) screen.onTapDown(details);
  }

  onTapUp(TapUpDetails details) {
    if(screen != null) screen.onTapUp(details);
  }

  onVerticalUpdate(DragUpdateDetails details) {
    if(screen != null) screen.onVerticalUpdate(details);
  }

  onVerticalStart(DragStartDetails details) {
    if(screen != null) screen.onVerticalStart(details);
  }

  onVerticalEnd(DragEndDetails details) {
    if(screen != null) screen.onVerticalEnd(details);
  }

  onHorizontalUpdate(DragUpdateDetails details) {
    if(screen != null) screen.onHorizontalUpdate(details);
  }

  onHorizontalStart(DragStartDetails details) {
    if(screen != null) screen.onHorizontalStart(details);
  }

  onHorizontalEnd(DragEndDetails details) {
    if(screen != null) screen.onHorizontalEnd(details);
  }
}
