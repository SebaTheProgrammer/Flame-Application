import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Bullet extends SpriteAnimationComponent with HasGameRef {
  final double _speed = 500;
  bool isOffScreen = false;
  bool isFacingLeft;

  Bullet({
    required Vector2 position,
    required Vector2 size,
    required SpriteAnimation animation,
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
      position.x -= _speed * dt;
    } else {
      position.x += _speed * dt;
    }

    if (position.x < 0 || position.x > gameRef.size.x) {
      isOffScreen = true;
      removeFromParent();
    }
  }

  @override
  Rect toRect() {
    return Rect.fromLTWH(position.x, position.y, 100, 100);
  }
}
