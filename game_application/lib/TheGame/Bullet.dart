import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Bullet extends SpriteAnimationComponent with HasGameRef {
  final double speed;
  bool isOffScreen = false;
  bool isFacingLeft;

  Bullet({
    required Vector2 position,
    required Vector2 size,
    required SpriteAnimation animation,
    this.speed = 500,
    required this.isFacingLeft,
  }) : super(position: position, size: size, animation: animation) {
    if (isFacingLeft) {
      scale.x = -1;
      anchor = Anchor.center;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isFacingLeft) {
      position.x -= speed * dt;
    } else {
      position.x += speed * dt;
    }

    if (position.x < 0 || position.x > gameRef.size.x) {
      isOffScreen = true;
      removeFromParent();
    }
  }

  @override
  Rect toRect() {
    return Rect.fromLTWH(position.x, position.y, 300, 200);
  }
}
