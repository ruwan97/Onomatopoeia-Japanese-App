import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      await _tts.setLanguage('ja-JP');
      await _tts.setSpeechRate(0.4);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _isInitialized = true;
    }
  }

  Future<void> playSound(String assetPath) async {
    try {
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  Future<void> speakJapanese(String text) async {
    try {
      await _tts.speak(text);
    } catch (e) {
      print('Error speaking text: $e');
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    await _tts.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}