import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'menuwidget.dart';
import 'conversationbarwidget.dart';
import 'conversationdetailscreen.dart';
import 'callscreen.dart';

class Msg {
  dynamic msg;
  String date;
  String type;
  String format;
  String path;
  bool play;
  Msg({
    required this.msg,
    required this.date,
    required this.type,
    required this.format,
    required this.path,
    required this.play,
  });
}

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);
  static const routeName = '/Conversation';
  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  List<Msg> txt = [];

  void play(String path) {
    player.open(Audio.file(path));
  }

  Widget msgUI(Msg txt) {
    if (txt.format == 'txt') {
      return Text(txt.msg);
    } /**else if (txt.format == 'image') {
    } **/
    else if (txt.format == 'audio') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: GestureDetector(
              child: Icon(txt.play ? Icons.pause : Icons.play_arrow),
              onTap: () {
                setState(() {
                  txt.play ? player.pause() : play(txt.path);
                  txt.play = !txt.play;
                });
              },
            ),
          ),
          const Expanded(
            flex: 4,
            child: ProgressBar(
              progress: Duration(seconds: 0),
              total: Duration(seconds: 0),
            ),
          ),
        ],
      );
    }
    /**else if (txt.format == 'video') {
    } else if (txt.format == 'file') {}**/
    return const Text('error');
  }

  void update(String msg, String date, String format, String path) {
    setState(() {
      txt.add(
        Msg(
          msg: msg,
          date: date,
          type: "Sender",
          format: format,
          path: path,
          play: false,
        ),
      );
      txt.add(
        Msg(
          msg: msg,
          date: date,
          type: "Reciver",
          format: format,
          path: path,
          play: false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final user = ModalRoute.of(context)!.settings.arguments as List;
    final appBar = AppBar(
      leadingWidth: sp * 0.04,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(ConversationDetailScreen.routeName, arguments: user),
            child: Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                SizedBox(
                  width: sp * 0.01,
                ),
                SizedBox(
                  width: sp * 0.15,
                  child: Text(
                    user[0],
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CallScreen(user: user[0], mode: false),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CallScreen(user: user[0], mode: true),
            ),
          ),
        ),
        Menu(user: user[0]),
      ],
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                  itemCount: txt.length,
                  itemBuilder: (ctx, i) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: sp * 0.01,
                        left: txt[i].type == 'Sender' ? sp * 0.1 : sp * 0.005,
                        right: txt[i].type == 'Sender' ? sp * 0.005 : sp * 0.1,
                        bottom: sp * 0.01,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: txt[i].type == 'Sender'
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          txt[i].type == 'Sender'
                              ? Text(
                                  txt[i].date,
                                  style: TextStyle(fontSize: sp * 0.015),
                                )
                              : const Padding(padding: EdgeInsets.zero),
                          txt[i].type == 'Sender'
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
                            child: msgUI(txt[i]),
                          ),
                          txt[i].type != 'Sender'
                              ? SizedBox(width: sp * 0.01)
                              : const Padding(padding: EdgeInsets.zero),
                          txt[i].type != 'Sender'
                              ? Text(
                                  txt[i].date,
                                  style: TextStyle(fontSize: sp * 0.015),
                                )
                              : const Padding(padding: EdgeInsets.zero),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ConversationBar(update: update),
            ],
          ),
        ),
      ),
    );
  }
}
