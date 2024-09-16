import 'package:Cuphead_application/the_game/entities/bullet.dart';
import 'package:Cuphead_application/the_game/extra/sound_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';

enum CupheadState { run, jump, shoot }

class Cuphead extends FlameGame with HasGameRef {
  late SpriteAnimationComponent _runAnimation;
  late SpriteAnimationComponent _jumpAnimation;
  late SpriteAnimationComponent _shootAnimation;

  final int _startHealth = 3;
  int _health = 3;
  final double _movementSpeed = 300;
  final double _movementSpeedLeft = 500;
  final Vector2 _startPosition = Vector2(200, 500);
  Vector2 _position = Vector2.zero();
  static const double _gravity = 1700;
  static const double _jumpHeight = -1000;
  static const double _frameTime = 0.06;
  static const double _sizeCuphead = 150;
  double _velocityY = 0;

  static const double _timeBetweenShots = 0.5;
  double _lastShotTime = 0;

  bool _isJumping = false;
  bool _isShooting = false;
  bool _isLookingLeft = false;

  static const int _spriteSheetColumnsRun = 4;
  static const int _spriteSheetRowsRun = 4;
  static const int _spriteSheetColumnsJump = 3;
  static const int _spriteSheetRowsJump = 3;
  static const int _spriteSheetColumnsShoot = 4;
  static const int _spriteSheetRowsShoot = 4;

  static const double _minY = 475;
  static const double _maxY = 800;

  final List<Bullet> _bulletPool = [];
  final int _initialPoolSize = 10;

  CupheadState _currentState = CupheadState.run;

  int getHealth() {
    return _health;
  }

  void setHealth(int newhealth) {
    _health = newhealth;
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (var bullet in children.whereType<Bullet>()) {
      if (bullet.isOffScreen) {
        _returnBulletToPool(bullet);
      }
    }

    // Handle different states
    switch (_currentState) {
      case CupheadState.jump:
        _velocityY += _gravity * dt;
        _jumpAnimation.position.y += _velocityY * dt;
        if (_jumpAnimation.position.y >= _position.y) {
          _jumpAnimation.position.y = _position.y;
          _isJumping = false;
          _velocityY = 0;
          _changeState(CupheadState.run);
        }
        break;

      case CupheadState.run:
        _runAnimation.position = _position;
        break;

      case CupheadState.shoot:
        _shootAnimation.position = _position;
        break;
    }

    if (_position.y < _minY) {
      _position.y = _minY;
    }
    if (_position.y > _maxY) {
      _position.y = _maxY;
    }
    if (_position.x < 0) {
      _position.x = 0;
    }
    if (_position.x > size.x) {
      _position.x = size.x;
    }
  }

  void _move(Vector2 delta) {
    _position += delta;
    _runAnimation.position = _position;
    _shootAnimation.position = _position;

    if (!_isJumping) {
      _jumpAnimation.position = _position;
    } else {
      _jumpAnimation.position.x = _position.x;
    }
  }

