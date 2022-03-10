// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ping/models/chatroom.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/mydata.dart';

class Menu extends StatelessWidget {
  const Menu({
    Key? key,
    required this.grp,
    required this.room,
    required this.my,
    required this.change,
    required this.update,
  }) : super(key: key);
  final ChatRoom grp;
  final ChatRooms room;
  final My my;
  final change;
  final update;

  void bg() async {
    var key = await SharedPreferences.getInstance();
    var pickedimage = await FilePicker.platform.pickFiles(type: FileType.image);
    if (pickedimage != null) {
      key.setString('Conversation-Bg', pickedimage.files[0].path as String);
      my.bgImg = key.getString('Conversation-Bg') ?? '';
      change(my.bgImg);
    }
  }

  static const platform = MethodChannel('flutter.nik/pinnedshortcuts');

  Future<String> _createShortcut() async {
    // ignore: unused_local_variable
    String result;
    try {
      final String _result =
          await platform.invokeMethod('createPinnedShortcut');
      return result = _result;
    } on PlatformException catch (e) {
      return result = "Failed to get battery level: '${e.message}'.";
    }
    //print(result);
  }

  void mute() {}

  void clear() {
    room.clearRoomMsg(grp);
    update();
  }

  @override
  Widget build(BuildContext context) {
    void dialog(String a, String b, void Function() work) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$a ${grp.name}?!!'),
            content: Text('$a chatroom'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  work();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Text(b),
                    ),
                  );
                },
                child: Text(a.toUpperCase()),
              ),
            ],
          );
        },
      );
    }

    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert_sharp,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        /*const PopupMenuItem<int>(
          value: 0,
          child: Text(
            'Report',
          ),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Text(
            'Block',
          ),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Text(
            'Clear msgs',
          ),
        ),*/
        const PopupMenuItem<int>(
          value: 2,
          child: Text(
            'Mute',
          ),
        ),
        /*const PopupMenuItem<int>(
          value: 3,
          child: Text(
            'Add Shortcut',
          ),
        ),
        const PopupMenuItem<int>(
          value: 4,
          child: Text(
            'Shared Data',
          ),
        ),*/
        const PopupMenuItem<int>(
          value: 5,
          child: Text(
            'Edit Background',
          ),
        ),
      ],
      onSelected: (int result) {
        switch (result) {
          case 0:
            //dialog('Report', 'Reported we will look into it');
            break;
          case 1:
            dialog(
              'Clear',
              'Message has been cleared.',
              clear,
            );
            break;
          case 2:
            dialog('Mute', 'The User has been Muted', mute);
            break;
          case 3:
            _createShortcut();
            break;
          case 4:
            //Navigator.of(context)
            //  .pushNamed(SharedDataScreen.routeName, arguments: user);
            break;
          case 5:
            bg();
            break;
          default:
            Navigator.of(context).pop();
            break;
        }
      },
    );
  }
}
