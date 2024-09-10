import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';

class Healthcomponent extends FlameGame {
  late SpriteAnimationComponent _healthAnimation;
  double sizeHealth = 150;
  Vector2 pos = Vector2(200, 500);

  void setHealth(int index) {
    if (_healthAnimation.animation != null &&
        index >= 0 &&
        index < _healthAnimation.animation!.frames.length) {
      _healthAnimation.animation!.currentIndex = index;
    }
  }

  @override
  Future<void> onLoad() async {
    final spriteSheetImageHealth = await images.load('Health.png');

    final double frameWidth = spriteSheetImageHealth.width / 6;
    final double frameHeight = spriteSheetImageHealth.height / 2;

    final spriteSheetHealth = SpriteSheet(
      image: spriteSheetImageHealth,
      srcSize: Vector2(frameWidth, frameHeight),
    );

    final List<Sprite> sprites = [];

    for (int row = 0; row < 2; row++) {
      for (int column = 0; column < 6; column++) {
        sprites.add(spriteSheetHealth.getSprite(column, row));
      }
    }

    final combinedAnimation = SpriteAnimation.spriteList(
      sprites,
      stepTime: 0,
      loop: false,
    );

    _healthAnimation = SpriteAnimationComponent()
      ..animation = combinedAnimation
      ..size = Vector2.all(sizeHealth)
      ..position = pos;

    add(_healthAnimation);
  }
}

extension on SpriteAnimation {
  set currentIndex(int currentIndex) {}
}
