import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class HealthComponent extends PositionComponent {
  late SpriteComponent _healthSprite;
  late List<Sprite> _healthSprites;
  final double _sizeHealth = 50;
  final Vector2 _pos = Vector2(25, 25);
  final Images _images;

  HealthComponent(this._images);

  Future<void> updateHealth(int index) async {
    if (index >= 0 && index < _healthSprites.length) {
      if (index == 2) {
        _healthSprite.sprite = _healthSprites[0];
      } else {
        _healthSprite.sprite = _healthSprites[index];
      }
    }
  }

  @override
  Future<void> onLoad() async {
    final spriteSheetImageHealth = await _images.load('Health.png');
    final double frameWidth = spriteSheetImageHealth.width / 6;
    final double frameHeight = spriteSheetImageHealth.height / 2;
    final spriteSheetHealth = SpriteSheet(
      image: spriteSheetImageHealth,
      srcSize: Vector2(frameWidth, frameHeight),
    );

    _healthSprites = [];
    for (int row = 0; row < 2; row++) {
      for (int column = 0; column < 6; column++) {
        _healthSprites.add(spriteSheetHealth.getSprite(row, column));
      }
    }

    _healthSprite = SpriteComponent()
      ..sprite = _healthSprites[0]
      ..size = Vector2(_sizeHealth * 2, _sizeHealth)
      ..position = _pos
      ..paint = Paint()
      ..paint.colorFilter = const ColorFilter.mode(
        Color(0xFF808080),
        BlendMode.saturation,
      );

    add(_healthSprite);
  }
}
