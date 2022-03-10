// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../ChatRoomScreen/chatroomscreen.dart';
import '../HomeScreen/homescreen.dart';
import '../models/mydata.dart';
import '../models/chatroom.dart';
import '../main.dart';

String ip = 'http://192.168.43.62:3000';
//String ip = 'http://10.0.2.2:3000';

class Broadcast extends StatefulWidget {
  const Broadcast({Key? key, required this.user}) : super(key: key);
  final List user;
  @override
  State<Broadcast> createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  late final TextEditingController _controller1;
  late final TextEditingController _controller2;

  final GlobalKey<FormState> _formkey = GlobalKey();
  String dp = '';
  var image;

  Future<http.Response> _createBroadcast(user, members) async {
    File image = File(dp);
    List<int> imageBytes = image.readAsBytesSync();
    String _dp = base64.encode(imageBytes);

    var url = Uri.parse(ip + '/app/createChatroom');
    var response = await http.post(
      url,
      body: {
        'name': _controller1.text.trim(),
        'type': 'broadcast',
        'createdby': user.username,
        'members': json.encode(members),
        'description': _controller2.text.trim(),
        'dp': _dp,
      },
    );
    return response;
  }

  List<String> members(List<dynamic> users) {
    List<String> members = [];
    for (var item in users) {
      members.add(item.username);
    }
    return members;
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
    final my = Provider.of<My>(context);
    final chatroom = Provider.of<ChatRooms>(context, listen: false);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final MyData me = my.getMe;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('New Broadcast'),
            Text(
              'Enter details',
              style: TextStyle(
                fontSize: sp * 0.017,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: media.size.width,
                height: sp * 0.25,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(sp * 0.02),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return BottomSheet(
                                    onClosing: () {},
                                    builder: (context) {
                                      final picker = ImagePicker();
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading:
                                                const Icon(Icons.camera_alt),
                                            title: const Text('Take a picture'),
                                            onTap: () async {
                                              image = await picker.pickImage(
                                                  source: ImageSource.gallery);
                                              setState(() {
                                                dp = image != null
                                                    ? image.path
                                                    : '';
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.library_add),
                                            title:
                                                const Text('Pick from gallery'),
                                            onTap: () async {
                                              image = await picker.pickImage(
                                                  source: ImageSource.gallery);
                                              setState(() {
                                                dp = image != null
                                                    ? image.path
                                                    : '';
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
                            child: dp == ''
                                ? CircleAvatar(
                                    radius: sp * 0.035,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: sp * 0.035,
                                    backgroundImage: FileImage(File(dp)),
                                  ),
                          ),
                          SizedBox(width: sp * 0.03),
                          SizedBox(
                            width: sp * 0.35,
                            child: TextFormField(
                              controller: _controller1,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).iconTheme.color
                                          as Color),
                                ),
                                label: const Text('Broadcast Name'),
                              ),
                              validator: (value) {
                                if (value!.trim().length > 50) {
                                  return 'Keep it inside 50 characters';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: sp * 0.03,
                        top: sp * 0.005,
                      ),
                      child: TextFormField(
                        controller: _controller2,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color),
                          ),
                          label: const Text(
                            'Description',
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: sp * 0.03,
                        top: sp * 0.02,
                      ),
                      child: Row(
                        children: const [
                          Text('Give a broadcast name, image, description'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: sp * 0.002),
              Text(
                'Selected:- ${widget.user.length} (Tap to remove)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: media.size.width,
                height: (sp * 0.6) - MediaQuery.of(context).viewInsets.bottom,
                child: Padding(
                  padding: EdgeInsets.all(sp * 0.008),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: widget.user.length,
                    itemBuilder: (ctx, i) {
                      return GridTile(
                        child: SizedBox(
                          width: sp * 0.2,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.user.removeAt(i);
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      FileImage(File(widget.user[i].dp)),
                                  radius: sp * 0.03,
                                ),
                              ),
                              SizedBox(height: sp * 0.01),
                              Text(
                                widget.user[i].name,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.user.isNotEmpty && dp != ''
          ? FloatingActionButton(
              child: const Icon(Icons.check),
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  var res = await _createBroadcast(me, members(widget.user));
                  var id = json.decode(res.body)['id'];
                  if (res.statusCode == 200) {
                    ChatRoom brdcast = ChatRoom(
                      id_: id,
                      name: _controller1.text.trim(),
                      type: 'broadcast',
                      dp: dp,
                      description: _controller2.text.trim(),
                      members: members(widget.user),
                      msgs: [],
                    );
                    db.chatroomTb.put(brdcast);
                    chatroom.addRoom(brdcast);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        ChatRoomScreen.routeName,
                        ModalRoute.withName(HomeScreen.routename),
                        arguments: brdcast);
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text(
                          'Something went wrong please type again!!',
                        ),
                      ),
                    );
                  }
                }
              },
            )
          : null,
    );
  }
}
