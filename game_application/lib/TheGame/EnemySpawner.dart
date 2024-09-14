import 'dart:math';
import 'package:Cuphead_application/TheGame/EnemyPool.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';

class EnemySpawner extends Component {
  final Vector2 screenSize;
  final double spawnInterval;
  double timeSinceLastSpawn = 0;
  final Random _random = Random();
  final Images images;

  late List<Sprite> _blueBalloonSprites;
  late List<Sprite> _greenBalloonSprites;
  late List<Sprite> _pinkBalloonSprites;

  late BalloonPool balloonPool;

  EnemySpawner({
    required this.screenSize,
    this.spawnInterval = 3.0,
    required this.images,
  });

  @override
  Future<void> onLoad() async {
    _blueBalloonSprites = await _loadBalloonSprites(34, 'boy');
    _greenBalloonSprites = await _loadBalloonSprites(52, 'girl');
    _pinkBalloonSprites = await _loadBalloonSprites(52, 'pink');

    final defaultAnimation = SpriteAnimation.spriteList(
      _blueBalloonSprites,
      stepTime: 0.1,
      loop: true,
    );

    balloonPool = BalloonPool(defaultAnimation);

    return super.onLoad();
  }

  Future<List<Sprite>> _loadBalloonSprites(int count, String color) async {
    final sprites = <Sprite>[];
    for (int i = 1; i <= count; i++) {
      final fileName =
          'Balloons/lv2-1_balloon_${color}_idle_00${i.toString().padLeft(2, '0')}.png';
      final image = await images.load(fileName);
      final sprite = Sprite(image);
      sprites.add(sprite);
    }
    return sprites;
  }

  @override
  void update(double dt) {
    super.update(dt);

    timeSinceLastSpawn += dt;

    if (timeSinceLastSpawn >= spawnInterval) {
      spawnBalloon();
      timeSinceLastSpawn = 0;
    }
  }

  void spawnBalloon() {
    List<Sprite> selectedSprites;
    switch (_random.nextInt(3)) {
      case 0:
        selectedSprites = _blueBalloonSprites;
        break;
      case 1:
        selectedSprites = _greenBalloonSprites;
        break;
      case 2:
        selectedSprites = _pinkBalloonSprites;
        break;
      default:
        selectedSprites = _blueBalloonSprites;
    }

    final balloonAnimation = SpriteAnimation.spriteList(
      selectedSprites,
      stepTime: 0.1,
      loop: true,
    );

    double startX = screenSize.x;
    double startY = 200 + _random.nextDouble() * (screenSize.y - 400);

    final double amplitude = 50.0 + _random.nextDouble() * 50.0;
    final double frequency = 2.0 + _random.nextDouble() * 2.0;
    final double speed = 100.0 + _random.nextDouble() * 150.0;

    final balloon = balloonPool.acquire();
    balloon
      ..position = Vector2(startX, startY)
      ..animation = balloonAnimation
      ..amplitude = amplitude
      ..frequency = frequency
      ..maxY = screenSize.y - 100
      ..minY = startY
      ..speed = speed;

    add(balloon);
  }
}
