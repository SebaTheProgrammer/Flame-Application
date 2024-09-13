import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Balloon extends SpriteAnimationComponent {
  late double amplitude;
  late double frequency;
  late double time;
  late double maxY;
  late double minY;
  late double speed;
  late bool isDead;

  Balloon({
    required Vector2 position,
    required Vector2 size,
    required SpriteAnimation animation,
    required this.amplitude,
    required this.frequency,
    required this.maxY,
    required this.minY,
    required this.speed,
  }) : super(
          position: position,
          size: size,
          animation: animation,
        ) {
    isDead = false;
    time = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.x -= speed * dt;

    time += dt;
    position.y = minY + amplitude * sin(frequency * time);

    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  void kill() {
    isDead = true;
    removeFromParent();
  }

  @override
  Rect toRect() {
    return Rect.fromLTWH(position.x, position.y, size.x, size.y);
  }
}
