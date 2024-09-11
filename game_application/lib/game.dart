import 'package:Cuphead_application/TheGame/Cuphead.dart';
import 'package:Cuphead_application/TheGame/HealthComponent.dart';
import 'package:Cuphead_application/TheGame/Paralax.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/input.dart';

class CupheadGame extends FlameGame with KeyboardEvents {
  late Cuphead _cuphead;
  late ParallaxBackground _parallax;
  late ParallaxForeground _parallaxForeground;
  late HealthComponent _healthComponent;

  final Set<LogicalKeyboardKey> _pressedKeys = {};

  @override
  Future<void> onLoad() async {
    _cuphead = Cuphead();
    _parallax = ParallaxBackground();
    _parallaxForeground = ParallaxForeground();
    _healthComponent = HealthComponent(images);
    add(_parallax);
    add(_cuphead);
    add(_parallaxForeground);
    add(_healthComponent);

    await _healthComponent.onLoad();
    _healthComponent
        .updateHealth(_cuphead.getHealth() + 2); //+2 for spritesheet
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Game logic update
    handleMovement(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Game rendering
  }

  void handleMovement(double dt) {
    double movementSpeed = 200 * dt;

    final Vector2 movement = Vector2.zero();

    if (_pressedKeys.contains(LogicalKeyboardKey.keyW)) {
      movement.y -= movementSpeed;
    }
    if (_pressedKeys.contains(LogicalKeyboardKey.keyS)) {
      movement.y += movementSpeed;
    }
    if (_pressedKeys.contains(LogicalKeyboardKey.keyA)) {
      movement.x -= movementSpeed;
    }
    if (_pressedKeys.contains(LogicalKeyboardKey.keyD)) {
      movement.x += movementSpeed;
    }
    if (_pressedKeys.contains(LogicalKeyboardKey.space)) {
      _cuphead.jump();
    }

    if (movement != Vector2.zero()) {
      _cuphead.move(movement);
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    super.onKeyEvent(event, keys);
    if (event is KeyDownEvent) {
      _pressedKeys.add(event.logicalKey);
    } else if (event is KeyUpEvent) {
      _pressedKeys.remove(event.logicalKey);
    }
    return KeyEventResult.handled;
  }
}
