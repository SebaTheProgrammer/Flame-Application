import 'package:Cuphead_application/TheGame/HealthComponent.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class Cuphead extends FlameGame {
  Healthcomponent healthcomponent = Healthcomponent();

  late SpriteAnimationComponent _runAnimation;
  late SpriteAnimationComponent _jumpAnimation;
  late Healthcomponent _healthComponent;

  int startHealth = 3;
  double frameTime = 0.06;
  Vector2 startPos = Vector2(200, 500);
  double sizeCuphead = 150;
  double gravity = 1000;
  double jumpHeight = -750;
  double velocityY = 0;
  bool isJumping = false;

  int spriteSheetColumnsRun = 4;
  int spriteSheetRowsRun = 4;

  int spriteSheetColumnsJump = 3;
  int spriteSheetRowsJump = 3;

  @override
  void update(double dt) {
    super.update(dt);

    if (isJumping) {
      velocityY += gravity * dt;
      _jumpAnimation.position.y += velocityY * dt;
      if (_jumpAnimation.position.y >= startPos.y) {
        _jumpAnimation.position.y = startPos.y;
        isJumping = false;
        velocityY = 0;
        remove(_jumpAnimation);
        add(_runAnimation);
      }
    }
  }

  void jump() {
    if (!isJumping) {
      remove(_runAnimation);
      add(_jumpAnimation);
      velocityY = jumpHeight;
      isJumping = true;
    }
  }

  @override
  Future<void> onLoad() async {
    _healthComponent = Healthcomponent();
    add(_healthComponent);
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
      ..position = startPos;

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
      ..position = startPos;
  }
}
