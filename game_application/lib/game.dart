import 'package:Cuphead_application/TheGame/Cuphead.dart';
import 'package:Cuphead_application/TheGame/HealthComponent.dart';
import 'package:Cuphead_application/TheGame/Paralax.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class CupheadGame extends FlameGame with TapDetector {
  late Cuphead _cuphead;
  late ParallaxBackground _parallax;
  late ParallaxForeground _parallaxForeground;
  late HealthComponent _healthComponent;

  @override
  Future<void> onLoad() async {
    _cuphead = Cuphead();
    _parallax = ParallaxBackground();
    _parallaxForeground = ParallaxForeground();
    _healthComponent = HealthComponent(images);
    add(_parallax);
    add(_cuphead);
    add(_parallaxForeground);
    add(_healthComponent);

    await _healthComponent.onLoad();
    _healthComponent
        .updateHealth(_cuphead.getHealth() + 2); //+2 for spritesheet
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
