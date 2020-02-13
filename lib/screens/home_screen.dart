import 'package:flame/anchor.dart';
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
  Rect whiteGradientRect;
  Sprite whiteGradientSprite;

  Rect startScreenRect;
  int foregroundOpacity = 0;
  int textOpacity = 0;
  Paint foregroundMask;

  TextComponent startText;
  TextComponent menu;
  bool menuOn = false;

  TextComponent name;
  TextComponent shop;
  TextComponent bag;
  TextComponent settings;
  List<TextComponent> menuList = List();

  bool initiated = false;
  double velocity = 0;

  List<SpriteComponent> components = List();


  HomeScreen(MyGame game) : super(game) {
    bgPaint = Paint()..color = Color(0xff2b248f);

    init();
  }

  init() async {
    foregroundMask = Paint()
      ..color = Color.fromARGB(foregroundOpacity, 0, 0, 0);
    startScreenRect = Rect.fromLTWH(0, 0, width + 10, height);
    whiteGradientRect = Rect.fromLTWH(0, 0, height * 4, height);
    var whiteBg = await Flame.images.load("white_gradient.png");
    whiteGradientSprite = Sprite.fromImage(whiteBg);
    components.add(await Moon.initComponent(height, width));
    components.add(await BlackTreesVeryFarHigh.initComponent(height, width));
    components.add(await BlackTreeMiddleHigh.initComponent(height, width));
    components.add(await BlackTreeFarHigh.initComponent(height, width));
    components.add(await BlackTreesMiddle.initComponent(height, width));
    components.add(await CloseTrees.initComponent(height, width));

    ///TextInitiation
    startText = TextComponent("START",
        config: TextConfig(color: Colors.white, fontSize: 40, fontFamily: "YagiDouble"))
      ..anchor = Anchor.bottomRight
      ..setByPosition(Position(width - 20, height - 20));
    menu = TextComponent("MENU",
        config: TextConfig(color: Colors.white, fontSize: 40, fontFamily: "YagiDouble"))
      ..anchor = Anchor.topLeft
      ..setByPosition(Position(20, 20));

    name = TextComponent("NAME",
        config: TextConfig(color: Colors.white, fontSize: 40, fontFamily: "YagiDouble"))
      ..anchor = Anchor.topRight
      ..setByPosition(Position(0, menu.toRect().bottom + 30));
    shop = TextComponent("SHOP",
        config: TextConfig(color: Colors.white, fontSize: 40, fontFamily: "YagiDouble"),)
      ..anchor = Anchor.topRight
      ..setByPosition(Position(0, name.toRect().bottom + 10));
    bag = TextComponent("BAG",
        config: TextConfig(color: Colors.white, fontSize: 40, fontFamily: "YagiDouble"))
      ..anchor = Anchor.topRight
      ..setByPosition(Position(0, shop.toRect().bottom + 10));
    settings = TextComponent("SETTINGS",
        config: TextConfig(color: Colors.white, fontSize: 40, fontFamily: "YagiDouble"))
      ..anchor = Anchor.topRight
      ..setByPosition(Position(0, bag.toRect().bottom + 10));

    menuList..add(name)..add(shop)..add(bag)..add(settings);
    ///next
    components.add(
        await CloseTrees.initComponentWithPosition(height, width, height * 4, 0)
          ..renderFlipX = true);
    this.initiated = true;
    this.velocity = -4600;
  }

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

      renderText(canvas);
    } else {
      canvas.drawRect(startScreenRect, Paint()..color = Colors.black);
    }
  }

  renderText(Canvas canvas) {
    startText.render(canvas);
    canvas.restore();
    canvas.save();
    menu.render(canvas);
    canvas.restore();
    canvas.save();

    this.menuList.forEach((item) {
      item.render(canvas);
      canvas.restore();
      canvas.save();
    });

  }

  @override
  void update(double t) {
    if (initiated) {
      if ((this.velocity > 50 || this.velocity < -50) &&
          (startScreenRect.topLeft.dx + (velocity / 200) < 0) &&
          (startScreenRect.topLeft.dx + (velocity / 200) > -height * 6)) {
        startScreenRect = startScreenRect.translate(velocity / 200, 0);
        components.forEach((component) {
          component.setByPosition(Position(velocity / 200, 0));
        });
        this.velocity > 0 ? this.velocity -= 50 : this.velocity += 50;
      }
      this.updateForegroundOpacity();
      this.updateText(t);
    } else {}
  }

  updateText(double t) {
    ///TextOpacity for future
//    if(textOpacity < 255) {
//      this.textOpacity += 2;
//      if(textOpacity > 255) textOpacity = 255;
//      startText.config = TextConfig(color: Color.fromARGB(textOpacity, 57, 83, 192), fontSize: 40, fontFamily: "YagiDouble");
//      menu.config = TextConfig(color: Color.fromARGB(textOpacity, 57, 83, 192), fontSize: 40, fontFamily: "YagiDouble");
//    }

    this.menuList.forEach((item) {
      int index = menuList.indexOf(item);


      if(this.menuOn && item.x - item.width < this.menu.x) {
        if(index  == 0 || menuList.elementAt(index - 1).x > (this.menu.x + this.menu.width/2)) {
          item.x += ((this.menu.x - (item.x - item.width))/5).floor() + 1;
        }
      }

      if(!this.menuOn && item.x > 0) {
        item.x -= (item.x/5).floor() + 1;
      }
    });
  }

  updateForegroundOpacity() {
    if (startScreenRect.topLeft.dx < -height * 3.5) {
      foregroundOpacity =
          (-(height * 3.5 + startScreenRect.topLeft.dx) / 3).floor();
    } else {
      foregroundOpacity -= 2;
    }
    if (foregroundOpacity > 255) foregroundOpacity = 255;
    if (foregroundOpacity < 0) foregroundOpacity = 0;
    foregroundMask.color = Color.fromARGB(foregroundOpacity, 0, 0, 0);
  }

  @override
  void resize(Size size) {
    print("Resize");
    this.width = size.width;
    this.height = size.height;

    startScreenRect = Rect.fromLTWH(
        startScreenRect.topLeft.dx, startScreenRect.topLeft.dy, size.width + 10, size.height);

    this.components.forEach((component) {
      component.resize(size);
    });
  }

  @override
  onTapDown(TapDownDetails details) {
    this.velocity = 0;
    if (initiated) {
      if (startText.toRect().contains(details.globalPosition)) {
        game.toScreen(GameScreen(game));
      } else if(menu.toRect().contains(details.globalPosition)) {
        this.menuOn = !this.menuOn;
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
