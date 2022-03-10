import 'dart:io';

import 'package:flutter/material.dart';
import "package:story_view/story_view.dart";

import '../ConversationScreen/conversationbarwidget.dart';
import '../ConversationScreen/conversationdetailscreen.dart';

import '../models/mydata.dart';

class MomentScreen extends StatelessWidget {
  MomentScreen({Key? key}) : super(key: key);
  static const routeName = '/Status';
  final controller = StoryController();

  @override
  Widget build(BuildContext context) {
    final MyData user = ModalRoute.of(context)!.settings.arguments as MyData;
    final List<StoryItem> storyItems = [
      StoryItem.text(title: 'Hii', backgroundColor: Colors.black),
      StoryItem.pageImage(
          url:
              'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
          controller: controller),
    ];
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leadingWidth: sp * 0.05,
        shadowColor: Colors.white,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            ConversationDetailScreen.routeName,
            arguments: user,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: FileImage(File(user.dp)),
                radius: sp * 0.03,
              ),
              SizedBox(width: sp * 0.01),
              Text(user.name),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text('Mute Moments'),
                    content: const Text(
                        'The users moments would not appear in your recent moments tab.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('CANCEL'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.grey,
                              duration: Duration(seconds: 2),
                              content: Text('MUTED!'),
                            ),
                          );
                        },
                        child: const Text('MUTE'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.not_interested),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_sharp),
          ),
        ],
      ),
      body: Stack(
        children: [
          StoryView(
            storyItems: storyItems,
            controller: controller,
            repeat: false,
            inline: true,
            progressPosition: ProgressPosition.top,
            //onComplete: () => Navigator.of(context).pop(),
          ),
          Positioned(
              bottom: sp * 0.01,
              right: sp * 0.01,
              left: sp * 0.01,
              child: const Text('ok') //ConversationBar(),
              ),
        ],
      ),
    );
  }
}
