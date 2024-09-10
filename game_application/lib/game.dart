import 'package:Cuphead_application/TheGame/Cuphead.dart';
import 'package:Cuphead_application/TheGame/Paralax.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class CupheadGame extends FlameGame with TapDetector {
  late Cuphead _cuphead;
  late Parallax _parallax;
  @override
  Future<void> onLoad() async {
    _cuphead = Cuphead();
    _parallax = Parallax();

    add(_parallax);
    add(_cuphead);
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

  @override
  void onTapDown(TapDownInfo info) {
    _cuphead.jump();
  }
}
