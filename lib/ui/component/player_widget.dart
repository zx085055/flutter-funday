import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({
    required this.player,
    super.key,
  });

  final AudioPlayer player;

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  PlayerState? _playerState;

  StreamSubscription<void>? _playerCompleteSubscription;
  StreamSubscription<void>? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  AudioPlayer get player => widget.player;

  @override
  void initState() {
    super.initState();
    _playerState = player.state;
    _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Colors.grey[800];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          radius: 30,
          child: _isPlaying
              ? IconButton(
                  key: const Key('pause_button'),
                  onPressed: _pause,
                  iconSize: 36,
                  icon: const Icon(Icons.pause),
                  color: color,
                )
              : IconButton(
                  key: const Key('play_button'),
                  onPressed: _play,
                  iconSize: 36,
                  icon: const Icon(Icons.play_arrow),
                  color: color,
                ),
        ),
      ],
    );
  }

  void _initStreams() {
    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
      });
    });

    _playerStateChangeSubscription = player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    await player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }
}
