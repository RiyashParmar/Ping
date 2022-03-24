// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user.dart';
import '../models/mydata.dart';

import 'menuwidget.dart';
import 'conversationbarwidget.dart';
import 'conversationdetailscreen.dart';
import 'callingscreen.dart';

import '../main.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);
  static const routeName = '/Conversation';
  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String image = '';

  void change(String img) {
    image = img;
  }

  Widget msgUI(String txt) {
    if (txt.substring(14, 15) == 'T') {
      return Text(txt.substring(16));
    } else if (txt.substring(14, 15) == 'A') {
      return GestureDetector(
        child: const Icon(Icons.audiotrack),
        onTap: () {
          OpenFile.open(txt.substring(16));
        },
      );
    } else if (txt.substring(14, 15) == 'F') {
      return GestureDetector(
        child: const Icon(Icons.file_present_rounded),
        onTap: () {
          OpenFile.open(txt.substring(16));
        },
      );
    } else if (txt.substring(14, 15) == 'L') {
      return GestureDetector(
        onTap: () {
          launch(txt.substring(16));
        },
        child: Linkify(
          text: txt.substring(16),
          options: const LinkifyOptions(humanize: false),
        ),
      );
    }
    return const Text('error');
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pr = Provider.of<Users>(context);
    final my = Provider.of<My>(context);
    final User user = ModalRoute.of(context)!.settings.arguments as User;
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final List<String> convo = pr.getMsg(user.id);
    image = my.bgImg;

    final appBar = AppBar(
      leadingWidth: sp * 0.04,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(ConversationDetailScreen.routeName, arguments: user),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: FileImage(File(user.dp)),
                ),
                SizedBox(
                  width: sp * 0.01,
                ),
                SizedBox(
                  width: sp * 0.15,
                  child: Text(
                    user.name,
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
          icon: const Icon(Icons.videocam),
          onPressed: () {
            socket.emit('call',
                {'username': user.username, 'callee': my.getMe.username});
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => CallingScreen(user: user, mode: false),
              ),
            );
          },
        ),
        /*IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CallScreen(user: user.name),
            ),
          ),
        ),*/
        Menu(user: user.name, my: my, change: change),
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
                              convo[i].startsWith('0') ? sp * 0.09 : sp * 0.005,
                          right:
                              convo[i].startsWith('0') ? sp * 0.005 : sp * 0.09,
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
                ConversationBar(us: user, update: update),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
