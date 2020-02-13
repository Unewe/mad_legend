import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class Moon extends SpriteComponent {
  Moon(double height, double width, Sprite sprite) {
    this.height = height / 1.176;
    this.width = height / 0.525;
    this.x = width * 0.15;
    this.y = 0;
    this.sprite = sprite;
  }

  @override
  void resize(Size size) {
    this.height = size.height / 1.176;
    this.width = size.height / 0.525;
  }

  @override
  void update(double t) {}

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.restore();
    canvas.save();
  }

  @override
  void setByPosition(Position position) {
    this.x += position.x / 15;
  }

  static Future<SpriteComponent> initComponent(double height, double width) async {
    var img = await Flame.images.load("moon_765.png");
    Sprite sprite = Sprite.fromImage(img);
    return Moon(height, width, sprite);
  }
}
