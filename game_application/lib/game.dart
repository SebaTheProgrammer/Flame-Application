import 'package:Cuphead_application/bloc/game_bloc.dart';
import 'package:Cuphead_application/the_game/components/health_component.dart';
import 'package:Cuphead_application/the_game/components/score_component.dart';
import 'package:Cuphead_application/the_game/entities/bullet.dart';
import 'package:Cuphead_application/the_game/entities/player/cuphead.dart';
import 'package:Cuphead_application/the_game/entities/enemies/balloon.dart';
import 'package:Cuphead_application/the_game/entities/enemies/enemy_spawner.dart';
import 'package:Cuphead_application/the_game/extra/paralax.dart';
import 'package:Cuphead_application/the_game/extra/sound_manager.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CupheadGame extends FlameGame with KeyboardEvents {
  late Cuphead _cuphead;
  late ParallaxBackground _parallax;
  late ParallaxForeground _parallaxForeground;
  late HealthComponent _healthComponent;
  late EnemySpawner _enemySpawner;
  late ScoreComponent scoreComponent;

  final double _scoreToWin = 2000;
  final BuildContext context;

  bool isGamePaused = false;

  final Set<LogicalKeyboardKey> _pressedKeys = {};
  double time = 0;
  bool test = true;

  CupheadGame({required this.context});

  @override
  Future<void> onLoad() async {
    await SoundManager.instance.initialize();

    _cuphead = Cuphead();
    _parallax = ParallaxBackground();
    _parallaxForeground = ParallaxForeground();
    _healthComponent = HealthComponent(images);
    scoreComponent = ScoreComponent()..position = Vector2(size.x / 2, 10);
    _enemySpawner = EnemySpawner(
        scoreComponent: scoreComponent, screenSize: size, images: images);

    add(_parallax);
    add(_cuphead);
    add(_enemySpawner);
    add(_parallaxForeground);
    add(_healthComponent);
    add(scoreComponent);

    await _healthComponent.onLoad();
    _healthComponent
        .updateHealth(_cuphead.getHealth() + 2); //+2 for spritesheet
  }

  @override
  void update(double dt) {
    final gameBloc = BlocProvider.of<GameBloc>(context);

    if (gameBloc.state is GamePaused) return;

    time += dt;

    super.update(dt);
    _cuphead.handleMovement(_pressedKeys, dt);
    checkCollisions();
    checkScore();

    //because of the large sound file, it will only play after 10 seconds, playing when done loading doesn't work ://
    if (time > 10 && test) {
      test = false;
      SoundManager.instance.playBackgroundMusic('Level.mp3', true);
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    final gameBloc = BlocProvider.of<GameBloc>(context);

    if (gameBloc.state is GamePaused) return KeyEventResult.handled;

    super.onKeyEvent(event, keys);
    if (event is KeyDownEvent) {
      _pressedKeys.add(event.logicalKey);
    } else if (event is KeyUpEvent) {
      _pressedKeys.remove(event.logicalKey);
    }
    return KeyEventResult.handled;
  }

  void checkCollisions() {
    final cupheadRect = _cuphead.toRect();
    final balloons = _enemySpawner.children.whereType<Balloon>().toList();

    for (final balloon in balloons) {
      final balloonRect = balloon.toRect();

      if (cupheadRect.overlaps(balloonRect)) {
        _cuphead.setHealth(_cuphead.getHealth() - balloon.damageDealt);
        _healthComponent
            .updateHealth(_cuphead.getHealth() + 2); //+2 for spritesheet
        balloon.playerHit();

        if (_cuphead.getHealth() == 0) {
          pauseGame();
          overlays.add('RestartButton');
        }
      }

      for (final bullet in _cuphead.children.whereType<Bullet>()) {
        final bulletRect = bullet.toRect();

        if (bulletRect.overlaps(balloonRect)) {
          bullet.removeFromParent();
          balloon.hit();
        }
      }
    }
  }

  void checkScore() {
    if (scoreComponent.score >= _scoreToWin) {
      pauseGame();
      overlays.add('WinButton');
    }
  }

  void restartGame() {
    for (final component in _enemySpawner.children.toList()) {
      if (component is Balloon) {
        component.removeFromParent();
      }
    }

    _cuphead.resetCuphead();
    _healthComponent
        .updateHealth(_cuphead.getHealth() + 2); //+2 for spritesheet

    _pressedKeys.clear();

    scoreComponent.resetScore();

    isGamePaused = false;
    overlays.remove('RestartButton');
    overlays.remove('WinButton');
    resumeEngine();
  }

  void pauseGame() {
    isGamePaused = true;
    pauseEngine();
  }
}
