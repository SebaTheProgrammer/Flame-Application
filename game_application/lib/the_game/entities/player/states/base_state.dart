import 'package:Cuphead_application/the_game/entities/player/cuphead.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

abstract class CupheadState {
  bool hasEntered = false;
  late SpriteAnimationComponent animation;

  void enter(Cuphead cuphead);
  void exit(Cuphead cuphead);
  void loadAnimations(Cuphead cuphead);
  void handleInput(Cuphead cuphead, Set<LogicalKeyboardKey> pressedKeys);
  void update(Cuphead cuphead, double dt);
  Rect toRect() {
    return animation.toRect();
  }
}
