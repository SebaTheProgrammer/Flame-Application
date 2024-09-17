import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

Future<SpriteAnimationComponent> createAnimation(Images images,
    Vector2 position, String fileName, int rows, int columns, double size,
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
    stepTime: 0.05,
    loop: true,
  );

  return SpriteAnimationComponent()
    ..animation = animation
    ..size = Vector2.all(adjustedSize ?? size)
    ..position = position
    ..anchor = Anchor.center;
}
