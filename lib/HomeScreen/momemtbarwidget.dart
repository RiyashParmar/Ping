import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dashed_circle/dashed_circle.dart';

import '../MomentScreen/momentscreen.dart';
import '../models/user.dart';
import '../models/mydata.dart';

class MomentBar extends StatelessWidget {
  const MomentBar({Key? key, required this.users, required this.me})
      : super(key: key);
  final List<User> users;
  final MyData me;

  Widget story(int i, BuildContext context, double sp) {
    return SizedBox(
      height: sp * 0.11,
      width: sp * 0.1,
      child: Padding(
        padding: EdgeInsets.only(top: sp * 0.01),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  MomentScreen.routeName,
                  arguments: [users[i].name, users[i].number],
                );
              },
              child: DashedCircle(
                dashes: users[i].moments.length,
                color: Theme.of(context).iconTheme.color as Color,
                child: Padding(
                  padding: EdgeInsets.all(sp * 0.004),
                  child: CircleAvatar(
                    backgroundImage: FileImage(File(users[i].dp)),
                    radius: sp * 0.03,
                  ),
                ),
              ),
            ),
            SizedBox(height: sp * 0.01),
            Text(
              users[i].name,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return SizedBox(
      height: sp * 0.11,
      width: media.size.width * 0.97,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: sp * 0.01,
              left: sp * 0.004,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      MomentScreen.routeName,
                      arguments: me,
                    );
                  },
                  onLongPress: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return BottomSheet(
                          onClosing: () {},
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                    leading: Icon(
                                      Icons.camera_alt,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    title: const Text(
                                      'Take a picture',
                                    ),
                                    onTap: () {}),
                                ListTile(
                                    leading: Icon(
                                      Icons.videocam,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    title: const Text(
                                      'Record a video',
                                    ),
                                    onTap: () {}),
                                ListTile(
                                    leading: Icon(
                                      Icons.library_add,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    title: const Text(
                                      'Pick from gallery',
                                    ),
                                    onTap: () {}),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  child: DashedCircle(
                    dashes: me.moments.length,
                    color: Theme.of(context).iconTheme.color as Color,
                    child: Padding(
                      padding: EdgeInsets.all(sp * 0.004),
                      child: CircleAvatar(
                        backgroundImage: FileImage(File(me.dp)),
                        radius: sp * 0.03,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: sp * 0.01,
                ),
                const Text(
                  'My Post',
                  maxLines: 1,
                ),
              ],
            ),
          ),
          users.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(
                    left: sp * 0.08,
                    top: sp * 0.01,
                  ),
                  child: Text(
                    'NO RECENT MOMENTS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: sp * 0.02,
                    ),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: sp * 0.015),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return story(i, context, sp);
                      },
                      itemCount: users.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
