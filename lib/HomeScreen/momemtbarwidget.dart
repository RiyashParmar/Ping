import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart';

import '../models/user.dart';
import '../models/mydata.dart';
import '../main.dart';

class MomentBar extends StatefulWidget {
  const MomentBar({Key? key}) : super(key: key);
  @override
  State<MomentBar> createState() => _MomentBarState();
}

class _MomentBarState extends State<MomentBar> {
  bool check(List<String> m) {
    bool check = false;
    for (var item in m) {
      if (item.substring(0, 1) == '0') {
        check = true;
      }
    }
    return check;
  }

  StoryItem story(Users u, User user, double sp) {
    List<Scaffold> moments() {
      List<Scaffold> moments = [];
      for (var item in user.moments) {
        Scaffold s = Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: FileImage(File(user.dp)),
                ),
                Column(
                  children: [
                    Text(user.name),
                    SizedBox(height: sp * 0.01),
                    Text(item.substring(1, 12),
                        style: TextStyle(fontSize: sp * 0.015)),
                  ],
                ),
              ],
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(
                  File(item.substring(12)),
                ),
              ),
            ),
          ),
        );
        moments.add(s);
      }
      return moments;
    }

    return StoryItem(
      name: user.name,
      thumbnail: FileImage(File(user.dp)),
      stories: moments(),
    );
  }

  List<Scaffold> mymoments(My me, MyData m, double sp) {
    List<Scaffold> moments = [];
    for (var item in m.moments) {
      Scaffold s = Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: FileImage(File(m.dp)),
              ),
              SizedBox(width: sp * 0.01),
              Column(
                children: [
                  const Text('My Post'),
                  SizedBox(height: sp * 0.01),
                  Text(item.substring(1, 12),
                      style: TextStyle(fontSize: sp * 0.015)),
                ],
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(
                File(item.substring(12)),
              ),
            ),
          ),
        ),
      );
      moments.add(s);
    }
    return moments;
  }

  @override
  Widget build(BuildContext context) {
    final my = Provider.of<My>(context);
    final user = Provider.of<Users>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final List<String> users = [];
    final List<User> moments = [];
    for (var item in user.getUsers) {
      users.add(item.username);
    }
    for (var item in user.getUsers) {
      if (item.moments.isNotEmpty) {
        moments.add(item);
      }
    }

    return SizedBox(
      height: sp * 0.15,
      width: media.size.width * 0.97,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: sp * 0.004,
              left: sp * 0.015,
            ),
            child: my.getMe.moments.isNotEmpty
                ? GestureDetector(
                    child: Stories(
                      highLightColor: Colors.transparent,
                      spaceBetweenStories: sp * 0.01,
                      autoPlayDuration: const Duration(seconds: 5),
                      displayProgress: true,
                      showStoryNameOnFullPage: false,
                      showThumbnailOnFullPage: false,
                      storyItemList: [
                        StoryItem(
                          name: 'My Post',
                          thumbnail: FileImage(File(my.getMe.dp)),
                          stories: mymoments(my, my.getMe, sp),
                        ),
                      ],
                    ),
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
                                    onTap: () async {
                                      ImagePicker picker = ImagePicker();
                                      var picked = await picker.pickImage(
                                          source: ImageSource.camera);
                                      var timestamp = DateFormat("hh:mm:ss a")
                                          .format(DateTime.now())
                                          .toString();
                                      String msg =
                                          '0' + timestamp + picked!.path;
                                      File file_ = File(picked.path);
                                      List<int> bytes = file_.readAsBytesSync();
                                      String fil = base64.encode(bytes);

                                      String _msg = '0' + timestamp + fil;
                                      my.addMoment(msg);
                                      socket.emit('moment', {
                                        'sender': my.getMe.username,
                                        'reciver': users,
                                        'msg': _msg,
                                      });
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.library_add,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    title: const Text(
                                      'Pick from gallery',
                                    ),
                                    onTap: () async {
                                      ImagePicker picker = ImagePicker();
                                      var picked = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      var timestamp = DateFormat("hh:mm:ss a")
                                          .format(DateTime.now())
                                          .toString();
                                      String msg =
                                          '0' + timestamp + picked!.path;
                                      File file_ = File(picked.path);
                                      List<int> bytes = file_.readAsBytesSync();
                                      String fil = base64.encode(bytes);

                                      String _msg = '0' + timestamp + fil;
                                      my.addMoment(msg);
                                      socket.emit('moment', {
                                        'sender': my.getMe.username,
                                        'reciver': users,
                                        'msg': _msg,
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: sp * 0.012,
                          left: sp * 0.015,
                        ),
                        child: GestureDetector(
                          child: CircleAvatar(
                            backgroundImage: FileImage(File(my.getMe.dp)),
                            radius: sp * 0.035,
                          ),
                          onTap: () async {
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
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          title: const Text(
                                            'Take a picture',
                                          ),
                                          onTap: () async {
                                            ImagePicker picker = ImagePicker();
                                            var picked = await picker.pickImage(
                                                source: ImageSource.camera);
                                            var timestamp =
                                                DateFormat("hh:mm:ss a")
                                                    .format(DateTime.now())
                                                    .toString();
                                            String msg =
                                                '0' + timestamp + picked!.path;
                                            File file_ = File(picked.path);
                                            List<int> bytes =
                                                file_.readAsBytesSync();
                                            String fil = base64.encode(bytes);

                                            String _msg = '0' + timestamp + fil;
                                            my.addMoment(msg);
                                            socket.emit('moment', {
                                              'sender': my.getMe.username,
                                              'reciver': users,
                                              'msg': _msg,
                                            });
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.library_add,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          title: const Text(
                                            'Pick from gallery',
                                          ),
                                          onTap: () async {
                                            ImagePicker picker = ImagePicker();
                                            var picked = await picker.pickImage(
                                                source: ImageSource.gallery);
                                            var timestamp =
                                                DateFormat("hh:mm:ss a")
                                                    .format(DateTime.now())
                                                    .toString();
                                            String msg =
                                                '0' + timestamp + picked!.path;
                                            File file_ = File(picked.path);
                                            List<int> bytes =
                                                file_.readAsBytesSync();
                                            String fil = base64.encode(bytes);

                                            String _msg = '0' + timestamp + fil;
                                            my.addMoment(msg);
                                            socket.emit('moment', {
                                              'sender': my.getMe.username,
                                              'reciver': users,
                                              'msg': _msg,
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
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
          moments.isEmpty
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
                    padding: EdgeInsets.only(top: sp * 0.004, left: sp * 0.015),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          child: Stories(
                            highLightColor: Colors.transparent,
                            spaceBetweenStories: sp * 0.01,
                            autoPlayDuration: const Duration(seconds: 5),
                            displayProgress: true,
                            showStoryNameOnFullPage: false,
                            showThumbnailOnFullPage: false,
                            storyItemList: [
                              story(user, moments[i], sp),
                            ],
                          ),
                        );
                      },
                      itemCount: moments.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
