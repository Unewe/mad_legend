import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class BlackTreesVeryFarHigh extends SpriteComponent {
  BlackTreesVeryFarHigh(double height, double width, Sprite sprite) {
    this.height = height / 1.91;
    this.width = height / 0.39;
    this.x = width * 0.37;
    this.y = height - this.height;
    this.sprite = sprite;
  }

  @override
  void resize(Size size) {
    this.height = size.height / 1.91;
    this.width = size.height / 0.39;
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
    this.x += position.x / 3.1;
  }

  static Future<SpriteComponent> initComponent(double height, double width) async {
    var img = await Flame.images.load("trees_50_471.png");
    Sprite sprite = Sprite.fromImage(img);
    return BlackTreesVeryFarHigh(height, width, sprite);
  }
}