  // Timewise I didn't make an inputmanager class
  void handleMovement(Set<LogicalKeyboardKey> pressedKeys, double dt) {
    final Vector2 movement = Vector2.zero();
    final double speed = _movementSpeed * dt;
    final currentTime = gameRef.currentTime();

    if (pressedKeys.contains(LogicalKeyboardKey.keyW)) {
      if (_position.y > _minY) {
        movement.y -= speed;
      } else {
        _jump();
      }
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyS)) {
      movement.y += speed;
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyA)) {
      // design wise: to the left faster, so with the paralax you can see the character moving
      final double leftSpeed = _movementSpeedLeft * dt;
      movement.x -= leftSpeed;
      _isLookingLeft = true;
      _runAnimation.scale.x = -1;
      _jumpAnimation.scale.x = -1;
      _shootAnimation.scale.x = -1;
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyD)) {
      movement.x += speed;
      _isLookingLeft = false;
      _runAnimation.scale.x = 1;
      _jumpAnimation.scale.x = 1;
      _shootAnimation.scale.x = 1;
    }
    if (pressedKeys.contains(LogicalKeyboardKey.space)) {
      _jump();
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyE)) {
      _shoot(currentTime);
    } else {
      if (_isShooting && _currentState == CupheadState.shoot) {
        _isShooting = false;
        _changeState(CupheadState.run);
      }
    }

    if (movement != Vector2.zero()) {
      _move(movement);
    }
  }

  // Change state and update animations
  void _changeState(CupheadState newState) {
    switch (_currentState) {
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

    _currentState = newState;

    switch (_currentState) {
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

  void _jump() {
    if (!_isJumping) {
      _isJumping = true;
      _velocityY = _jumpHeight;
      _changeState(CupheadState.jump);
    }
  }

  Bullet _getBullet(Vector2 position, bool isFacingLeft) {
    Bullet bullet;
    if (_bulletPool.isNotEmpty) {
      bullet = _bulletPool.removeLast();
    } else {
      final spriteSheet = SpriteSheet(
        image: images.fromCache('Bullet.png'),
        srcSize: Vector2(1188 / 8, 54),
      );

      final bulletAnimation = spriteSheet.createAnimation(
        row: 0,
        stepTime: 0.1,
        to: 8,
      );

      bullet = Bullet(
        position: position,
        size: Vector2(100, 50),
        animation: bulletAnimation,
        isFacingLeft: isFacingLeft,
      );
    }

    bullet.position = position;
    bullet.isFacingLeft = isFacingLeft;
    bullet.addToParent(this);
    return bullet;
  }

  void _shoot(double currentTime) {
    if (!_isJumping && (currentTime - _lastShotTime) >= _timeBetweenShots) {
      _isShooting = true;

      SoundManager.instance.playSoundEffect('Fire.wav');
      _changeState(CupheadState.shoot);

      final bulletPosition = Vector2(
        _position.x + (_isLookingLeft ? -_sizeCuphead / 4 : _sizeCuphead / 4),
        _position.y,
      );

      _getBullet(bulletPosition, _isLookingLeft);
      _lastShotTime = currentTime;
    }
  }

  void _returnBulletToPool(Bullet bullet) {
    bullet.removeFromParent();
    _bulletPool.add(bullet);
  }

  Rect toRect() {
    if (!_isJumping) {
      return Rect.fromLTWH(_position.x, _position.y, 20, 40);
    } else {
      return Rect.fromLTWH(
          _jumpAnimation.position.x, _jumpAnimation.position.y, 20, 40);
    }
  }

  void resetCuphead() {
    _position = _startPosition;
    _health = _startHealth;
    _runAnimation.position = _position;
    _jumpAnimation.position = _position;
    _shootAnimation.position = _position;
    _changeState(CupheadState.run);
    _isLookingLeft = false;
    _isJumping = false;
  }

  @override
  Future<void> onLoad() async {
    _position = _startPosition;
    _initializeBulletPool();
    // Helper function to create animations
    Future<SpriteAnimationComponent> _createAnimation(
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
        stepTime: _frameTime,
        loop: true,
      );

      return SpriteAnimationComponent()
        ..animation = animation
        ..size = Vector2.all(adjustedSize ?? size)
        ..position = _position
        ..anchor = Anchor.center;
    }

    _runAnimation = await _createAnimation(
        'Run', _spriteSheetRowsRun, _spriteSheetColumnsRun, _sizeCuphead);
    add(_runAnimation);

    _jumpAnimation = await _createAnimation(
        'Jump', _spriteSheetRowsJump, _spriteSheetColumnsJump, _sizeCuphead,
        adjustedSize: _sizeCuphead - 30, totalSprites: 8);

    _shootAnimation = await _createAnimation(
        'Shoot', _spriteSheetRowsShoot, _spriteSheetColumnsShoot, _sizeCuphead);
  }

  void _initializeBulletPool() async {
    for (int i = 0; i < _initialPoolSize; i++) {
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
        position: Vector2.zero(),
        size: Vector2(100, 50),
        animation: bulletAnimation,
        isFacingLeft: false,
      );

      bullet.removeFromParent();
      _bulletPool.add(bullet);
    }
  }
}
