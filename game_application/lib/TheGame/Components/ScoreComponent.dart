import 'package:flame/components.dart';

class ScoreComponent extends TextComponent {
  double _score = 0;
  double get score => _score;
  final int _constantAddedScore = 10;

  ScoreComponent() : super(text: 'Score: 0', textRenderer: TextPaint()) {
    anchor = Anchor.topCenter;
    position = Vector2.zero();
  }

  void addscore(int addedScore) {
    _score += addedScore;
  }

  void updateScore(double newScore) {
    _score = newScore;
    int printscore = _score.toInt();
    text = 'Score: $printscore';
  }

  void resetScore() {
    _score = 0;
    updateScore(_score);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _score += _constantAddedScore * dt;
    updateScore(_score);
  }
}
