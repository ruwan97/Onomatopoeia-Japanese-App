import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String soundPath;

  const AudioPlayerWidget({
    super.key,
    required this.soundPath,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() => _isPlaying = false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Ensure the sound path is correct
      String assetPath = widget.soundPath;

      // Remove leading slash if present
      if (assetPath.startsWith('/')) {
        assetPath = assetPath.substring(1);
      }

      // Add assets prefix if not present
      if (!assetPath.startsWith('assets/')) {
        assetPath = 'assets/$assetPath';
      }

      await _audioPlayer.play(AssetSource(assetPath));

      setState(() {
        _isPlaying = true;
        _isLoading = false;
      });

      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      });
    } catch (e) {
      print('Error playing audio: $e');
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not play audio: ${widget.soundPath}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _playAudio,
      icon: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              _isPlaying ? Icons.stop : Icons.volume_up,
              color: Theme.of(context).colorScheme.primary,
            ),
      tooltip: _isPlaying ? 'Stop' : 'Play sound',
    );
  }
}
