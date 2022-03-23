import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
//import '../models/chatroom.dart';
import '../main.dart';

//import 'shareddatascreen.dart';

String ip = 'http://192.168.43.62:3000';
//String ip = 'http://10.0.2.2:3000';

class ConversationDetailScreen extends StatefulWidget {
  const ConversationDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/ConversationDetail';
  @override
  State<ConversationDetailScreen> createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  bool noti = true;

  Future<http.Response> _updateUser(User user) async {
    var url = Uri.parse(ip + '/app/updateUser');
    var response = await http.post(
      url,
      body: {
        'username': user.username,
        'number': user.number,
      },
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users>(context);
    //final room = Provider.of<ChatRooms>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final User user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 2), () async {
            var res = await _updateUser(user);
            if (res.statusCode == 200) {
              var u = json.decode(res.body)['user'];
              var buffer = base64.decode(u['dp']);
              final dir = await getExternalStorageDirectory();
              final image = File(dir!.path + '/dp.jpg');
              image.writeAsBytesSync(buffer);

              User _user = User(
                id: user.id,
                username: u['username'],
                name: u['name'],
                number: u['number'],
                dp: dir.path + '/dp.jpg',
                bio: u['bio'],
                msgs: user.msgs,
                moments: user.moments,
              );
              db.userTb.put(_user);
              users.refreshUser(_user);
              setState(() {});
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
            children: [
              Padding(
                padding: EdgeInsets.only(top: sp * 0.06),
                child: GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: FileImage(File(user.dp)),
                    radius: sp * 0.13,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: sp * 0.04,
                ),
                child: Text(
                  user.name,
                  style: TextStyle(
                    fontSize: sp * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: sp * 0.005,
                  bottom: sp * 0.03,
                ),
                child: Text(
                  user.number,
                  style: TextStyle(
                    fontSize: sp * 0.025,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.view_quilt_sharp),
                title: const Text('Bio'),
                subtitle: Text(user.bio),
                contentPadding: EdgeInsets.only(
                  top: sp * 0.01,
                  left: sp * 0.03,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Bio'),
                        content: Text(user.bio),
                      );
                    },
                  );
                },
              ),
              /*ListTile(
                leading: const Icon(Icons.data_usage),
                title: const Text('Shared Data'),
                subtitle: const Text('Documents, Media, Others'),
                contentPadding: EdgeInsets.only(
                  top: sp * 0.01,
                  left: sp * 0.03,
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  SharedDataScreen.routeName,
                  arguments: user.name,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Saved Txt\'s'),
                subtitle:
                    const Text('All the saved texts from the conversation'),
                contentPadding: EdgeInsets.only(
                  top: sp * 0.01,
                  left: sp * 0.03,
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const SavedMsg(),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  noti ? Icons.notifications_active : Icons.notifications_off,
                ),
                title: const Text('Custom Notification'),
                subtitle: const Text('Tap to customize'),
                trailing: GestureDetector(
                  child: Icon(
                    noti ? Icons.toggle_on : Icons.toggle_off,
                    size: sp * 0.07,
                    color: noti
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).iconTheme.color,
                  ),
                  onTap: () {
                    setState(() {
                      noti = !noti;
                    });
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 3),
                        content: Text(
                          noti
                              ? 'Custom notifications are ON!'
                              : 'Custom notifications are OFF!',
                        ),
                      ),
                    );
                  },
                ),
                contentPadding: EdgeInsets.only(
                  top: sp * 0.01,
                  left: sp * 0.03,
                ),
                onTap: () {
                  noti
                      ? Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const CustomNotification(),
                          ),
                        )
                      : null;
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.report,
                  color: Colors.red,
                ),
                title: Text(
                  'Report ${user.name}',
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
                        title: Text('Report ${user.name}'),
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
                                      Text('${user.name} has been reported.'),
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
                  'Block ${user.name}',
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
                        title: Text('Block ${user.name}'),
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
                                      Text('${user.name} has been blocked.'),
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
                  'Delete Conversation',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: const Text(
                  'Delete the whole conversation',
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
                        title: Text('Delete ${user.name}'),
                        content: const Text('Delete the conversation'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            child: const Text('DELETE'),
                            onPressed: () {
                              users.clearUserMsg(user);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: Text('DELETED'),
                                ),
                              );
                              Navigator.of(context).pop();
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

class SavedMsg extends StatelessWidget {
  const SavedMsg({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Txt\'s'),
      ),
      body: Column(
        children: const [],
      ),
    );
  }
}

class CustomNotification extends StatefulWidget {
  const CustomNotification({Key? key}) : super(key: key);

  @override
  _CustomNotificationState createState() => _CustomNotificationState();
}

class _CustomNotificationState extends State<CustomNotification> {
  bool enabled = false;
  bool popup = true;
  bool vibrate = true;
  bool preview = true;
  String light = 'White';

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Notification'),
        actions: [
          TextButton(
            child: Text(
              enabled ? 'ON' : 'OFF',
              style: TextStyle(color: Theme.of(context).iconTheme.color),
            ),
            onPressed: () {
              setState(() {
                enabled = !enabled;
              });
            },
          ),
        ],
      ),
      body: enabled
          ? SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications_active),
                    title: const Text('Notification Ringtone'),
                    subtitle: const Text('Default'),
                    contentPadding: EdgeInsets.only(
                      top: sp * 0.01,
                      left: sp * 0.03,
                    ),
                    onTap: () async {
                      await FilePicker.platform.pickFiles(type: FileType.audio);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.call),
                    title: const Text('Call Ringtone'),
                    subtitle: const Text('Default'),
                    contentPadding: EdgeInsets.only(
                      top: sp * 0.01,
                      left: sp * 0.03,
                    ),
                    onTap: () async {
                      await FilePicker.platform.pickFiles(type: FileType.audio);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lightbulb),
                    title: const Text('Notification-Light'),
                    subtitle: Text(light),
                    contentPadding: EdgeInsets.only(
                      top: sp * 0.01,
                      left: sp * 0.03,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RadioListTile(
                                      title: const Text('White'),
                                      value: 'White',
                                      groupValue: light,
                                      onChanged: (dynamic val) {
                                        setState(() {
                                          light = val;
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      title: const Text('Red'),
                                      value: 'Red',
                                      groupValue: light,
                                      onChanged: (dynamic val) {
                                        setState(() {
                                          light = val;
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      title: const Text('Yellow'),
                                      value: 'Yellow',
                                      groupValue: light,
                                      onChanged: (dynamic val) {
                                        setState(() {
                                          light = val;
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ).then(
                        (value) {
                          setState(() {});
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.vibration),
                    title: const Text('Vibrate'),
                    subtitle: const Text('Vibrate on notifications'),
                    trailing: Icon(
                      vibrate ? Icons.toggle_on : Icons.toggle_off,
                      size: sp * 0.07,
                      color: Theme.of(context).backgroundColor == Colors.black
                          ? vibrate
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).iconTheme.color
                          : vibrate
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).iconTheme.color,
                    ),
                    contentPadding: EdgeInsets.only(
                      top: sp * 0.01,
                      left: sp * 0.03,
                    ),
                    onTap: () {
                      setState(() {
                        vibrate = !vibrate;
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.workspaces),
                    title: const Text('Popups'),
                    subtitle: const Text('Show popups on notifications'),
                    trailing: Icon(
                      popup ? Icons.toggle_on : Icons.toggle_off,
                      size: sp * 0.07,
                      color: Theme.of(context).backgroundColor == Colors.black
                          ? popup
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).iconTheme.color
                          : popup
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).iconTheme.color,
                    ),
                    contentPadding: EdgeInsets.only(
                      top: sp * 0.01,
                      left: sp * 0.03,
                    ),
                    onTap: () {
                      setState(() {
                        popup = !popup;
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.preview),
                    title: const Text('Preview'),
                    subtitle: const Text(
                        'Show message preview at the top of the screen'),
                    trailing: Icon(
                      preview ? Icons.toggle_on : Icons.toggle_off,
                      size: sp * 0.07,
                      color: Theme.of(context).backgroundColor == Colors.black
                          ? preview
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).iconTheme.color
                          : preview
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).iconTheme.color,
                    ),
                    contentPadding: EdgeInsets.only(
                      top: sp * 0.01,
                      left: sp * 0.03,
                    ),
                    onTap: () {
                      setState(() {
                        preview = !preview;
                      });
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
