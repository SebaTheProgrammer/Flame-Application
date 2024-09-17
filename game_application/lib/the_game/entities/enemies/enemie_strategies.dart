import 'dart:ui';
import 'package:Cuphead_application/the_game/entities/enemies/balloon.dart';
import 'package:Cuphead_application/the_game/extra/sound_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';

abstract class DeathStrategy {
  void execute(Balloon balloon);
}

class ScoreDeathStrategy implements DeathStrategy {
  @override
  void execute(Balloon balloon) {
    balloon.scoreComponent.addscore(balloon.scoreWorth);
  }
}

class SoundDeathStrategy implements DeathStrategy {
  @override
  void execute(Balloon balloon) {
    SoundManager.instance.playSoundEffect('BalloonDeath.wav');
  }
}

class ParticleDeathStrategy implements DeathStrategy {
  @override
  void execute(Balloon balloon) {
    final paint = Paint()..color = const Color(0xFFFF0000);

    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 25,
        lifespan: 1.0,
        generator: (i) {
          final initialPosition = Vector2(75, 75);
          final speed = (Vector2.random() - Vector2.all(0.5)) * 100;

          return ComputedParticle(
            lifespan: 1.0,
            renderer: (canvas, particleLifespan) {
              final position =
                  initialPosition + speed * particleLifespan.progress;

              canvas.drawCircle(Offset(position.x, position.y), 15, paint);
            },
          );
        },
      ),
    );

    balloon.add(particleComponent);
  }
}
