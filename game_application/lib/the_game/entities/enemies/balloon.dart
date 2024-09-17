import 'dart:math';
import 'package:Cuphead_application/the_game/components/score_component.dart';
import 'package:Cuphead_application/the_game/entities/enemies/enemy_strategies.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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

  final int _flyHeight = 200;
  final double _flyTime = 1;

  late ScoreComponent _scoreComponent;
  late List<DeathStrategy> deathStrategies;

  Balloon({
    required ScoreComponent scoreComponent,
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
    this.deathStrategies = const [],
  }) : super(
          position: position,
          size: size,
          animation: animation,
        ) {
    _scoreComponent = scoreComponent;
    isDead = false;
    time = 0;
    _health = hp;
    _damageDealt = damage;
    _scoreWorth = score;
  }

  int get damageDealt => _damageDealt;
  int get scoreWorth => _scoreWorth;
  int get health => _health;

  ScoreComponent get scoreComponent => _scoreComponent;

  @override
  void update(double dt) {
    super.update(dt);

    position.x -= speed * dt;

    if (isDead) {
      return;
    }

    time += dt;

    //custom spatial transformation with matrices
    final Matrix4 transformationMatrix = Matrix4.identity()
      ..translate(0, amplitude * sin(frequency * time), 0);

    position.y = minY + transformationMatrix.getTranslation().y;

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
    if (isDead) {
      return;
    }
    isDead = true;

    for (final strategy in deathStrategies) {
      strategy.execute(this);
    }

    final moveEffect = MoveToEffect(
      Vector2(position.x, position.y - _flyHeight),
      EffectController(duration: _flyTime),
    );
    add(moveEffect);

    Future.delayed(Duration(seconds: _flyTime.toInt()), () {
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
