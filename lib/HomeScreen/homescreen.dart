import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../WatchPartyScreen/playerwidget.dart';
import '../NotificationService/notificationservice.dart';
import '../ConversationScreen/callingscreen.dart';
import '../StartScreen/loginscreen.dart';
import '../models/user.dart';
import '../models/chatroom.dart';
import '../models/mydata.dart';
import '../main.dart';
//import '../WebRtc/webrtc.dart';

import 'momemtbarwidget.dart';
import 'activeconversationwidget.dart';
import 'bottombarwidget.dart';

import '../objectbox.g.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routename = '/Home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  AppLifecycleState appLifecycleState = AppLifecycleState.resumed;
  bool init = true;

  void pop() {
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }

  List<User> moment(users) {
    List<User> a = [];
    for (var i = 0; i < users.length; i++) {
      if (users[i].moments.isNotEmpty) {
        a.add(users[i]);
      }
    }
    return a;
  }

  void setInterval(String username, socket) {
    Duration periodic = const Duration(milliseconds: 2000);
    Timer.periodic(periodic, (intervalTime) {
      socket.emit('heartbeat', {'username': username});
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    socket.connect();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      appLifecycleState = state;
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
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

      socket.on('message', (data) async {
        if (data['type'] == 'single') {
          if (data['msg'].substring(14, 15) == 'T' ||
              data['msg'].substring(14, 15) == 'L') {
            Query<User> query =
                db.userTb.query(User_.username.equals(data['sender'])).build();
            User? a = query.findUnique();
            query.close();
            user.addMsg(a!, data['msg']);
            if (appLifecycleState != AppLifecycleState.resumed) {
              AndroidNotificationDetails androidPlatformChannelSpecifics =
                  const AndroidNotificationDetails('1', 'party');
              NotificationDetails platformChannelSpecifics =
                  NotificationDetails(android: androidPlatformChannelSpecifics);
              NotificationService().flutterLocalNotificationsPlugin.show(
                  1, data['sender'], 'New message', platformChannelSpecifics,
                  payload: '');
            }
          } else if (data['msg'].substring(14, 15) == 'A') {
            var buffer = base64.decode(data['msg'].substring(
                16,
                data['reciver'].length == 1
                    ? null
                    : data['msg'].indexOf(' ~;\\\$')));
            final dir = await getExternalStorageDirectory();
            final _data = File(dir!.path +
                '/' +
                data['sender'] +
                data['msg'].substring(2, 13) +
                '.mp3');
            _data.writeAsBytesSync(buffer);

            Query<User> query =
                db.userTb.query(User_.username.equals(data['sender'])).build();
            User? a = query.findUnique();
            query.close();
            user.addMsg(
                a!,
                '1 ' +
                    data['msg'].substring(2, 13) +
                    ' A ' +
                    dir.path +
                    '/' +
                    data['sender'] +
                    data['msg'].substring(2, 13) +
                    '.mp3');
            if (appLifecycleState != AppLifecycleState.resumed) {
              AndroidNotificationDetails androidPlatformChannelSpecifics =
                  const AndroidNotificationDetails('1', 'party');
              NotificationDetails platformChannelSpecifics =
                  NotificationDetails(android: androidPlatformChannelSpecifics);
              NotificationService().flutterLocalNotificationsPlugin.show(
                  1, data['sender'], 'New message', platformChannelSpecifics,
                  payload: '');
            }
          } else {
            var buffer = base64.decode(data['msg'].substring(
                16,
                data['reciver'].length == 1
                    ? null
                    : data['msg'].indexOf(' ~;\\\$')));
            final dir = await getExternalStorageDirectory();
            final _data = File(dir!.path +
                '/' +
                data['sender'] +
                data['msg'].substring(2, 13) +
                '.' +
                data['ext']);
            _data.writeAsBytesSync(buffer);

            Query<User> query =
                db.userTb.query(User_.username.equals(data['sender'])).build();
            User? a = query.findUnique();
            query.close();
            user.addMsg(
                a!,
                '1 ' +
                    data['msg'].substring(2, 13) +
                    ' F ' +
                    dir.path +
                    '/' +
                    data['sender'] +
                    data['msg'].substring(2, 13) +
                    '.' +
                    data['ext']);
            if (appLifecycleState != AppLifecycleState.resumed) {
              AndroidNotificationDetails androidPlatformChannelSpecifics =
                  const AndroidNotificationDetails('1', 'party');
              NotificationDetails platformChannelSpecifics =
                  NotificationDetails(android: androidPlatformChannelSpecifics);
              NotificationService().flutterLocalNotificationsPlugin.show(
                  1, data['sender'], 'New message', platformChannelSpecifics,
                  payload: '');
            }
          }
        } else {
          if (data['msg'].substring(14, 15) == 'T') {
            Query<ChatRoom> query =
                db.chatroomTb.query(ChatRoom_.id_.equals(data['type'])).build();
            ChatRoom? a = query.findUnique();
            query.close();
            chatroom.addMsg(a!, data['msg']);
          } else if (data['msg'].substring(14, 15) == 'A') {
            var buffer = base64.decode(
                data['msg'].substring(16, data['msg'].indexOf(' ~;\\\$')));
            final dir = await getExternalStorageDirectory();
            final _data = File(dir!.path +
                '/' +
                data['sender'] +
                data['msg'].substring(2, 13) +
                '.mp3');
            _data.writeAsBytesSync(buffer);

            Query<ChatRoom> query =
                db.chatroomTb.query(ChatRoom_.id_.equals(data['type'])).build();
            ChatRoom? a = query.findUnique();
            query.close();
            chatroom.addMsg(
                a!,
                '1 ' +
                    data['msg'].substring(2, 13) +
                    ' A ' +
                    dir.path +
                    '/' +
                    data['sender'] +
                    data['msg'].substring(2, 13) +
                    '.mp3');
            if (appLifecycleState != AppLifecycleState.resumed) {
              AndroidNotificationDetails androidPlatformChannelSpecifics =
                  const AndroidNotificationDetails('1', 'party');
              NotificationDetails platformChannelSpecifics =
                  NotificationDetails(android: androidPlatformChannelSpecifics);
              NotificationService().flutterLocalNotificationsPlugin.show(
                  1, data['sender'], 'New message', platformChannelSpecifics,
                  payload: '');
            }
          } else if (data['msg'].substring(14, 15) == 'L') {
            Query<ChatRoom> query =
                db.chatroomTb.query(ChatRoom_.id_.equals(data['type'])).build();
            ChatRoom? a = query.findUnique();
            query.close();
            chatroom.addMsg(a!, data['msg']);
            if (appLifecycleState != AppLifecycleState.resumed) {
              AndroidNotificationDetails androidPlatformChannelSpecifics =
                  const AndroidNotificationDetails('1', 'party');
              NotificationDetails platformChannelSpecifics =
                  NotificationDetails(android: androidPlatformChannelSpecifics);
              NotificationService().flutterLocalNotificationsPlugin.show(
                  1, data['sender'], 'New message', platformChannelSpecifics,
                  payload: '');
            }
          } else {
            var buffer = base64.decode(
                data['msg'].substring(16, data['msg'].indexOf(' ~;\\\$')));
            final dir = await getExternalStorageDirectory();
            final _data = File(dir!.path +
                '/' +
                data['sender'] +
                data['msg'].substring(2, 13) +
                '.' +
                data['ext']);
            _data.writeAsBytesSync(buffer);

            Query<ChatRoom> query =
                db.chatroomTb.query(ChatRoom_.id_.equals(data['type'])).build();
            ChatRoom? a = query.findUnique();
            query.close();
            chatroom.addMsg(
                a!,
                '1 ' +
                    data['msg'].substring(2, 13) +
                    ' F ' +
                    dir.path +
                    '/' +
                    data['sender'] +
                    data['msg'].substring(2, 13) +
                    '.' +
                    data['ext']);
            if (appLifecycleState != AppLifecycleState.resumed) {
              AndroidNotificationDetails androidPlatformChannelSpecifics =
                  const AndroidNotificationDetails('1', 'party');
              NotificationDetails platformChannelSpecifics =
                  NotificationDetails(android: androidPlatformChannelSpecifics);
              NotificationService().flutterLocalNotificationsPlugin.show(
                  1, data['sender'], 'New message', platformChannelSpecifics,
                  payload: '');
            }
          }
        }
      });

      socket.on('moment', (data) async {
        var buffer = base64.decode(data['msg'].substring(12));
        final dir = await getExternalStorageDirectory();
        final image =
            File(dir!.path + '/' + data['msg'].substring(1, 12) + '.jpg');
        image.writeAsBytesSync(buffer);

        Query<User> query =
            db.userTb.query(User_.username.equals(data['sender'])).build();
        User? a = query.findUnique();
        query.close();
        user.addMoment(
            a!,
            data['msg'].substring(0, 12) +
                dir.path +
                '/' +
                data['msg'].substring(1, 12) +
                '.jpg');
        if (appLifecycleState != AppLifecycleState.resumed) {
          AndroidNotificationDetails androidPlatformChannelSpecifics =
              const AndroidNotificationDetails('1', 'party');
          NotificationDetails platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);
          NotificationService().flutterLocalNotificationsPlugin.show(
              1, data['sender'], 'New moment', platformChannelSpecifics,
              payload: '');
        }
      });

      socket.on('newroom', (data) async {
        var buffer = base64.decode(data['dp']);
        final dir = await getExternalStorageDirectory();
        final image = File(dir!.path + '/' + data['_id'] + '.jpg');
        image.writeAsBytesSync(buffer);

        List<String> members = [];
        for (var i in data['members']) {
          members.add(i.toString());
        }

        ChatRoom x = ChatRoom(
          id_: data['_id'],
          name: data['name'],
          type: data['type'],
          createdby: data['createdby'],
          dp: dir.path + '/' + data['_id'] + '.jpg',
          description: data['description'],
          members: members,
          msgs: [],
        );
        chatroom.addRoom(x);
        if (appLifecycleState != AppLifecycleState.resumed) {
          AndroidNotificationDetails androidPlatformChannelSpecifics =
              const AndroidNotificationDetails('1', 'party');
          NotificationDetails platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);
          NotificationService().flutterLocalNotificationsPlugin.show(
              1, data['sender'], 'New room', platformChannelSpecifics,
              payload: '');
        }
      });

      socket.on('deleteroom', (data) {
        var _id = data['_id'];
        Query<ChatRoom> query =
            db.chatroomTb.query(ChatRoom_.id.equals(_id)).build();
        ChatRoom? room = query.findUnique();
        query.close();
        chatroom.deleteRoom(room!);
      });

      socket.on('startparty', (data) async {
        var invite = data['invite'];
        Future selectNotification(String? payload) async {
          //Handle notification tapped logic here
          if (payload!.startsWith('0')) {
            socket.emit(
                'resparty', {'username': payload.substring(1), 'res': '1'});
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
              return Player(username: payload.substring(1));
            }));
          }
        }

        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('splash');

        const InitializationSettings initializationSettings =
            InitializationSettings(android: initializationSettingsAndroid);

        await flutterLocalNotificationsPlugin.initialize(initializationSettings,
            onSelectNotification: selectNotification);

        AndroidNotificationDetails androidPlatformChannelSpecifics =
            const AndroidNotificationDetails('1', 'party');
        NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
          12345,
          invite + " Invite",
          "Invitation to join a Watch Party.",
          platformChannelSpecifics,
          payload: '0' + invite,
        );
      });

      socket.on('call', (data) async {
        var callee = data['callee'];
        Future selectNotification(String? payload) async {
          //Handle notification tapped logic here
          Query<User> query =
              db.userTb.query(User_.username.equals(data['callee'])).build();
          User? a = query.findUnique();
          query.close();
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return CallingScreen(user: a!, mode: true);
          }));
        }

        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('splash');

        const InitializationSettings initializationSettings =
            InitializationSettings(android: initializationSettingsAndroid);

        await flutterLocalNotificationsPlugin.initialize(initializationSettings,
            onSelectNotification: selectNotification);

        AndroidNotificationDetails androidPlatformChannelSpecifics =
            const AndroidNotificationDetails('1', 'party');
        NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(
          12345,
          callee + " Calling",
          "Incoming call...",
          platformChannelSpecifics,
          payload: callee,
        );
      });

      socket.emit('init', {'username': mydata.getMe.username});
      setInterval(mydata.getMe.username, socket);
    }

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
                      const MomentBar(),
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
              BottomBar(pop: pop),
            ],
          ),
        ),
      ),
    );
  }
}
