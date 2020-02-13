import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class CloseTrees extends SpriteComponent {
  CloseTrees(double height, double width, double x, double y, Sprite sprite) {
    this.height = height;
    this.width = height * 4;
    this.x = width + x;
    this.y = 0 + y;
    this.sprite = sprite;
  }

  @override
  void resize(Size size) {
    this.height = size.height;
    this.width = size.height * 4;
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
    this.x += position.x;
    this.y += position.y;
  }

  static Future<SpriteComponent> initComponent(double height, double width) async {
    var img = await Flame.images.load("trees_close_900.png");
    Sprite sprite = Sprite.fromImage(img);
    return CloseTrees(height, width, 0, 0, sprite);
  }

  static Future<SpriteComponent> initComponentWithPosition(double height, double width, double x, double y) async {
    var img = await Flame.images.load("trees_close_900.png");
    Sprite sprite = Sprite.fromImage(img);
    return CloseTrees(height, width, x, y, sprite);
  }
}
