import 'package:Cuphead_application/the_game/entities/player/states/base_state.dart';
import 'package:Cuphead_application/the_game/entities/player/states/jump_state.dart';
import 'package:Cuphead_application/the_game/entities/player/states/run_state.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

class Cuphead extends FlameGame with HasGameRef {
  final int startHealth = 3;
  int health = 3;
  final double movementSpeed = 300;
  final double movementSpeedLeft = 500;
  final Vector2 startPosition = Vector2(200, 500);
  Vector2 position = Vector2.zero();
  final double gravity = 1700;
  final double jumpHeight = -1000;
  static const double frameTime = 0.06;
  static const double sizeCuphead = 150;
  double velocityY = 0;

  bool isJumping = false;
  bool isLookingLeft = false;

  static const double minY = 475;
  static const double maxY = 800;

  CupheadState currentState = RunState();

  int getHealth() => health;
  double getSize() => sizeCuphead;

  void setHealth(int newHealth) {
    health = newHealth;
  }

  @override
  void update(double dt) {
    super.update(dt);
    currentState.update(this, dt);

    if (position.y < minY) {
      position.y = minY;
    }
    if (position.y > maxY) {
      position.y = maxY;
    }
    if (position.x < 0) {
      position.x = 0;
    }
    if (position.x > size.x) {
      position.x = size.x;
    }
  }

  void move(Vector2 delta) {
    position += delta;
  }

  void handleMovement(Set<LogicalKeyboardKey> pressedKeys, double dt) {
    currentState.handleInput(this, pressedKeys);

    final Vector2 movement = Vector2.zero();
    final double speed = movementSpeed * dt;

    //all states are using the same movement
    if (pressedKeys.contains(LogicalKeyboardKey.keyW)) {
      if (position.y > minY) {
        movement.y -= speed;
      }
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyS)) {
      movement.y += speed;
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyA)) {
      final double leftSpeed = movementSpeedLeft * dt;
      movement.x -= leftSpeed;
      isLookingLeft = true;
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyD)) {
      movement.x += speed;
      isLookingLeft = false;
    }
    if (movement != Vector2.zero()) {
      move(movement);
    }
  }

  void changeState(CupheadState newState) {
    currentState.exit(this);
    currentState = newState;
    currentState.enter(this);
  }

  Rect toRect() {
    if (!isJumping) {
      return Rect.fromLTWH(position.x, position.y, 20, 40);
    } else {
      return Rect.fromLTWH(
          currentState.toRect().left, currentState.toRect().bottom, 20, 40);
    }
  }

  void resetCuphead() {
    position = startPosition;
    health = startHealth;

    changeState(RunState());
    isLookingLeft = false;
    isJumping = false;
  }

  @override
  Future<void> onLoad() async {
    position = startPosition;

    changeState(RunState());
  }
}
