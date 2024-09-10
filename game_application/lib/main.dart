import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class CupheadTheGame extends FlameGame {
  late SpriteAnimationComponent cupHead;

  int spriteSheetColumns = 4;
  int spriteSheetRows = 4;
  double spriteSheetWidth = 628;
  double spriteSheetHeight = 756;

  @override
  Future<void> onLoad() async {
    try {
      final spriteSheetImage = await images.load('Cuphead.png');

      final double frameWidth = spriteSheetWidth / spriteSheetColumns;
      final double frameHeight = spriteSheetHeight / spriteSheetRows;

      final spriteSheet = SpriteSheet(
        image: spriteSheetImage,
        srcSize: Vector2(frameWidth, frameHeight),
      );

      final List<Sprite> sprites = [];

      for (int row = 0; row < spriteSheetRows; row++) {
        for (int column = 0; column < spriteSheetColumns; column++) {
          sprites.add(spriteSheet.getSprite(column, row));
        }
      }

      final combinedAnimation = SpriteAnimation.spriteList(
        sprites,
        stepTime: 0.15,
        loop: true,
      );

      cupHead = SpriteAnimationComponent()
        ..animation = combinedAnimation
        ..size = Vector2.all(100)
        ..position = Vector2(100, 100);
      add(cupHead);

      print('Sprite animated with row transitions successfully.');
    } catch (e) {
      print('Error loading or error animating sprite: $e');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Game logic update
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Game rendering
  }
}

void main() {
  var game = CupheadTheGame();
  runApp(GameWidget(game: game)); // Use GameWidget to properly load the game
}
