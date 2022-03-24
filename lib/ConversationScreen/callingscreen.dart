// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../ConversationScreen/callscreen.dart';
import '../models/user.dart';

import '../main.dart';

class CallingScreen extends StatelessWidget {
  CallingScreen({Key? key, required this.user, required this.mode})
      : super(key: key);
  final User user;
  final bool mode;
  bool init = true;
  final AssetsAudioPlayer player = AssetsAudioPlayer();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    player.open(Audio('assets/tone.mp3'));
    player.play();

    if (init) {
      init = false;
      socket.on('call', (data) {
        if (data['ans'] == '1') {
          player.stop();
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (ctx) {
            return CallScreen(user: user.username, mode: true);
          }));
        } else {
          player.stop();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 5),
              content: Text(
                'User unavailable....',
              ),
            ),
          );
          Navigator.of(context).pop();
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: sp * 0.03,
            ),
            child: CircleAvatar(
              backgroundImage: FileImage(File(user.dp)),
              radius: sp * 0.15,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: sp * 0.03,
            ),
            child: Text(
              user.name,
              style: TextStyle(color: Colors.white, fontSize: sp * 0.025),
            ),
          ),
          mode
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: 1,
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.call_end),
                        onPressed: () {
                          socket.emit(
                              'call', {'username': user.username, 'ans': '0'});
                          player.stop();
                          Navigator.of(context).pop();
                        },
                      ),
                      FloatingActionButton(
                        heroTag: 2,
                        child: const Icon(Icons.call),
                        onPressed: () {
                          socket.emit(
                              'call', {'username': user.username, 'ans': '1'});
                          player.stop();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (ctx) {
                            return CallScreen(user: user.username, mode: false);
                          }));
                        },
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: 3,
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.call_end),
                        onPressed: () {
                          socket.emit(
                              'call', {'username': user.username, 'ans': '0'});
                          player.stop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
