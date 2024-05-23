import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _playMusic();
  }

  @override
  void dispose() {
    _stopMusic();
    super.dispose();
  }

  Future<void> _playMusic() async {
    await _audioPlayer.setSource(AssetSource('sounds/info.mp3'));
    await _audioPlayer.setVolume(0.05);
    await _audioPlayer.resume();
  }

  Future<void> _stopMusic() async {
    await _audioPlayer.stop();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Info Page'),
        ),
        Expanded(
            child: Image.asset(
          'assets/images/twerking_thanos.gif',
        )),
      ],
    ));
  }
}
