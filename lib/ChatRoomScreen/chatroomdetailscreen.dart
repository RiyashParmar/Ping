import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

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
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  final GlobalKey<FormFieldState> _key1 = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _key2 = GlobalKey<FormFieldState>();

  Future<http.Response> _refreshChatroom(ChatRoom room) async {
    var url = Uri.parse(ip + '/app/refreshChatroom');
    var response = await http.post(
      url,
      body: {
        'id': room.id_,
      },
    );
    return response;
  }

  Future<int> _editDescription(ChatRoom r, MyData m) async {
    var url = Uri.parse(ip + '/app/editDescription');
    var response = await http.post(
      url,
      body: {
        'createdby': m.username,
        '_id': r.id_,
        'description': _controller2.text.trim(),
      },
    );
    return response.statusCode;
  }

  Future<int> _addMembers(ChatRoom r, MyData m, String username) async {
    var url = Uri.parse(ip + '/app/addMembers');
    var response = await http.post(
      url,
      body: {
        'createdby': m.username,
        '_id': r.id_,
        'members': username,
      },
    );
    return response.statusCode;
  }

  Future<int> _editDp(ChatRoom r, MyData m, XFile file) async {
    File image = File(file.path);
    List<int> imageBytes = image.readAsBytesSync();
    String dp = base64.encode(imageBytes);

    var url = Uri.parse(ip + '/app/editDp');
    var response = await http.post(
      url,
      body: {
        'createdby': m.username,
        '_id': r.id_,
        'dp': dp,
      },
    );
    return response.statusCode;
  }

  Future<int> _editGroupName(ChatRoom r, MyData m) async {
    var url = Uri.parse(ip + '/app/editGroupName');
    var response = await http.post(
      url,
      body: {
        'createdby': m.username,
        '_id': r.id_,
        'name': _controller1.text.trim(),
      },
    );
    return response.statusCode;
  }

  Future<int> _removeMember(ChatRoom r, MyData m, String username) async {
    var url = Uri.parse(ip + '/app/removeMember');
    var response = await http.post(
      url,
      body: {
        'createdby': m.username,
        '_id': r.id_,
        'username': username,
      },
    );
    return response.statusCode;
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
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
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
    final List<User> users = [];

    for (var item in room.members) {
      for (var i = 0; i < user_.getUsers.length; i++) {
        if (item == user_.getUsers[i].username) {
          users.add(user_.getUsers[i]);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Info'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 2), () async {
            var res = await _refreshChatroom(room);
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
                id: room.id,
                id_: room.id_,
                type: room.type,
                name: u['name'],
                createdby: u['createdby'],
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
                  onTap: () {
                    if (room.createdby == my.getMe.username) {
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return BottomSheet(
                            onClosing: () {},
                            builder: (ctx) {
                              return Column(
                                children: [
                                  const Text('Change room dp'),
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
                                      //if (picked != null) {
                                      if (await _editDp(
                                              room, my.getMe, picked!) ==
                                          200) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 2),
                                            content:
                                                Text('Sucessfully Updated.'),
                                          ),
                                        );
                                      } else {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 2),
                                            content:
                                                Text('Something went wrong.'),
                                          ),
                                        );
                                      }
                                      //}
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
                                      //if (picked != null) {
                                      if (await _editDp(
                                              room, my.getMe, picked!) ==
                                          200) {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 2),
                                            content:
                                                Text('Sucessfully Updated.'),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 2),
                                            content:
                                                Text('Something went wrong.'),
                                          ),
                                        );
                                      }
                                      //}
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: sp * 0.04,
                ),
                child: GestureDetector(
                  child: Text(
                    room.name,
                    style: TextStyle(
                      fontSize: sp * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: TextFormField(
                            key: _key1,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _controller1,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).iconTheme.color
                                      as Color,
                                ),
                              ),
                              hintText: ' Name',
                              hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                              ),
                            ),
                            validator: (value) {
                              if (value!.trim().length > 50) {
                                return 'Keep it inside 50 characters';
                              } else if (value.trim().isEmpty) {
                                return 'Enter some name';
                              } else {
                                return null;
                              }
                            },
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                if (_key1.currentState!.validate()) {
                                  if (await _editGroupName(room, my.getMe) ==
                                      200) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(seconds: 2),
                                        content: Text('Sucessfully Updated.'),
                                      ),
                                    );
                                  } else {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(seconds: 2),
                                        content: Text('Something went wrong.'),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
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
                itemCount: users.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(File(users[i].dp)),
                    ),
                    title: Text(users[i].name),
                    subtitle: Text(users[i].bio),
                    trailing: room.createdby == users[i].username
                        ? const Icon(Icons.add_moderator_sharp)
                        : null,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          ConversationScreen.routeName,
                          arguments: users[i]);
                    },
                    onLongPress: () {
                      if (room.createdby == my.getMe.username) {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text('Remove member!'),
                              content: Text(
                                  'Remove ' + users[i].name + ' from chatroom'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () async {
                                    if (await _removeMember(room, my.getMe,
                                            users[i].username) ==
                                        200) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          duration: Duration(seconds: 2),
                                          content: Text('User removed.'),
                                        ),
                                      );
                                    } else {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          duration: Duration(seconds: 2),
                                          content:
                                              Text('Something went wrong.'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.view_quilt_sharp),
                title: const Text('Description'),
                subtitle: Text(room.description),
                trailing: room.createdby == my.getMe.username
                    ? IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: TextFormField(
                                  key: _key2,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _controller2,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).iconTheme.color
                                            as Color,
                                      ),
                                    ),
                                    hintText: ' Description',
                                    hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.trim().length < 10) {
                                      return 'Enter atleast 10 characters';
                                    } else if (value.trim().length > 100) {
                                      return 'Keep it inside 100 characters';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () async {
                                      if (_key2.currentState!.validate()) {
                                        if (await _editDescription(
                                                room, my.getMe) ==
                                            200) {
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              duration: Duration(seconds: 2),
                                              content:
                                                  Text('Sucessfully Updated.'),
                                            ),
                                          );
                                        } else {
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              duration: Duration(seconds: 2),
                                              content:
                                                  Text('Something went wrong.'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    : const Padding(padding: EdgeInsets.zero),
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
              room.createdby == my.getMe.username
                  ? ListTile(
                      leading: const Icon(
                        Icons.add,
                      ),
                      title: const Text(
                        'Add members',
                      ),
                      subtitle: const Text(
                        'Add new members',
                      ),
                      contentPadding: EdgeInsets.only(
                        top: sp * 0.01,
                        left: sp * 0.03,
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            List<User> users_ = [];
                            return BottomSheet(
                                onClosing: () {},
                                builder: (ctx) {
                                  return Column(
                                    children: [
                                      const Text('Tap to add a member'),
                                      SizedBox(
                                        height: sp * 0.4,
                                        child: ListView.builder(
                                          itemCount: users_.length,
                                          itemBuilder: (ctx, i) {
                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: FileImage(
                                                    File(users_[i].dp)),
                                              ),
                                              title: Text(users_[i].name),
                                              subtitle:
                                                  Text(users_[i].username),
                                              onTap: () async {
                                                if (await _addMembers(
                                                        room,
                                                        my.getMe,
                                                        users_[i].username) ==
                                                    200) {
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context)
                                                      .clearSnackBars();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      duration:
                                                          Duration(seconds: 2),
                                                      content: Text(
                                                          'Succesfully added.'),
                                                    ),
                                                  );
                                                } else {
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context)
                                                      .clearSnackBars();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      duration:
                                                          Duration(seconds: 2),
                                                      content: Text(
                                                          'Something went wrong.'),
                                                    ),
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                        );
                      },
                    )
                  : const Padding(padding: EdgeInsets.zero),
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
