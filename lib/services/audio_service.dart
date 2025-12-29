import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      try {
        await _tts.setLanguage('ja-JP');
        await _tts.setSpeechRate(0.4);
        await _tts.setVolume(1.0);
        await _tts.setPitch(1.0);
        _isInitialized = true;
        // In production, you might want to remove or use a proper logging solution
        // debugPrint('TTS initialized successfully');
      } catch (e) {
        // In production, you might want to remove or use a proper logging solution
        // debugPrint('Failed to initialize TTS: $e');
      }
    }
  }

  Future<void> playSound(String assetPath) async {
    try {
      await _audioPlayer.play(AssetSource(assetPath));
      // In production, you might want to remove or use a proper logging solution
      // debugPrint('Playing sound: $assetPath');
    } catch (e) {
      // In production, you might want to remove or use a proper logging solution
      // debugPrint('Error playing sound: $assetPath, error: $e');
    }
  }

  Future<void> speakJapanese(String text) async {
    try {
      await _tts.speak(text);
      // In production, you might want to remove or use a proper logging solution
      // debugPrint('Speaking text: $text');
    } catch (e) {
      // In production, you might want to remove or use a proper logging solution
      // debugPrint('Error speaking text: $text, error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      await _tts.stop();
      // In production, you might want to remove or use a proper logging solution
      // debugPrint('Audio stopped');
    } catch (e) {
      // In production, you might want to remove or use a proper logging solution
      // debugPrint('Error stopping audio: $e');
    }
  }

  void dispose() {
    try {
      _audioPlayer.dispose();
      // In production, you might want to remove or use a proper logging solution
      // debugPrint('AudioService disposed');
    } catch (e) {
      // In production, you might want to remove or use a proper logging solution
      // debugPrint('Error disposing AudioService: $e');
    }
  }
}