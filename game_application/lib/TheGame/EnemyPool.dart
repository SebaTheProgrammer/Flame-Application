import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:Cuphead_application/TheGame/Balloon.dart';

class BalloonPool {
  final List<Balloon> _pool = [];
  final SpriteAnimation _defaultAnimation;

  BalloonPool(this._defaultAnimation);

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
