import 'dart:io';

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:provider/provider.dart';

import '../models/chatroom.dart';
import '../models/mydata.dart';

import 'chatroomdetailscreen.dart';
import 'conversationbarwidget.dart';
import 'menuwidget.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);
  static const routeName = '/ChatRoom';
  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  String image = '';

  void change(String img) {
    image = img;
  }

  void play(String path) {
    player.open(Audio.file(path));
  }

  Widget msgUI(String txt) {
    if (txt.substring(14, 15) == 'T') {
      return Text(txt.substring(16));
    } /**else if (txt.format == 'image') {
    } **/
    else if (txt.substring(14, 15) == 'A') {
      return GestureDetector(
        onTap: () {
          play(txt.substring(16));
          //print(txt.substring(16));
        },
        child: const Icon(Icons.audiotrack),
      );
    }
    /**else if (txt.substring(14,15) == 'V') {
    } else if (txt.substring(14,15) == 'F') {}**/
    return const Text('error');
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pr = Provider.of<ChatRooms>(context);
    final my = Provider.of<My>(context);
    final ChatRoom room =
        ModalRoute.of(context)!.settings.arguments as ChatRoom;
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final List<String> convo = pr.getMsg(room.id);
    image = my.bgImg;

    final appBar = AppBar(
      leadingWidth: sp * 0.04,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(ChatRoomDetailScreen.routeName, arguments: room),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: FileImage(File(room.dp)),
                ),
                SizedBox(
                  width: sp * 0.01,
                ),
                SizedBox(
                  width: sp * 0.15,
                  child: Text(
                    room.name,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Menu(grp: room, room: pr, my: my, change: change, update: update),
      ],
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        decoration: BoxDecoration(
          image: image == ''
              ? const DecorationImage(
                  image: AssetImage('assets/bg.jpg'),
                  fit: BoxFit.cover,
                )
              : DecorationImage(
                  image: FileImage(File(image)),
                  fit: BoxFit.cover,
                ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: media.size.height -
                      appBar.preferredSize.height -
                      media.viewPadding.top -
                      sp * 0.08 -
                      MediaQuery.of(context).viewInsets.bottom,
                  width: media.size.width,
                  child: ListView.builder(
                    itemCount: convo.length,
                    itemBuilder: (ctx, i) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: sp * 0.01,
                          left:
                              convo[i].startsWith('0') ? sp * 0.1 : sp * 0.005,
                          right:
                              convo[i].startsWith('0') ? sp * 0.005 : sp * 0.1,
                          bottom: sp * 0.01,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: convo[i].startsWith('0')
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            convo[i].substring(0, 1) == '0'
                                ? Text(
                                    convo[i].substring(2, 13),
                                    style: TextStyle(fontSize: sp * 0.015),
                                  )
                                : const Padding(padding: EdgeInsets.zero),
                            convo[i].substring(0, 1) == '0'
                                ? SizedBox(width: sp * 0.01)
                                : const Padding(padding: EdgeInsets.zero),
                            Container(
                              constraints: BoxConstraints(maxWidth: sp * 0.30),
                              padding: EdgeInsets.all(sp * 0.013),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: sp * 0.005,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(sp * 0.02),
                                color: Theme.of(context).backgroundColor,
                              ),
                              child: msgUI(convo[i]),
                            ),
                            convo[i].substring(0, 1) == '1'
                                ? SizedBox(width: sp * 0.01)
                                : const Padding(padding: EdgeInsets.zero),
                            convo[i].substring(0, 1) == '1'
                                ? Text(
                                    convo[i].substring(2, 13),
                                    style: TextStyle(fontSize: sp * 0.015),
                                  )
                                : const Padding(padding: EdgeInsets.zero),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ConversationBar(us: room, update: update),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
