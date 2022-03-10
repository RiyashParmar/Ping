import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/mydata.dart';
import '../models/user.dart';
import '../models/chatroom.dart';

class Conversation extends StatefulWidget {
  const Conversation({Key? key}) : super(key: key);
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  String size = 'Medium';

  @override
  Widget build(BuildContext context) {
    final my = Provider.of<My>(context, listen: false);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.wallpaper),
              title: const Text('Wallpaper'),
              subtitle: const Text('Default Background'),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.03,
              ),
              onTap: () async {
                var key = await SharedPreferences.getInstance();
                var pickedimage =
                    await FilePicker.platform.pickFiles(type: FileType.image);
                if (pickedimage != null) {
                  key.setString(
                      'Conversation-Bg', pickedimage.files[0].path as String);
                  my.bgImg = key.getString('Conversation-Bg') ?? '';
                }
              },
            ),
            /*ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Backup'),
              subtitle: const Text('Save your important memories'),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.03,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const Backup(),
                ),
              ),
            ),*/
            ListTile(
              leading: const Icon(Icons.travel_explore_outlined),
              title: const Text('Options'),
              subtitle: const Text('Clear convos'),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.03,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const Options(),
                ),
              ),
            ),
            /*ListTile(
              leading: const Icon(Icons.font_download),
              title: const Text('Font size'),
              subtitle: Text(size),
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
                                title: const Text('Large'),
                                value: 'Large',
                                groupValue: size,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    size = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('Medium'),
                                value: 'Medium',
                                groupValue: size,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    size = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('Small'),
                                value: 'Small',
                                groupValue: size,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    size = val;
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
            ),*/
          ],
        ),
      ),
    );
  }
}

class Backup extends StatefulWidget {
  const Backup({Key? key}) : super(key: key);
  @override
  State<Backup> createState() => _BackupState();
}

class _BackupState extends State<Backup> {
  String bkup = 'Everything';
  String time = 'Never';
  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Backup to Phone'),
              subtitle: Text(bkup),
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
                                title: const Text('Everything'),
                                value: 'Everything',
                                groupValue: bkup,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    bkup = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('Exclude Media'),
                                value: 'Exclude Media',
                                groupValue: bkup,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    bkup = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('Exclude Videos'),
                                value: 'Exclude Videos',
                                groupValue: bkup,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    bkup = val;
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
              leading: const Icon(Icons.timelapse),
              title: const Text('Auto Backup'),
              subtitle: Text(time),
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
                                title: const Text('Never'),
                                value: 'Never',
                                groupValue: time,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    time = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('Every Sunday'),
                                value: 'Every Sunday',
                                groupValue: time,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    time = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('Every Month-End'),
                                value: 'Every Month-End',
                                groupValue: time,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    time = val;
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
              title: TextButton(
                child: Text(
                  'BACKUP NOW',
                  overflow: TextOverflow.clip,
                  style: TextStyle(color: Theme.of(context).iconTheme.color),
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                ),
                onPressed: () {},
              ),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.16,
                right: sp * 0.16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Options extends StatefulWidget {
  const Options({Key? key}) : super(key: key);
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  bool? a = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    final room = Provider.of<ChatRooms>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text('Export Conversations'),
              contentPadding: EdgeInsets.only(top: sp * 0.01, left: sp * 0.03),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: const Text('Clear all messages'),
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
                              Text(
                                'Clear all messages in conversations!?',
                                style: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                  fontSize: sp * 0.025,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(sp * 0.01)),
                              const Text(
                                  'These will delete all messages forever.'),
                              /*CheckboxListTile(
                                value: a[0],
                                onChanged: (val) {
                                  setState(() {
                                    a[0] = val;
                                  });
                                },
                                title: const Text('Clear all media'),
                              ),
                              CheckboxListTile(
                                value: a[1],
                                onChanged: (val) {
                                  setState(() {
                                    a[1] = val;
                                  });
                                },
                                title: const Text('Clear all fav messages'),
                              ),*/
                              ElevatedButton(
                                child: const Text('CLEAR'),
                                onPressed: () {
                                  user.clearMsgs();
                                  room.clearMsgs();
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text('CLEARED'),
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),*/
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Conversations'),
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
                              Text(
                                'Delete all conversations!?',
                                style: TextStyle(
                                  fontSize: sp * 0.025,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              /*CheckboxListTile(
                                value: a,
                                onChanged: (val) {
                                  setState(() {
                                    a = val;
                                  });
                                },
                                title:
                                    const Text('Delete all messages with them'),
                              ),*/
                              ElevatedButton(
                                onPressed: () {
                                  user.clearAll();
                                  room.clearAll();
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 2),
                                      content: Text('DELETED'),
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: const Text('DELETE'),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
