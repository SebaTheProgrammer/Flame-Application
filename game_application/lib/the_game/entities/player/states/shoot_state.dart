import 'package:Cuphead_application/the_game/entities/bullet.dart';
import 'package:Cuphead_application/the_game/entities/player/cuphead.dart';
import 'package:Cuphead_application/the_game/entities/player/states/base_state.dart';
import 'package:Cuphead_application/the_game/entities/player/states/run_state.dart';
import 'package:Cuphead_application/the_game/extra/helper_functions.dart';
import 'package:Cuphead_application/the_game/extra/sound_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';

class ShootState extends CupheadState {
  static const double timeBetweenShots = 0.5;
  double lastShotTime = 0;
  final List<Bullet> bulletPool = [];
  final int initialPoolSize = 10;
  bool isBulletPoolInitialized = false;

  @override
  Future<void> enter(Cuphead cuphead) async {
    if (!hasEntered) {
      await loadAnimations(cuphead);
      hasEntered = true;
    }

    cuphead.add(animation);

    lastShotTime = 0;

    if (!isBulletPoolInitialized) {
      await initializeBulletPool(cuphead);
      isBulletPoolInitialized = true;
    }
  }

  @override
  void exit(Cuphead cuphead) {
    if (hasEntered) {
      animation.removeFromParent();
    }
  }

  @override
  Future<void> loadAnimations(Cuphead cuphead) async {
    animation = await createAnimation(
        cuphead.images, cuphead.position, 'Shoot', 4, 4, cuphead.getSize());
  }

  @override
  void handleInput(Cuphead cuphead, Set<LogicalKeyboardKey> pressedKeys) {
    if (!pressedKeys.contains(LogicalKeyboardKey.keyE)) {
      cuphead.changeState(RunState());
    }
  }

  @override
  void update(Cuphead cuphead, double dt) {
    if (hasEntered) {
      animation.position = cuphead.position;
      double currentTime = cuphead.gameRef.currentTime();

      if ((currentTime - lastShotTime) >= timeBetweenShots) {
        if (isBulletPoolInitialized) {
          shoot(cuphead, currentTime);
        }
      }

      if (cuphead.isLookingLeft) {
        animation.scale.x = -1;
      } else {
        animation.scale.x = 1;
      }
    }
  }

  void shoot(Cuphead cuphead, double currentTime) {
    if (!hasEntered) {
      return;
    }
    if (!cuphead.isJumping) {
      SoundManager.instance.playSoundEffect('Fire.wav');

      final bulletPosition = Vector2(
        cuphead.position.x +
            (cuphead.isLookingLeft
                ? -Cuphead.sizeCuphead / 4
                : Cuphead.sizeCuphead / 4),
        cuphead.position.y,
      );

      Bullet bullet = getBullet(cuphead, bulletPosition, cuphead.isLookingLeft);
      bullet.scale.x = cuphead.isLookingLeft ? -1 : 1;

      lastShotTime = currentTime;
    }
  }

  Bullet getBullet(Cuphead cuphead, Vector2 position, bool isFacingLeft) {
    Bullet bullet;
    if (bulletPool.isNotEmpty) {
      bullet = bulletPool.removeLast();
    } else {
      final spriteSheet = SpriteSheet(
        image: cuphead.images.fromCache('Bullet.png'),
        srcSize: Vector2(1188 / 8, 54),
      );
      final bulletAnimation =
          spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 8);
      bullet = Bullet(
        position: position,
        size: Vector2(100, 50),
        animation: bulletAnimation,
        isFacingLeft: isFacingLeft,
      );
    }

    bullet.position = position;
    bullet.isFacingLeft = isFacingLeft;
    bullet.addToParent(cuphead);

    bullet.scale.x = isFacingLeft ? -1 : 1;

    return bullet;
  }

  Future<void> initializeBulletPool(Cuphead cuphead) async {
    bulletPool.clear();
    final spriteSheet = SpriteSheet(
      image: await cuphead.images.load('Bullet.png'),
      srcSize: Vector2(1188 / 8, 54),
    );
    final bulletAnimation = spriteSheet.createAnimation(
      row: 0,
      stepTime: 0.1,
      to: 8,
    );

    for (int i = 0; i < initialPoolSize; i++) {
      bulletPool.add(Bullet(
        position: Vector2.zero(),
        size: Vector2(100, 50),
        animation: bulletAnimation,
        isFacingLeft: false,
      ));
    }
  }
}
