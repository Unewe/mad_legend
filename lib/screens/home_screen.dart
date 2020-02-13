import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:mad_legend/components/home/black_tree_far_high.dart';
import 'package:mad_legend/components/home/black_tree_middle_high.dart';
import 'package:mad_legend/components/home/black_trees_middle.dart';
import 'package:mad_legend/components/home/black_trees_very_far.dart';
import 'package:mad_legend/components/home/moon.dart';
import 'package:mad_legend/components/home/trees_close.dart';
import 'package:mad_legend/screens/game_screen.dart';
import 'package:mad_legend/screens/screen_base.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mad_legend/main.dart';

class HomeScreen extends Screen {
  Rect start;

  Rect whiteGradientRect;
  Sprite whiteGradientSprite;

  Rect startScreenRect;
  int foregroundOpacity = 0;
  Paint foregroundMask;

  TextComponent startText = TextComponent("Start",
      config: TextConfig(color: Color.fromRGBO(57, 83, 192, 1), fontSize: 40));

  Rect square;
  double degrees = 0;
  bool initiated = false;
  double velocity = 0;

  List<SpriteComponent> components = List();

  HomeScreen(MyGame game) : super(game) {
    bgPaint = Paint()..color = Color(0xff222a5c);
    start = Rect.fromLTWH(width - height * 0.05 - width * 0.2,
        height - height * 0.05 - height * 0.2, width * 0.2, height * 0.2);

    init();
  }

  init() async {
    foregroundMask = Paint()
      ..color = Color.fromARGB(foregroundOpacity, 0, 0, 0);
    startScreenRect = Rect.fromLTWH(0, 0, width + 30, height);
    whiteGradientRect = Rect.fromLTWH(0, 0, height * 4, height);
    var whiteBg = await Flame.images.load("white_gradient.png");
    whiteGradientSprite = Sprite.fromImage(whiteBg);
    components.add(await Moon.initComponent(height, width));
    components.add(await BlackTreesVeryFarHigh.initComponent(height, width));
    components.add(await BlackTreeMiddleHigh.initComponent(height, width));
    components.add(await BlackTreeFarHigh.initComponent(height, width));
    components.add(await BlackTreesMiddle.initComponent(height, width));
    components.add(await CloseTrees.initComponent(height, width));

    ///next
    components.add(
        await CloseTrees.initComponentWithPosition(height, width, height * 4, 0)
          ..renderFlipX = true);

    this.initiated = true;
  }

  initResizable() {}

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (initiated) {
      whiteGradientSprite.renderRect(canvas, whiteGradientRect);

      components.forEach((component) {
        component.render(canvas);
      });

      canvas.drawRect(startScreenRect, Paint()..color = Colors.black);
      canvas.drawRect(Rect.fromLTWH(0, 0, width, height), foregroundMask);
    } else {
      canvas.drawRect(startScreenRect, Paint()..color = Colors.black);
    }
  }

  @override
  void update(double t) {
    if (initiated) {
      if ((this.velocity > 80 || this.velocity < -80) &&
          (startScreenRect.topLeft.dx + (velocity / 200) < 0) &&
          (startScreenRect.topLeft.dx + (velocity / 200) > -height * 6)) {
        startScreenRect = startScreenRect.translate(velocity / 200, 0);
        components.forEach((component) {
          component.setByPosition(Position(velocity / 200, 0));
        });
        this.velocity > 0 ? this.velocity -= 80 : this.velocity += 80;
      }
      this.updateForegroundOpacity();
    } else {}
  }

  updateForegroundOpacity() {
    if (startScreenRect.topLeft.dx < -height * 3.5) {
      foregroundOpacity =
          (-(height * 3.5 + startScreenRect.topLeft.dx) / 3).floor();
      print(foregroundOpacity);
    } else {
      foregroundOpacity -= 2;
    }
    if (foregroundOpacity > 255) foregroundOpacity = 255;
    if (foregroundOpacity < 0) foregroundOpacity = 0;
    foregroundMask.color = Color.fromARGB(foregroundOpacity, 0, 0, 0);
  }

  @override
  void resize(Size size) {
    startScreenRect = Rect.fromLTWH(
        startScreenRect.topLeft.dx, startScreenRect.topLeft.dy, width, height);
    this.components.forEach((component) {
      component.resize(size);
    });
  }

  @override
  onTapDown(TapDownDetails details) {
    this.velocity = 0;
    if (initiated) {
      if (start.contains(details.globalPosition)) {
        game.toScreen(GameScreen(game));
      }
    } else {}
  }

  @override
  onHorizontalUpdate(DragUpdateDetails details) {
    if (initiated &&
        (startScreenRect.topLeft.dx + (details.globalPosition.dx - previousX) < 0) &&
        (startScreenRect.topLeft.dx + (details.globalPosition.dx - previousX) > -height * 6)) {
      startScreenRect =
          startScreenRect.translate(details.globalPosition.dx - previousX, 0);
      components.forEach((component) {
        component
            .setByPosition(Position(details.globalPosition.dx - previousX, 0));
      });
    } else {}

    previousX = details.globalPosition.dx;
  }

  @override
  onVerticalStart(DragStartDetails details) {
    this.velocity = 0;
  }

  @override
  onHorizontalStart(DragStartDetails details) {
    this.velocity = 0;
    previousX = details.globalPosition.dx;
    previousY = details.globalPosition.dy;
  }

  @override
  onHorizontalEnd(DragEndDetails details) {
    this.velocity = details.velocity.pixelsPerSecond.dx;
  }
}
