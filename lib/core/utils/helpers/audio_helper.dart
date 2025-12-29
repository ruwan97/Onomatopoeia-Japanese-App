import 'package:audioplayers/audioplayers.dart';

// Simple logging class
class AudioLogger {
  static void debug(String message) {
    // In production, you might want to use a proper logging package
    // For now, we'll keep it simple but you can easily replace this
    // with package:logger, package:flutter_logger, etc.
    // print('🔊 AUDIO DEBUG: $message');
  }

  static void error(String message, {Object? error}) {
    // Log errors properly
    // print('🔊 AUDIO ERROR: $message${error != null ? ' - $error' : ''}');
  }

  static void info(String message) {
    // print('🔊 AUDIO INFO: $message');
  }
}

class AudioHelper {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isInitialized = false;
  static bool _isPlaying = false;
  static String? _currentAsset;

  // Initialize audio player with proper configuration
  static Future<void> initialize() async {
    if (!_isInitialized) {
      try {
        await _player.setReleaseMode(ReleaseMode.stop);
        await _player.setVolume(1.0);

        // Listen to player state changes
        _player.onPlayerStateChanged.listen((state) {
          _isPlaying = state == PlayerState.playing;
          AudioLogger.debug('Player state changed: $state');
        });

        _player.onPlayerComplete.listen((event) {
          AudioLogger.debug('Playback completed');
          _currentAsset = null;
        });

        _isInitialized = true;
        AudioLogger.info('Audio player initialized');
      } catch (e) {
        AudioLogger.error('Failed to initialize audio player', error: e);
        rethrow;
      }
    }
  }

  // Play audio from assets
  static Future<void> playAsset(String assetPath, {double volume = 1.0}) async {
    try {
      if (_isPlaying) {
        await stop();
      }

      await _player.setVolume(volume);
      await _player.play(AssetSource(assetPath));
      _currentAsset = assetPath;

      AudioLogger.debug('Playing asset: $assetPath');
    } catch (e) {
      AudioLogger.error('Error playing asset: $assetPath', error: e);
      rethrow;
    }
  }

  // Play audio from URL
  static Future<void> playUrl(String url, {double volume = 1.0}) async {
    try {
      if (_isPlaying) {
        await stop();
      }

      await _player.setVolume(volume);
      await _player.play(UrlSource(url));
      _currentAsset = null; // Not an asset

      AudioLogger.debug('Playing URL: $url');
    } catch (e) {
      AudioLogger.error('Error playing URL: $url', error: e);
      rethrow;
    }
  }

  // Stop playback
  static Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
      _currentAsset = null;
      AudioLogger.debug('Playback stopped');
    } catch (e) {
      AudioLogger.error('Error stopping playback', error: e);
      rethrow;
    }
  }

  // Pause playback
  static Future<void> pause() async {
    try {
      await _player.pause();
      AudioLogger.debug('Playback paused');
    } catch (e) {
      AudioLogger.error('Error pausing playback', error: e);
      rethrow;
    }
  }

  // Resume playback
  static Future<void> resume() async {
    try {
      await _player.resume();
      AudioLogger.debug('Playback resumed');
    } catch (e) {
      AudioLogger.error('Error resuming playback', error: e);
      rethrow;
    }
  }

  // Adjust volume
  static Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume.clamp(0.0, 1.0));
      AudioLogger.debug('Volume set to: $volume');
    } catch (e) {
      AudioLogger.error('Error setting volume', error: e);
      rethrow;
    }
  }

  // Get current playback state
  static bool get isPlaying => _isPlaying;

  static String? get currentAsset => _currentAsset;

  // Get current position
  static Future<Duration?> getPosition() async {
    try {
      return await _player.getCurrentPosition();
    } catch (e) {
      AudioLogger.error('Error getting position', error: e);
      return null;
    }
  }

  // Get total duration
  static Future<Duration?> getDuration() async {
    try {
      return await _player.getDuration();
    } catch (e) {
      AudioLogger.error('Error getting duration', error: e);
      return null;
    }
  }

  // Seek to specific position
  static Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
      AudioLogger.debug('Seeked to: $position');
    } catch (e) {
      AudioLogger.error('Error seeking', error: e);
      rethrow;
    }
  }

  // Cleanup
  static void dispose() {
    _player.dispose();
    _isInitialized = false;
    _isPlaying = false;
    _currentAsset = null;
    AudioLogger.info('Audio player disposed');
  }
}