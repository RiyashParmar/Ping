// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/mydata.dart';
import '../main.dart';

String ip = 'http://192.168.43.62:3000';
//String ip = 'http://10.0.2.2:3000';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final mydata = Provider.of<My>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    MyData my = mydata.getMe;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return EditProfile(me: my);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 2), () {
            setState(() {});
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: sp * 0.04,
                  bottom: sp * 0.02,
                ),
                child: GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: FileImage(File(my.dp)),
                    radius: sp * 0.09,
                  ),
                ),
              ),
              ListTile(
                leading: Text(
                  'Profile Name :',
                  style: TextStyle(fontSize: sp * 0.025),
                ),
                title: Text(
                  my.name,
                  style: TextStyle(fontSize: sp * 0.025),
                ),
              ),
              ListTile(
                leading: Text(
                  'Username :',
                  style: TextStyle(fontSize: sp * 0.025),
                ),
                title: Text(
                  my.username,
                  style: TextStyle(fontSize: sp * 0.025),
                ),
              ),
              ListTile(
                leading: Text(
                  'Phone Number :',
                  style: TextStyle(fontSize: sp * 0.025),
                ),
                title: Text(
                  my.number,
                  style: TextStyle(fontSize: sp * 0.025),
                ),
              ),
              ListTile(
                leading: Text(
                  'Bio :',
                  style: TextStyle(fontSize: sp * 0.025),
                ),
                title: Text(
                  my.bio,
                  maxLines: 5,
                  style: TextStyle(fontSize: sp * 0.025),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.me}) : super(key: key);
  final MyData me;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late final TextEditingController _controller1;
  late final TextEditingController _controller2;
  late final TextEditingController _controller3;
  late final TextEditingController _controller4;
  late final TextEditingController _controller5;
  late final TextEditingController _controller6;
  late final TextEditingController _controller7;

  final _formKey = GlobalKey<FormState>();
  String code = '91';

  XFile? dp;
  bool confirm = true;

  var _username;
  var _number;

  bool change() {
    return widget.me.dp == _controller1.text.trim() &&
        widget.me.name == _controller2.text.trim() &&
        widget.me.username == _controller3.text.trim() &&
        widget.me.number == _controller4.text.trim() &&
        widget.me.bio == _controller5.text.trim();
  }

  Future<http.Response> _editInfo() async {
    String dp = '';
    if (!(widget.me.dp == _controller1.text.trim())) {
      File image = File(_controller1.text.trim());
      List<int> imageBytes = image.readAsBytesSync();
      dp = base64.encode(imageBytes);
    }

    var url = Uri.parse(ip + '/app/editInfo');
    var response = await http.post(
      url,
      body: {
        'key': widget.me.username,
        'dp': widget.me.dp == _controller1.text.trim() ? 'null' : dp,
        'name': widget.me.name == _controller2.text.trim()
            ? 'null'
            : _controller2.text.trim(),
        'username': widget.me.username == _controller3.text.trim()
            ? 'null'
            : _controller3.text.trim(),
        'number': widget.me.number == '+' + code + _controller4.text.trim()
            ? 'null'
            : '+' + code + _controller4.text.trim(),
        'bio': widget.me.bio == _controller5.text.trim()
            ? 'null'
            : _controller5.text.trim(),
      },
    );
    return response;
  }

  Future<http.Response> _confirmInfo(_username, _number) async {
    var url = Uri.parse(ip + '/app/confirmInfo');
    var response = await http.post(
      url,
      body: {
        'key': widget.me.username,
        'username': _username == List ? _controller6.text : 'null',
        'otp': _number == 'Successfully changed'
            ? _controller7.text.trim()
            : 'null',
        'number': '+' + code + _controller4.text.trim(),
      },
    );
    return response;
  }

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _controller4 = TextEditingController();
    _controller5 = TextEditingController();
    _controller6 = TextEditingController();
    _controller7 = TextEditingController();

    _controller1.text = widget.me.dp;
    _controller2.text = widget.me.name;
    _controller3.text = widget.me.username;
    _controller4.text = widget.me.number.substring(3);
    _controller5.text = widget.me.bio;
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    _controller7.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mydata = Provider.of<My>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Details'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: confirm
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: sp * 0.02,
                        right: sp * 0.01,
                        left: sp * 0.01,
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _controller1,
                        keyboardType: TextInputType.name,
                        readOnly: true,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          hintText: 'Select a Display picture:',
                          hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2!.color,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please pick a display picture.';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: sp * 0.03,
                      ),
                      child: GestureDetector(
                        child: CircleAvatar(
                          backgroundImage: FileImage(File(_controller1.text)),
                          radius: sp * 0.09,
                        ),
                        onTap: () async {
                          final picker = ImagePicker();
                          dp = await picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            _controller1.text = dp != null ? dp!.path : '';
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: sp * 0.01,
                        left: sp * 0.01,
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _controller2,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).iconTheme.color as Color,
                            ),
                          ),
                          hintText: ' Full-Name',
                          hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2!.color,
                          ),
                        ),
                        validator: (value) {
                          var reg = RegExp(r'^[A-Za-z ]+$');
                          if (value!.trim().length < 6) {
                            return 'Too short!! Please enter your FULL REAL name 🥺';
                          } else if (value.trim().length > 70) {
                            return 'Too Long!! Please use a shorter version of your name 😅';
                          } else if (!reg.hasMatch(value.trim())) {
                            return 'Invalid format! Might as well follow the instructions 😏';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: sp * 0.01,
                        right: sp * 0.01,
                        left: sp * 0.01,
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _controller3,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).iconTheme.color as Color,
                            ),
                          ),
                          hintText: ' Username',
                          hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2!.color,
                          ),
                        ),
                        validator: (value) {
                          var reg = RegExp(
                              r'^[a-z0-9+_]+[a-z0-9+_+\-+.]*[^\s]\1*[a-z0-9+_]+$');
                          if (value!.trim().length < 3) {
                            return 'Too short!! Be more cool 😎';
                          } else if (value.trim().length > 30) {
                            return 'Too Long!! Not so much cool little less 😅';
                          } else if (!reg.hasMatch(value.trim())) {
                            return 'Invalid format! Might as well follow the instructions 😏';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: sp * 0.02,
                        right: sp * 0.01,
                        left: sp * 0.01,
                      ),
                      child: IntlPhoneField(
                        initialCountryCode: 'IN',
                        controller: _controller4,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).iconTheme.color as Color,
                            ),
                          ),
                          hintText: 'Phone-Number',
                          hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2!.color,
                          ),
                        ),
                        onCountryChanged: (cn) {
                          code = cn.dialCode;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter your phone number 🙁';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: sp * 0.01,
                        right: sp * 0.01,
                        left: sp * 0.01,
                      ),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _controller5,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).iconTheme.color as Color,
                            ),
                          ),
                          hintText: ' Bio',
                          hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2!.color,
                          ),
                        ),
                        validator: (value) {
                          if (value!.trim().length < 10) {
                            return 'Too short!! COMEON your more than that 😁';
                          } else if (value.trim().length > 120) {
                            return 'Too Long!! Please hold-on your inner writer 😅';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: sp * 0.01,
                        right: sp * 0.01,
                        left: sp * 0.01,
                        bottom: sp * 0.01,
                      ),
                      child: ElevatedButton(
                        child: const Text('CONFIRM'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (!change()) {
                              var res = await _editInfo();
                              if (res.statusCode == 500) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text(
                                      'Something went wrong please try again!!',
                                    ),
                                  ),
                                );
                              } else {
                                var _dp = json.decode(res.body)['dp'];
                                var _name = json.decode(res.body)['name'];
                                _username = json.decode(res.body)['username'];
                                _number = json.decode(res.body)['number'];
                                var _bio = json.decode(res.body)['bio'];

                                MyData a = MyData(
                                  id: widget.me.id,
                                  username: _username == 'Successfully changed'
                                      ? _controller3.text
                                      : widget.me.username,
                                  name: _name == 'Successfully changed'
                                      ? _controller2.text
                                      : widget.me.name,
                                  number: widget.me.number,
                                  dp: _dp == 'Successfully changed'
                                      ? _controller1.text
                                      : widget.me.dp,
                                  bio: _bio == 'Successfully changed'
                                      ? _controller5.text
                                      : widget.me.bio,
                                  moments: widget.me.moments,
                                );
                                db.myTb.put(a);
                                mydata.init();

                                String dp_ =
                                    _dp != 'null' ? '| Dp: ' + _dp : '';
                                String name_ =
                                    _name != 'null' ? '| Name: ' + _name : '';
                                String bio_ =
                                    _bio != 'null' ? '| Bio: ' + _bio : '';
                                String username_ =
                                    _username == 'Successfully changed'
                                        ? '| Username: ' + _username
                                        : _username == 'Please try again'
                                            ? '| Username: ' + _username
                                            : '';
                                String number_ =
                                    _number != 'Successfully changed'
                                        ? _number != 'null'
                                            ? '| Number: ' + _number
                                            : ''
                                        : '';
                                String result =
                                    dp_ + name_ + bio_ + username_ + number_;

                                ScaffoldMessenger.of(context).clearSnackBars();
                                result != ''
                                    ? ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 5),
                                          content: Text(
                                            result,
                                          ),
                                        ),
                                      )
                                    : null;

                                _username == List ||
                                        _number == 'Successfully changed'
                                    ? setState(() {
                                        confirm = false;
                                      })
                                    : Navigator.of(context).pop();
                              }
                            } else {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 5),
                                  content: Text(
                                    'Saved.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _username == List
                        ? const Text(
                            'Username unavailable. Suggestions you might consider')
                        : const Padding(padding: EdgeInsets.zero),
                    _username == List
                        ? TextFormField(
                            controller: _controller6,
                            readOnly: true,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).iconTheme.color
                                      as Color,
                                ),
                              ),
                              hintText: ' Username',
                              hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                              ),
                            ),
                          )
                        : const Padding(padding: EdgeInsets.zero),
                    _username == List
                        ? ListView.builder(
                            itemCount: _username.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                title: Text(_username[i]),
                                onTap: () {
                                  _controller6.text = _username[i];
                                },
                              );
                            })
                        : const Padding(padding: EdgeInsets.zero),
                    _number == 'Successfully changed'
                        ? TextFormField(
                            controller: _controller7,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).iconTheme.color
                                      as Color,
                                ),
                              ),
                              hintText: ' Confirm otp',
                              hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                              ),
                            ),
                          )
                        : const Padding(padding: EdgeInsets.zero),
                    ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: () async {
                        var res = await _confirmInfo(_username, _number);
                        if (res.statusCode == 200) {
                          var no = json.decode(res.body)['number'];
                          var username = json.decode(res.body)['username'];
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 5),
                              content: Text(
                                no != 'null'
                                    ? '| Number: ' + no
                                    : '' + username != 'null'
                                        ? '| Username: ' + username
                                        : '',
                              ),
                            ),
                          );
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(seconds: 5),
                              content: Text(
                                'Something went wrong please try again',
                              ),
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
