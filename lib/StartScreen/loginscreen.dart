import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../HomeScreen/homescreen.dart';
import '../models/chatroom.dart';
import '../models/mydata.dart';
import '../main.dart';

import 'registerscreen.dart';

String ip = 'http://192.168.43.62:3000';
//String ip = 'http://10.0.2.2:3000';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/Login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _controller1;
  late final TextEditingController _controller2;

  bool _validate = true;
  String code = '91';

  Future<void> _requestPermission() async {
    await [
      Permission.notification,
      Permission.locationWhenInUse,
      Permission.microphone,
      Permission.contacts,
      Permission.storage,
    ].request();
  }

  Future<http.Response> _loginAuth() async {
    var url = Uri.parse(ip + '/login');
    var response = await http.post(
      url,
      body: {
        'loginkey': _controller1.text.trim(),
        'number': '+' + code + _controller2.text.trim(),
      },
    );
    return response;
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
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(sp * 0.02),
                child: Text(
                  'PING',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: sp * 0.05,
                  ),
                ),
              ),
              Container(
                //height: sp * 0.31,
                width: sp * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(width: sp * 0.001),
                  borderRadius: BorderRadius.circular(sp * 0.02),
                  color: Theme.of(context).backgroundColor,
                ),
                child: Center(
                  child: Column(
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
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color,
                              ),
                            ),
                            hintText: '  Login-Key',
                            hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                            errorText: _validate ? null : 'Invalid',
                          ),
                          validator: (value) {
                            if (value!.trim().length < 8) {
                              return 'Invalid format!';
                            } else if (value.trim().length > 200) {
                              return 'Invalid format!';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: sp * 0.03,
                          right: sp * 0.01,
                          left: sp * 0.01,
                        ),
                        child: IntlPhoneField(
                          controller: _controller2,
                          initialCountryCode: 'IN',
                          autovalidateMode: AutovalidateMode.always,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color,
                              ),
                            ),
                            hintText: '  Registered-Number',
                            hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                            errorText: _validate ? null : 'Invalid',
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
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _validate = true;
                          });
                          var res = await _loginAuth();
                          if (res.statusCode == 200) {
                            var key = await SharedPreferences.getInstance();
                            key.setBool('Login', true);
                            var user = json.decode(res.body)['data'];
                            for (var item in user['chatrooms']) {
                              var buffer = base64.decode(item['dp']);
                              final dir = await getExternalStorageDirectory();
                              final image =
                                  File(dir!.path + '/' + item['_id'] + '.jpg');
                              image.writeAsBytesSync(buffer);

                              List<String> members = [];
                              for (var i in item['members']) {
                                members.add(i.toString());
                              }

                              ChatRoom room = ChatRoom(
                                id_: item['_id'],
                                name: item['name'],
                                type: item['type'],
                                createdby: item['createdby'],
                                dp: dir.path + '/' + item['_id'] + '.jpg',
                                description: item['description'],
                                members: members,
                                msgs: [],
                              );
                              db.chatroomTb.put(room);
                            }

                            var buffer = base64.decode(user['dp']);
                            final dir = await getExternalStorageDirectory();
                            final image = File(dir!.path + '/dp.jpg');
                            image.writeAsBytesSync(buffer);

                            final mydata = MyData(
                              username: user['username'],
                              name: user['name'],
                              number: user['number'],
                              dp: dir.path + '/dp.jpg',
                              bio: user['bio'],
                              moments: [],
                            );
                            db.myTb.put(mydata);
                            await _requestPermission();
                            Navigator.of(context)
                                .pushReplacementNamed(HomeScreen.routename);
                          } else if (res.statusCode == 404) {
                            setState(() {
                              _validate = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 5),
                                content: Text(
                                  'Something went wrong please try again.',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Login'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: sp * 0.01,
                          bottom: sp * 0.02,
                        ),
                        child: GestureDetector(
                          child: const Text('So you forget the key again?!😑'),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const Recovery(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: sp * 0.01,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RegisterScreen.routeName);
                  },
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Recovery extends StatefulWidget {
  const Recovery({Key? key}) : super(key: key);
  @override
  State<Recovery> createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  late TextEditingController _controller4;

  final _formKey = GlobalKey<FormState>();
  String code = '91';
  bool otp = false;
  bool key = false;
  bool done = false;

  Future<int> _confirmNumber() async {
    var url = Uri.parse(ip + '/login/confirmNumber');
    var response = await http.post(
      url,
      body: {
        'number': '+' + code + _controller1.text.trim(),
        'name': _controller2.text.trim(),
      },
    );
    return response.statusCode;
  }

  Future<int> _confirmOtp() async {
    var url = Uri.parse(ip + '/login/confirmOtp');
    var response = await http.post(
      url,
      body: {
        'number': '+' + code + _controller1.text,
        'otp': _controller3.text,
      },
    );
    return response.statusCode;
  }

  Future<http.Response> _checkLoginkey() async {
    var url = Uri.parse(ip + '/register/checkLoginkey');
    var response = await http.post(
      url,
      body: {'loginkey': _controller4.text},
    );
    return response;
  }

  Future<int> _changeLoginkey() async {
    var url = Uri.parse(ip + '/login/changeLoginkey');
    var response = await http.post(
      url,
      body: {
        'loginkey': _controller4.text,
        'number': '+' + code + _controller1.text
      },
    );
    return response.statusCode;
  }

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
    _controller4 = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.orientation == Orientation.portrait
        ? media.size.height
        : media.size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(sp * 0.02),
                child: Text(
                  'PING',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: sp * 0.05,
                  ),
                ),
              ),
              Container(
                //height: sp * 0.17,
                width: sp * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(width: sp * 0.001),
                  borderRadius: BorderRadius.circular(
                    sp * 0.02,
                  ),
                  boxShadow: const [BoxShadow(color: Colors.grey)],
                  color: Theme.of(context).backgroundColor,
                ),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: sp * 0.02,
                            right: sp * 0.01,
                            left: sp * 0.01,
                          ),
                          child: IntlPhoneField(
                            initialCountryCode: 'IN',
                            readOnly: otp,
                            controller: _controller1,
                            autovalidateMode: AutovalidateMode.always,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).iconTheme.color
                                      as Color,
                                ),
                              ),
                              hintText: 'Phone-Number',
                              hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
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
                            right: sp * 0.01,
                            left: sp * 0.01,
                          ),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _controller2,
                            readOnly: otp,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).iconTheme.color
                                      as Color,
                                ),
                              ),
                              hintText: ' Profile Name',
                              hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
                              ),
                            ),
                            validator: (value) {
                              var reg = RegExp(r'^[A-Za-z ]+$');
                              if (value!.trim().length < 6) {
                                return 'Invalid Name!';
                              } else if (value.trim().length > 70) {
                                return 'Invalid Name!';
                              } else if (!reg.hasMatch(value.trim())) {
                                return 'Invalid Name!';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        otp
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: sp * 0.02,
                                  right: sp * 0.01,
                                  left: sp * 0.01,
                                ),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _controller3,
                                  readOnly: key,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).iconTheme.color
                                            as Color,
                                      ),
                                    ),
                                    hintText: ' Confirm OTP',
                                    hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return 'Enter some data!';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              )
                            : const Padding(padding: EdgeInsets.zero),
                        key
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: sp * 0.01,
                                  right: sp * 0.01,
                                  left: sp * 0.01,
                                ),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _controller4,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).iconTheme.color
                                            as Color,
                                      ),
                                    ),
                                    hintText: ' Login-Key',
                                    hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (!done) {
                                      var reg = RegExp(r'^[a-z]+$');
                                      if (value!.trim().length < 8) {
                                        return 'Too short!! Not very strong you see 😏';
                                      } else if (value.trim().length > 200) {
                                        return 'Too Long!! Bet you will forget these 😂';
                                      } else if (!reg.hasMatch(value.trim())) {
                                        return 'Invalid format! Might as well follow the instructions 😏';
                                      } else {
                                        return null;
                                      }
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    if (done) {
                                      setState(() {
                                        done = false;
                                      });
                                    }
                                  },
                                ),
                              )
                            : const Padding(padding: EdgeInsets.zero),
                        key
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: sp * 0.01,
                                  right: sp * 0.01,
                                  left: sp * 0.01,
                                ),
                                child: const Text(
                                  'Enter a sentence of atleast 8 characters (Only lowercase alphabets without any space in between) and we will give you suggestions pick one from them.',
                                ),
                              )
                            : const Padding(padding: EdgeInsets.zero),
                        Padding(
                          padding: EdgeInsets.only(
                            top: sp * 0.01,
                            bottom: sp * 0.01,
                          ),
                          child: ElevatedButton(
                            child: const Text('CONFIRM'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  !otp &&
                                  !key &&
                                  !done) {
                                var res = await _confirmNumber();
                                if (res == 200) {
                                  setState(() {
                                    otp = true;
                                  });
                                } else if (res == 404) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text(
                                        'Wrong Credentials!',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text(
                                        'Something went wrong please try again.',
                                      ),
                                    ),
                                  );
                                }
                              } else if (_formKey.currentState!.validate() &&
                                  otp &&
                                  !key &&
                                  !done) {
                                var res = await _confirmOtp();
                                if (res == 200) {
                                  setState(() {
                                    key = true;
                                  });
                                } else if (res == 404) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text(
                                        'Wrong OTP!',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text(
                                        'Something went wrong please try again.',
                                      ),
                                    ),
                                  );
                                }
                              } else if (_formKey.currentState!.validate() &&
                                  otp &&
                                  key &&
                                  !done) {
                                var res = await _checkLoginkey();
                                if (res.statusCode == 200) {
                                  var suggestions = json
                                      .decode(res.body)["suggestions"] as List;
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return ListView.builder(
                                        itemCount: suggestions.length,
                                        itemBuilder: (context, i) {
                                          return ListTile(
                                            title: Text(suggestions[i]),
                                            onTap: () {
                                              setState(() {
                                                _controller4.text =
                                                    suggestions[i];
                                                done = true;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text(
                                        'Something went wrong please type again!!',
                                      ),
                                    ),
                                  );
                                }
                              } else if (_formKey.currentState!.validate() &&
                                  otp &&
                                  key &&
                                  done) {
                                if (await _changeLoginkey() == 200) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text(
                                        'Login-key changed succesfully.',
                                      ),
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
