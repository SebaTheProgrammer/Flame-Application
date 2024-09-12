import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';

enum CupheadState { run, jump, shoot }

class Cuphead extends FlameGame {
  late SpriteAnimationComponent _runAnimation;
  late SpriteAnimationComponent _jumpAnimation;
  late SpriteAnimationComponent _shootAnimation;

  int startHealth = 3;
  double movementSpeed = 300;
  Vector2 position = Vector2(200, 500);
  double gravity = 1700;
  double jumpHeight = -1000;
  double frameTime = 0.06;
  double sizeCuphead = 150;
  double velocityY = 0;
  bool isJumping = false;
  bool isShooting = false; // Track if Cuphead is shooting

  int spriteSheetColumnsRun = 4;
  int spriteSheetRowsRun = 4;
  int spriteSheetColumnsJump = 3;
  int spriteSheetRowsJump = 3;
  int spriteSheetColumnsShoot = 4;
  int spriteSheetRowsShoot = 4;

  double minY = 475;
  double maxY = 800;

  CupheadState currentState = CupheadState.run;

  int getHealth() {
    return startHealth;
  }

  void setHealth(int health) {
    startHealth = health;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Handle different states
    switch (currentState) {
      case CupheadState.jump:
        velocityY += gravity * dt;
        _jumpAnimation.position.y += velocityY * dt;
        if (_jumpAnimation.position.y >= position.y) {
          _jumpAnimation.position.y = position.y;
          isJumping = false;
          velocityY = 0;
          changeState(CupheadState.run);
        }
        break;

      case CupheadState.run:
        _runAnimation.position = position;
        break;

      case CupheadState.shoot:
        _shootAnimation.position = position;
        break;
    }

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
    _runAnimation.position = position;
    _shootAnimation.position = position;

    if (!isJumping) {
      _jumpAnimation.position = position;
    } else {
      _jumpAnimation.position.x = position.x;
    }
  }

  // Manage input for movement
  void handleMovement(Set<LogicalKeyboardKey> pressedKeys, double dt) {
    final Vector2 movement = Vector2.zero();
    final double speed = movementSpeed * dt;

    if (pressedKeys.contains(LogicalKeyboardKey.keyW)) {
      if (position.y > minY) {
        movement.y -= speed;
      } else {
        jump();
      }
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyS)) {
      movement.y += speed;
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyA)) {
      movement.x -= speed;
      _runAnimation.scale.x = -1;
      _jumpAnimation.scale.x = -1;
      _shootAnimation.scale.x = -1;
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyD)) {
      movement.x += speed;
      _runAnimation.scale.x = 1;
      _jumpAnimation.scale.x = 1;
      _shootAnimation.scale.x = 1;
    }
    if (pressedKeys.contains(LogicalKeyboardKey.space)) {
      jump();
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyE)) {
      shoot();
    } else {
      if (isShooting && currentState == CupheadState.shoot) {
        isShooting = false;
        changeState(CupheadState.run);
      }
    }

    if (movement != Vector2.zero()) {
      move(movement);
    }
  }

  // Change state and update animations
  void changeState(CupheadState newState) {
    switch (currentState) {
      case CupheadState.run:
        remove(_runAnimation);
        break;
      case CupheadState.jump:
        remove(_jumpAnimation);
        break;
      case CupheadState.shoot:
        remove(_shootAnimation);
        break;
    }

    currentState = newState;

    switch (currentState) {
      case CupheadState.run:
        add(_runAnimation);
        break;
      case CupheadState.jump:
        add(_jumpAnimation);
        break;
      case CupheadState.shoot:
        add(_shootAnimation);
        break;
    }
  }

  void jump() {
    if (!isJumping) {
      isJumping = true;
      velocityY = jumpHeight;
      changeState(CupheadState.jump);
    }
  }

  void shoot() {
    if (!isJumping) {
      isShooting = true;
      changeState(CupheadState.shoot);
    }
  }

  @override
  Future<void> onLoad() async {
    // Helper function to create animations
    Future<SpriteAnimationComponent> createAnimation(
        String fileName, int rows, int columns, double size,
        {double? adjustedSize, int? totalSprites}) async {
      final spriteSheetImage = await images.load('$fileName.png');
      final frameWidth = spriteSheetImage.width / columns;
      final frameHeight = spriteSheetImage.height / rows;

      final spriteSheet = SpriteSheet(
        image: spriteSheetImage,
        srcSize: Vector2(frameWidth, frameHeight),
      );

      final List<Sprite> sprites = [];
      int spriteCount = 0;

      for (int row = 0; row < rows; row++) {
        for (int column = 0; column < columns; column++) {
          if (totalSprites != null && spriteCount >= totalSprites) break;
          sprites.add(spriteSheet.getSprite(row, column));
          spriteCount++;
        }
      }

      final animation = SpriteAnimation.spriteList(
        sprites,
        stepTime: frameTime,
        loop: true,
      );

      return SpriteAnimationComponent()
        ..animation = animation
        ..size = Vector2.all(adjustedSize ?? size)
        ..position = position
        ..anchor = Anchor.center;
    }

    _runAnimation = await createAnimation(
        'Run', spriteSheetRowsRun, spriteSheetColumnsRun, sizeCuphead);
    add(_runAnimation);

    _jumpAnimation = await createAnimation(
        'Jump', spriteSheetRowsJump, spriteSheetColumnsJump, sizeCuphead,
        adjustedSize: sizeCuphead - 20, totalSprites: 8);

    _shootAnimation = await createAnimation(
        'Shoot', spriteSheetRowsShoot, spriteSheetColumnsShoot, sizeCuphead);
  }
}
