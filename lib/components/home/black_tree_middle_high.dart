import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class BlackTreeMiddleHigh extends SpriteComponent {
  BlackTreeMiddleHigh(double height, double width, Sprite sprite) {
    this.height = height / 1.35;
    this.width = height / 2.29;
    this.x = width * 1.4;
    this.y = height - this.height;
    this.sprite = sprite;
  }

  @override
  void resize(Size size) {
    this.height = size.height / 1.35;
    this.width = size.height / 2.29;
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
    this.x += position.x / 2;
  }

  static Future<SpriteComponent> initComponent(double height, double width) async {
    var img = await Flame.images.load("tree_663.png");
    Sprite sprite = Sprite.fromImage(img);
    return BlackTreeMiddleHigh(height, width, sprite);
  }
}
