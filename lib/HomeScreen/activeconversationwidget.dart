import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ConversationScreen/conversationscreen.dart';
import '../ChatRoomScreen/chatroomscreen.dart';

import '../models/user.dart';
import '../models/chatroom.dart';

class ActiveConversation extends StatefulWidget {
  const ActiveConversation({Key? key}) : super(key: key);
  @override
  State<ActiveConversation> createState() => _ActiveConversationState();
}

class _ActiveConversationState extends State<ActiveConversation> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    final room = Provider.of<ChatRooms>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final List activeconvos = [];

    for (var item in user.getUsers) {
      if (item.msgs.isNotEmpty) {
        activeconvos.add(item);
      }
    }

    for (var item in room.getRooms) {
      activeconvos.add(item);
    }

    return SizedBox(
      height: media.size.height * 0.7,
      width: media.size.width,
      child: activeconvos.isEmpty
          ? Center(
              child: Text(
                'NO CONVERSATIONS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: sp * 0.02,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (context, i) {
                return ListTile(
                  onTap: () {
                    activeconvos[i] is User
                        ? Navigator.of(context).pushNamed(
                            ConversationScreen.routeName,
                            arguments: activeconvos[i],
                          )
                        : Navigator.of(context).pushNamed(
                            ChatRoomScreen.routeName,
                            arguments: activeconvos[i],
                          );
                  },
                  leading: CircleAvatar(
                    backgroundImage: FileImage(File(activeconvos[i].dp)),
                  ),
                  title: Text(
                    activeconvos[i].name,
                    maxLines: 1,
                  ),
                  subtitle: Text(activeconvos[i].msgs.length - 1 >= 0
                      ? activeconvos[i]
                          .msgs[activeconvos[i].msgs.length - 1]
                          .substring(
                              16,
                              activeconvos[i] is User
                                  ? null
                                  : activeconvos[i]
                                      .msgs[activeconvos[i].msgs.length - 1]
                                      .indexOf(' ~;\\\$'))
                      : ''),
                  contentPadding: EdgeInsets.all(sp * 0.010),
                  trailing: Text(
                    activeconvos[i].msgs.length - 1 >= 0
                        ? activeconvos[i]
                            .msgs[activeconvos[i].msgs.length - 1]
                            .substring(2, 13)
                        : '',
                  ),
                );
              },
              itemCount: activeconvos.length,
            ),
    );
  }
}
