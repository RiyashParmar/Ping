import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class Notification extends StatefulWidget {
  const Notification({Key? key}) : super(key: key);
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
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
        title: const Text('Notification'),
      ),
      body: SingleChildScrollView(
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
              subtitle:
                  const Text('Show message preview at the top of the screen'),
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
      ),
    );
  }
}
