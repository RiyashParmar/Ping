import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../models/chatroom.dart';
import '../models/mydata.dart';
import '../main.dart';
//import '../WebRtc/webrtc.dart';

import 'momemtbarwidget.dart';
import 'activeconversationwidget.dart';
import 'bottombarwidget.dart';

import 'package:ping/objectbox.g.dart';

String ip = 'http://192.168.43.62:3000';
//String ip = 'http://10.0.2.2:3000';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routename = '/Home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool init = true;

  List<User> moment(users) {
    List <User> a = [];
    for (var i = 0; i < users.length; i++) {
      if (users[i].moments.isNotEmpty) {
        a.add(users[i]);
      }
    }
    return a;
  }

  /*void setInterval(String username, socket) {
    Duration periodic = const Duration(milliseconds: 30000);
    Timer.periodic(periodic, (intervalTime) {
      socket.emit('heartbeat', {'username': username});
    });
  }*/

  @override
  void initState() {
    super.initState();
    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    final mydata = Provider.of<My>(context);
    final chatroom = Provider.of<ChatRooms>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;

    if (init) {
      init = false;
      chatroom.init();
      user.init();
      mydata.init();
      user.updateUsers();
      socket.on('message', (data) {
        Query<User> query =
            db.userTb.query(User_.username.equals(data['sender'])).build();
        User? a = query.findUnique();
        query.close();
        user.addMsg(a!, data['msg']);
      });
    }
    List<User> moments = moment(user.getUsers);

    return Scaffold(
      body: SizedBox(
        height: media.size.height,
        width: media.size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: media.viewPadding.bottom + (sp * 0.01),
                  right: media.viewPadding.right + (sp * 0.01),
                  left: media.viewPadding.left + (sp * 0.01),
                  top: media.viewPadding.top + (sp * 0.01),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(sp * 0.015),
                    ),
                    color: Theme.of(context).backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: sp * 0.4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      MomentBar(users: moments, me: mydata.getMe),
                      Divider(
                        thickness: sp * 0.005,
                        color: Theme.of(context).backgroundColor == Colors.black
                            ? Colors.grey
                            : null,
                      ),
                      const ActiveConversation(),
                    ],
                  ),
                ),
              ),
              const BottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
