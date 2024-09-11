import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class Cuphead extends FlameGame {
  late SpriteAnimationComponent _runAnimation;
  late SpriteAnimationComponent _jumpAnimation;

  int startHealth = 3;
  double frameTime = 0.06;
  Vector2 position = Vector2(200, 500);
  double sizeCuphead = 150;
  double gravity = 1700;
  double jumpHeight = -1000;
  double velocityY = 0;
  bool isJumping = false;

  int spriteSheetColumnsRun = 4;
  int spriteSheetRowsRun = 4;

  int spriteSheetColumnsJump = 3;
  int spriteSheetRowsJump = 3;

  int getHealth() {
    return startHealth;
  }

  void setHealth(int health) {
    startHealth = health;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isJumping) {
      velocityY += gravity * dt;
      _jumpAnimation.position.y += velocityY * dt;
      if (_jumpAnimation.position.y >= position.y) {
        _jumpAnimation.position.y = position.y;
        isJumping = false;
        velocityY = 0;
        remove(_jumpAnimation);
        add(_runAnimation);
      }
    }
  }

  void move(Vector2 delta) {
    position += delta;
    _runAnimation.position = position;
    _jumpAnimation.position.x = position.x;
  }

  void jump() {
    if (!isJumping) {
      remove(_runAnimation);
      add(_jumpAnimation);
      velocityY = jumpHeight;
      isJumping = true;
      _jumpAnimation.position = position;
    }
  }

  @override
  Future<void> onLoad() async {
    // RUN ANIMATION
    final spriteSheetImageRun = await images.load('Run.png');

    final double frameWidthRun =
        spriteSheetImageRun.width / spriteSheetColumnsRun;
    final double frameHeightRun =
        spriteSheetImageRun.height / spriteSheetRowsRun;

    final spriteSheetRun = SpriteSheet(
      image: spriteSheetImageRun,
      srcSize: Vector2(frameWidthRun, frameHeightRun),
    );

    final List<Sprite> spritesRun = [];

    for (int row = 0; row < spriteSheetRowsRun; row++) {
      for (int column = 0; column < spriteSheetColumnsRun; column++) {
        spritesRun.add(spriteSheetRun.getSprite(row, column));
      }
    }

    final combinedAnimationRun = SpriteAnimation.spriteList(
      spritesRun,
      stepTime: frameTime,
      loop: true,
    );

    _runAnimation = SpriteAnimationComponent()
      ..animation = combinedAnimationRun
      ..size = Vector2.all(sizeCuphead)
      ..position = position;

    add(_runAnimation);

    // JUMP ANIMATION
    final spriteSheetImageJump = await images.load('Jump.png');

    final double frameWidthJump =
        spriteSheetImageJump.width / spriteSheetColumnsJump;
    final double frameHeightJump =
        spriteSheetImageJump.height / spriteSheetRowsJump;

    final spriteSheetJump = SpriteSheet(
      image: spriteSheetImageJump,
      srcSize: Vector2(frameWidthJump, frameHeightJump),
    );

    final List<Sprite> spritesJump = [];

    for (int row = 0; row < spriteSheetRowsJump; row++) {
      for (int column = 0; column < spriteSheetColumnsJump - 1; column++) {
        spritesJump.add(spriteSheetJump.getSprite(row, column));
      }
    }

    final combinedAnimationJump = SpriteAnimation.spriteList(
      spritesJump,
      stepTime: frameTime,
      loop: true,
    );

    _jumpAnimation = SpriteAnimationComponent()
      ..animation = combinedAnimationJump
      ..size = Vector2.all(sizeCuphead - 20)
      ..position = position;
  }
}
