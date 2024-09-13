import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';
import 'bullet.dart';

enum CupheadState { run, jump, shoot }

class Cuphead extends FlameGame with HasGameRef {
  late SpriteAnimationComponent _runAnimation;
  late SpriteAnimationComponent _jumpAnimation;
  late SpriteAnimationComponent _shootAnimation;

  int startHealth = 3;
  double movementSpeed = 300;
  Vector2 position = Vector2(200, 500);
  static const double gravity = 1700;
  static const double jumpHeight = -1000;
  static const double frameTime = 0.06;
  static const double sizeCuphead = 150;
  double velocityY = 0;

  static const double timeBetweenShots = 0.5;
  double lastShotTime = 0;

  bool isJumping = false;
  bool isShooting = false;
  bool isLookingLeft = false;

  static const int spriteSheetColumnsRun = 4;
  static const int spriteSheetRowsRun = 4;
  static const int spriteSheetColumnsJump = 3;
  static const int spriteSheetRowsJump = 3;
  static const int spriteSheetColumnsShoot = 4;
  static const int spriteSheetRowsShoot = 4;

  static const double minY = 475;
  static const double maxY = 800;

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

  // Timewise I didn't make an inputmanager class
  void handleMovement(Set<LogicalKeyboardKey> pressedKeys, double dt) {
    final Vector2 movement = Vector2.zero();
    final double speed = movementSpeed * dt;
    final currentTime = gameRef.currentTime();

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
      isLookingLeft = true;
      _runAnimation.scale.x = -1;
      _jumpAnimation.scale.x = -1;
      _shootAnimation.scale.x = -1;
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyD)) {
      movement.x += speed;
      isLookingLeft = false;
      _runAnimation.scale.x = 1;
      _jumpAnimation.scale.x = 1;
      _shootAnimation.scale.x = 1;
    }
    if (pressedKeys.contains(LogicalKeyboardKey.space)) {
      jump();
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyE)) {
      shoot(currentTime);
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

  void shoot(double currentTime) async {
    if (!isJumping && (currentTime - lastShotTime) >= timeBetweenShots) {
      isShooting = true;
      changeState(CupheadState.shoot);

      final spriteSheet = SpriteSheet(
        image: await images.load('Bullet.png'),
        srcSize: Vector2(1188 / 8, 54),
      );

      final bulletAnimation = spriteSheet.createAnimation(
        row: 0,
        stepTime: 0.1,
        to: 8,
      );

      final bullet = Bullet(
          position: Vector2(
              position.x + (isLookingLeft ? sizeCuphead / 4 : -sizeCuphead / 4),
              position.y),
          size: Vector2(100, 50),
          animation: bulletAnimation,
          isFacingLeft: isLookingLeft);

      add(bullet);

      lastShotTime = currentTime;
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
        adjustedSize: sizeCuphead - 30, totalSprites: 8);

    _shootAnimation = await createAnimation(
        'Shoot', spriteSheetRowsShoot, spriteSheetColumnsShoot, sizeCuphead);
  }
}
