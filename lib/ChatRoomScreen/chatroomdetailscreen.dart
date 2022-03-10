import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../ConversationScreen/conversationscreen.dart';
import '../HomeScreen/homescreen.dart';
import '../models/chatroom.dart';
import '../models/user.dart';
import '../models/mydata.dart';
import '../main.dart';

String ip = 'http://192.168.43.62:3000';
//String ip = 'http://10.0.2.2:3000';

class ChatRoomDetailScreen extends StatefulWidget {
  const ChatRoomDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/ChatRoomDetail';
  @override
  State<ChatRoomDetailScreen> createState() => _ChatRoomDetailScreenState();
}

class _ChatRoomDetailScreenState extends State<ChatRoomDetailScreen> {
  Future<http.Response> _updateChatroom(ChatRoom room) async {
    var url = Uri.parse(ip + '/app/updateChatroom');
    var response = await http.post(
      url,
      body: {
        'id': room.id_,
      },
    );
    return response;
  }

  Future<int> _leaveChatroom(ChatRoom room, MyData me) async {
    var url = Uri.parse(ip + '/app/leaveChatroom');
    var response = await http.post(
      url,
      body: {
        'id': room.id_,
        'username': me.username,
      },
    );
    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    final rooms = Provider.of<ChatRooms>(context);
    final user_ = Provider.of<Users>(context);
    final my = Provider.of<My>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final ChatRoom room =
        ModalRoute.of(context)!.settings.arguments as ChatRoom;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 2), () async {
            var res = await _updateChatroom(room);
            if (res.statusCode == 200) {
              var u = json.decode(res.body)['chatroom'];
              List<String> members = [];
              for (var item in u['members']) {
                members.add(item.toString());
              }

              var buffer = base64.decode(u['dp']);
              final dir = await getExternalStorageDirectory();
              final image = File(dir!.path + '/' + u['name'] + '.jpg');
              image.writeAsBytesSync(buffer);

              ChatRoom _room = ChatRoom(
                id_: room.id_,
                type: room.type,
                name: u['name'],
                dp: dir.path + '/dp.jpg',
                description: u['description'],
                members: members,
                msgs: room.msgs,
              );
              db.chatroomTb.put(_room);
              rooms.refreshRoom(_room);
            } else {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text(
                    'Something went wrong try again..',
                  ),
                ),
              );
            }
            setState(() {});
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: sp * 0.06),
                child: GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: FileImage(File(room.dp)),
                    radius: sp * 0.13,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: sp * 0.04,
                ),
                child: Text(
                  room.name,
                  style: TextStyle(
                    fontSize: sp * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: sp * 0.02,
                  bottom: sp * 0.03,
                ),
                child: Text(
                  'MEMBERS',
                  style: TextStyle(
                    fontSize: sp * 0.025,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: room.members.length,
                itemBuilder: (context, i) {
                  var user = user_.getUsers
                      .where((val) => val.username == room.members[i]);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(File(user.elementAt(0).dp)),
                    ),
                    title: Text(user.elementAt(0).name),
                    subtitle: Text(user.elementAt(0).bio),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          ConversationScreen.routeName,
                          arguments: user);
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.view_quilt_sharp),
                title: const Text('Description'),
                subtitle: Text(room.description),
                contentPadding: EdgeInsets.only(
                  top: sp * 0.01,
                  left: sp * 0.03,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Description'),
                        content: Text(room.description),
                      );
                    },
                  );
                },
              ),

              /*ListTile(
                leading: const Icon(
                  Icons.report,
                  color: Colors.red,
                ),
                title: Text(
                  'Report ${room.name}',
                  style: const TextStyle(color: Colors.red),
                ),
                subtitle: const Text(
                  'Report the user',
                  style: TextStyle(color: Colors.red),
                ),
                contentPadding: EdgeInsets.only(
                  top: sp * 0.01,
                  left: sp * 0.03,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Report ${room.name}'),
                        content: const Text('Report the user'),
                        actions: [
                          TextButton(
                            child: const Text('CANCEL'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Report'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  content:
                                      Text('${room.name} has been reported.'),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.block,
                  color: Colors.red,
                ),
                title: Text(
                  'Block ${room.name}',
                  style: const TextStyle(color: Colors.red),
                ),
                subtitle: const Text(
                  'Block the user',
                  style: TextStyle(color: Colors.red),
                ),
                contentPadding: EdgeInsets.only(
                  top: sp * 0.01,
                  left: sp * 0.03,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Block ${room.name}'),
                        content: const Text('Block the user'),
                        actions: [
                          TextButton(
                            child: const Text('CANCEL'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('BLOCK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  content:
                                      Text('${room.name} has been blocked.'),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),*/
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text(
                  'Delete Grp',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: const Text(
                  'Delete and leave',
                  style: TextStyle(color: Colors.red),
                ),
                contentPadding: EdgeInsets.only(
                  top: sp * 0.01,
                  left: sp * 0.03,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete ${room.name}'),
                        content: const Text('Delete and leave the group'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            child: const Text('DELETE'),
                            onPressed: () async {
                              if (await _leaveChatroom(room, my.getMe) == 200) {
                                rooms.deleteRoom(room);
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text('DELETED'),
                                  ),
                                );
                                Navigator.of(context).popUntil(
                                    ModalRoute.withName(HomeScreen.routename));
                              } else {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Text(
                                      'Something went wrong please try again.',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
