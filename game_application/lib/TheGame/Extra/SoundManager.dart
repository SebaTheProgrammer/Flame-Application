import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._();
  static SoundManager get instance => _instance;

  SoundManager._();

  bool _playingMusic = false;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    try {
      // Load all audio files
      await FlameAudio.audioCache.loadAll([
        'Level.mp3',
      ]);

      // Initialize background music
      FlameAudio.bgm.initialize();

      _isInitialized = true;
    } catch (e) {
      print('Error initializing sound: $e');
    }
  }

  Future<void> playSound(String sound) async {
    if (!_isInitialized) {
      print('SoundManager not initialized.');
      return;
    }

    try {
      if (!_playingMusic) {
        if (FlameAudio.audioCache.loadedFiles.containsKey(sound)) {
          await FlameAudio.loopLongAudio(sound);
          _playingMusic = true;
        } else {
          print('Sound file $sound is not loaded.');
        }
      }
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void stopMusic() {
    if (_playingMusic) {
      try {
        FlameAudio.bgm.stop();
        _playingMusic = false;
      } catch (e) {
        print('Error stopping music: $e');
      }
    }
  }
}
