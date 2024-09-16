import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._();
  static SoundManager get instance => _instance;

  SoundManager._();

  bool _isBackgroundMusicPlaying = false;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    try {
      await FlameAudio.audioCache.loadAll([
        'Fire.wav',
        'BalloonDeath.wav',
        'Level.mp3',
      ]);

      FlameAudio.bgm.initialize();

      _isInitialized = true;
    } catch (e) {
      print('Error initializing sound: $e');
    }
  }

  Future<void> _playSound(String sound,
      {bool isBackground = false, bool loop = false}) async {
    if (!_isInitialized) {
      print('SoundManager not initialized.');
      return;
    }

    try {
      if (FlameAudio.audioCache.loadedFiles.containsKey(sound)) {
        if (isBackground) {
          if (!_isBackgroundMusicPlaying) {
            if (loop) {
              await FlameAudio.loopLongAudio(sound);
            } else {
              await FlameAudio.playLongAudio(sound);
            }
            _isBackgroundMusicPlaying = true;
          }
        } else {
          await FlameAudio.play(sound);
        }
      } else {
        print('Sound file $sound is not loaded.');
      }
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> playSoundEffect(String sound) async {
    await _playSound(sound);
  }

  Future<void> playBackgroundMusic(String sound, bool loop) async {
    await _playSound(sound, isBackground: true, loop: loop);
  }

  void stopBackgroundMusic() {
    if (_isBackgroundMusicPlaying) {
      FlameAudio.bgm.stop();
      _isBackgroundMusicPlaying = false;
    }
  }
}
