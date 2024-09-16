import 'package:Cuphead_application/the_game/components/score_component.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:Cuphead_application/the_game/entities/enemies/balloon.dart';

class BalloonPool {
  final List<Balloon> _pool = [];
  final SpriteAnimation _defaultAnimation;
  final ScoreComponent _scoreComponent;

  BalloonPool(this._defaultAnimation, this._scoreComponent);

  Balloon acquire() {
    if (_pool.isEmpty) {
      return _createBalloon();
    } else {
      final balloon = _pool.removeLast();
      balloon.animation = _defaultAnimation;
      return balloon;
    }
  }

  void release(Balloon balloon) {
    _pool.add(balloon);
  }

  Balloon _createBalloon() {
    return Balloon(
      scoreComponent: _scoreComponent,
      hp: 5,
      damage: 1,
      score: 100,
      position: Vector2.zero(),
      size: Vector2(200, 200),
      animation: _defaultAnimation,
      amplitude: 0,
      frequency: 0,
      maxY: 0,
      minY: 0,
      speed: 0,
    );
  }
}
