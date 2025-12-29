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

  Future<void> _playSound() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() => _isPlaying = false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _audioPlayer.play(AssetSource(widget.soundPath));

      if (mounted) {
        setState(() {
          _isPlaying = true;
          _isLoading = false;
        });
      }

      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isLoading = false;
        });
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to play sound: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _playSound,
      icon: _isLoading
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : Icon(
        _isPlaying ? Icons.stop : Icons.volume_up,
        size: 20,
      ),
      label: Text(
        _isPlaying ? 'STOP' : 'PLAY',
        style: const TextStyle(fontSize: 14),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
    );
  }
}