import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Player extends StatefulWidget {
  const Player({ Key? key }) : super(key: key);
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  YoutubePlayerController controller = YoutubePlayerController(initialVideoId: 'iLnmTe5Q2Qw');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player'),),
      body: SingleChildScrollView(child: Column(children: [
        YoutubePlayer(controller: controller),
      ],)),
    );
  }
}