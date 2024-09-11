import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class HealthComponent extends PositionComponent {
  late SpriteComponent _healthSprite;
  late List<Sprite> healthSprites;
  double sizeHealth = 100;
  Vector2 pos = Vector2(0, 0);
  final Images images;

  HealthComponent(this.images);

  Future<void> updateHealth(int index) async {
    if (index >= 0 && index < healthSprites.length) {
      _healthSprite.sprite = healthSprites[index];
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

    healthSprites = [];
    for (int row = 0; row < 2; row++) {
      for (int column = 0; column < 6; column++) {
        healthSprites.add(spriteSheetHealth.getSprite(row, column));
      }
    }

    _healthSprite = SpriteComponent()
      ..sprite = healthSprites[0]
      ..size = Vector2.all(sizeHealth)
      ..position = pos;

    add(_healthSprite);
  }
}
