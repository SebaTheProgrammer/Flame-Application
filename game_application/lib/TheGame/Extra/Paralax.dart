import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';

class ParallaxBackground extends FlameGame {
  late ParallaxComponent skyParallax;
  late ParallaxComponent farHillsParallax;
  late ParallaxComponent closeHillsParallax;
  late ParallaxComponent groundParallax;

  double speedGround = 250;
  double speedCloseHills = 225;
  double speedFarHills = 200;
  double speedSky = 175;

  @override
  Future<void> onLoad() async {
    skyParallax = await loadParallaxComponent(
      [ParallaxImageData('SkyLoop.png')],
      baseVelocity: Vector2(speedSky, 0),
    );
    skyParallax.position = Vector2(0, -200);

    farHillsParallax = await loadParallaxComponent(
      [ParallaxImageData('FarHillsLoop.png')],
      baseVelocity: Vector2(speedFarHills, 0),
    );
    farHillsParallax.scale = Vector2(1, 0.4);
    farHillsParallax.position = Vector2(0, 250);

    closeHillsParallax = await loadParallaxComponent(
      [ParallaxImageData('CloseHillsLoop.png')],
      baseVelocity: Vector2(speedCloseHills, 0),
    );
    closeHillsParallax.scale = Vector2(1, 0.4);
    closeHillsParallax.position = Vector2(0, 350);

    groundParallax = await loadParallaxComponent(
      [ParallaxImageData('MainLoop.png')],
      baseVelocity: Vector2(speedGround, 0),
    );
    groundParallax.position = Vector2(0, 500);
    groundParallax.scale = Vector2(1, 0.5);

    add(skyParallax);
    add(farHillsParallax);
    add(closeHillsParallax);
    add(groundParallax);
  }
}

class ParallaxForeground extends FlameGame {
  late ParallaxComponent foregroundParallax;
  late ParallaxComponent foreground2Parallax;
  double speedForeGround = 275;

  @override
  Future<void> onLoad() async {
    foregroundParallax = await loadParallaxComponent(
      [ParallaxImageData('ForeGroundLoop.png')],
      baseVelocity: Vector2(speedForeGround, 0),
    );
    foregroundParallax.position = Vector2(0, -115);
    foregroundParallax.scale = Vector2(1, 1.2);

    foreground2Parallax = await loadParallaxComponent(
      [ParallaxImageData('ForeGroundLoop2.png')],
      baseVelocity: Vector2(speedForeGround + 10, 0),
    );
    foreground2Parallax.position = Vector2(0, -250);
    foreground2Parallax.scale = Vector2(1, 1.4);

    add(foregroundParallax);
    add(foreground2Parallax);
  }
}
