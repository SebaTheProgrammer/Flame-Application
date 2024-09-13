import 'package:Cuphead_application/TheGame/Balloon.dart';
import 'package:Cuphead_application/TheGame/Bullet.dart';
import 'package:Cuphead_application/TheGame/Cuphead.dart';
import 'package:Cuphead_application/TheGame/HealthComponent.dart';
import 'package:Cuphead_application/TheGame/Paralax.dart';
import 'package:Cuphead_application/TheGame/EnemySpawner.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/input.dart';

class CupheadGame extends FlameGame with KeyboardEvents {
  late Cuphead _cuphead;
  late ParallaxBackground _parallax;
  late ParallaxForeground _parallaxForeground;
  late HealthComponent _healthComponent;
  late EnemySpawner _enemySpawner;

  final Set<LogicalKeyboardKey> _pressedKeys = {};
  bool isGamePaused = false;

  @override
  Future<void> onLoad() async {
    _cuphead = Cuphead();
    _parallax = ParallaxBackground();
    _parallaxForeground = ParallaxForeground();
    _healthComponent = HealthComponent(images);

    _enemySpawner = EnemySpawner(screenSize: size, images: images);

    add(_parallax);
    add(_cuphead);
    add(_enemySpawner);
    add(_parallaxForeground);
    add(_healthComponent);

    await _healthComponent.onLoad();
    _healthComponent
        .updateHealth(_cuphead.getHealth() + 2); //+2 for spritesheet
  }

  @override
  void update(double dt) {
    if (isGamePaused) return;

    super.update(dt);
    _cuphead.handleMovement(_pressedKeys, dt);
    checkCollisions();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    if (isGamePaused) return KeyEventResult.handled;

    super.onKeyEvent(event, keys);
    if (event is KeyDownEvent) {
      _pressedKeys.add(event.logicalKey);
    } else if (event is KeyUpEvent) {
      _pressedKeys.remove(event.logicalKey);
    }
    return KeyEventResult.handled;
  }

  void checkCollisions() {
    final cupheadRect = _cuphead.toRect();
    final balloons = _enemySpawner.children.whereType<Balloon>().toList();

    for (final balloon in balloons) {
      final balloonRect = balloon.toRect();

      if (cupheadRect.overlaps(balloonRect)) {
        _cuphead
            .setHealth(_cuphead.getHealth() - 1); //or getDamage() from enemy
        _healthComponent
            .updateHealth(_cuphead.getHealth() + 2); //+2 for spritesheet
        balloon.kill();

        if (_cuphead.getHealth() == 0) {
          pauseGame();
        }
      }

      for (final bullet in _cuphead.children.whereType<Bullet>()) {
        final bulletRect = bullet.toRect();

        if (bulletRect.overlaps(balloonRect)) {
          bullet.removeFromParent();
          balloon.kill();
        }
      }
    }
  }

  void pauseGame() {
    isGamePaused = true;
    overlays.add('RestartButton');
    pauseEngine();
  }

  void restartGame() {
    for (final component in _enemySpawner.children.toList()) {
      if (component is Balloon) {
        component.removeFromParent();
      }
    }

    _cuphead.resetCuphead();
    _healthComponent
        .updateHealth(_cuphead.getHealth() + 2); //+2 for spritesheet

    _pressedKeys.clear();

    isGamePaused = false;
    overlays.remove('RestartButton');
    resumeEngine();
  }
}
