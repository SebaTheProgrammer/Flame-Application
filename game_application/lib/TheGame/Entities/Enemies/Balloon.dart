import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class Balloon extends SpriteAnimationComponent {
  late double amplitude;
  late double frequency;
  late double time;
  late double maxY;
  late double minY;
  late double speed;
  late bool isDead;

  late int _health;
  late int _damageDealt;
  late int _scoreWorth;

  Balloon({
    required int hp,
    required int damage,
    required int score,
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
    _health = hp;
    _damageDealt = damage;
    _scoreWorth = score;
  }

  int get damageDealt => _damageDealt;
  int get scoreWorth => _scoreWorth;
  int get health => _health;

  @override
  void update(double dt) {
    super.update(dt);

    position.x -= speed * dt;

    if (isDead) {
      return;
    }

    time += dt;
    position.y = minY + amplitude * sin(frequency * time);

    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  void hit() {
    _health -= 1;
    if (_health == 0) {
      die();
    }
  }

  void playerHit() {
    die();
  }

  void die() {
    isDead = true;

    final paint = Paint()..color = Color(0xFFFF0000);

    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 25,
        lifespan: 1.0,
        generator: (i) {
          final initialPosition = Vector2(75, 75);
          final speed = (Vector2.random() - Vector2.all(0.5)) * 100;

          return ComputedParticle(
            lifespan: 1.0,
            renderer: (canvas, particleLifespan) {
              final position =
                  initialPosition + speed * particleLifespan.progress;

              canvas.drawCircle(Offset(position.x, position.y), 15, paint);
            },
          );
        },
      ),
    );

    add(particleComponent);

    Future.delayed(Duration(seconds: 1), () {
      removeFromParent();
    });
  }

  @override
  Rect toRect() {
    if (isDead) {
      return Rect.zero;
    }
    return Rect.fromLTWH(position.x, position.y, size.x, size.y);
  }
}
