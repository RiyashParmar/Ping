import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ping/models/mydata.dart';
//import 'package:google_ml_kit/google_ml_kit.dart';

import '../main.dart' as m;
import '../HomeScreen/homescreen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const routeName = '/Register';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _controller1;
  late final TextEditingController _controller2;
  late final TextEditingController _controller3;
  late final TextEditingController _controller4;

  final _formKey = GlobalKey<FormState>();

  DateTime date = DateTime.now();
  String code = '91';
  // ignore: avoid_init_to_null
  var dp = null;

  Future<int> _confirmNumber() async {
    var url = Uri.parse(m.ip + 'register/sendOtp');
    var response = await http.post(
      url,
      body: {'number': '+' + code + _controller2.text.trim()},
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
                padding: EdgeInsets.all(sp * 0.01),
                child: Text(
                  'PING',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: sp * 0.05,
                  ),
                ),
              ),
              Container(
                //height: sp * 0.62,
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
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
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
                            child: dp == null
                                ? CircleAvatar(
                                    child: Icon(
                                      Icons.person,
                                      size: sp * 0.09,
                                    ),
                                    radius: sp * 0.09,
                                  )
                                : CircleAvatar(
                                    backgroundImage: FileImage(File(dp.path)),
                                    radius: sp * 0.09,
                                  ),
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
                                              dp = await picker.pickImage(
                                                  source: ImageSource.camera);
                                              setState(() {
                                                _controller1.text =
                                                    dp != null ? dp.path : '';
                                              });
                                            },
                                          ),
                                          ListTile(
                                            leading:
                                                const Icon(Icons.library_add),
                                            title:
                                                const Text('Pick from gallery'),
                                            onTap: () async {
                                              dp = await picker.pickImage(
                                                  source: ImageSource.gallery);
                                              setState(() {
                                                _controller1.text =
                                                    dp != null ? dp.path : '';
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
                            controller: _controller2,
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
                            controller: _controller3,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).iconTheme.color
                                      as Color,
                                ),
                              ),
                              hintText: ' Full-Name',
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
                          child: const Text('Only Alphabetic characters'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: sp * 0.01,
                            right: sp * 0.01,
                            left: sp * 0.01,
                          ),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _controller4,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).iconTheme.color
                                      as Color,
                                ),
                              ),
                              hintText: ' Describe yourself',
                              hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .color,
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
                            bottom: sp * 0.01,
                          ),
                          child: ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var res = await _confirmNumber();
                                if (res == 200) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => ConfirmId(
                                        dp: _controller1.text,
                                        number: '+' + code + _controller2.text,
                                        name: _controller3.text,
                                        bio: _controller4.text,
                                      ),
                                    ),
                                  );
                                } else if (res == 404) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text(
                                        'Number already registered.',
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
                                        'Something went wrong please try again!!',
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

class ConfirmId extends StatefulWidget {
  const ConfirmId({
    Key? key,
    required this.dp,
    required this.number,
    required this.name,
    required this.bio,
  }) : super(key: key);
  final String dp;
  final String number;
  final String name;
  final String bio;
  @override
  ConfirmIdstate createState() => ConfirmIdstate();
}

class ConfirmIdstate extends State<ConfirmId> {
  late final TextEditingController _controller1;
  late final TextEditingController _controller2;
  late final TextEditingController _controller3;

  final _formKey = GlobalKey<FormState>();

  bool otp = false;
  bool username = false;
  bool loginkey = false;

  Future<int> _confirmOtp() async {
    var url = Uri.parse(m.ip + 'register/confirmOtp');
    var response = await http.post(
      url,
      body: {'otp': _controller1.text.trim(), 'number': widget.number.trim()},
    );
    return response.statusCode;
  }

  Future<http.Response> _checkUsername() async {
    var url = Uri.parse(m.ip + 'register/checkUsername');
    var response = await http.post(
      url,
      body: {'username': _controller2.text.trim()},
    );
    return response;
  }

  Future<http.Response> _checkLoginkey() async {
    var url = Uri.parse(m.ip + 'register/checkLoginkey');
    var response = await http.post(
      url,
      body: {'loginkey': _controller3.text.trim()},
    );
    return response;
  }

  Future<http.Response> _registerUser() async {
    File image = File(widget.dp);
    List<int> imageBytes = image.readAsBytesSync();
    String dp = base64.encode(imageBytes);

    var url = Uri.parse(m.ip + 'register/registerNewUser');
    var response = await http.post(
      url,
      body: {
        'loginkey': _controller3.text.trim(),
        'name': widget.name.trim(),
        'username': _controller2.text.trim(),
        'number': widget.number.trim(),
        'face_struct': 'nan',
        'dp': dp,
        'bio': widget.bio.trim(),
      },
    );
    return response;
  }

  Future<void> _requestPermission() async {
    await [
      Permission.locationWhenInUse,
      Permission.microphone,
      Permission.contacts,
      Permission.storage,
    ].request();
  }

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
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
                padding: EdgeInsets.all(sp * 0.01),
                child: Text(
                  'PING',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: sp * 0.05,
                  ),
                ),
              ),
              Container(
                //height: sp * 0.49,
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
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _controller1,
                            readOnly: otp,
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
                          ),
                        ),
                        otp
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: sp * 0.01,
                                  right: sp * 0.01,
                                  left: sp * 0.01,
                                ),
                                child: TextFormField(
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
                                    hintText: ' Username',
                                    hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color,
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
                                  onChanged: (value) {
                                    if (username) {
                                      setState(() {
                                        username = false;
                                      });
                                    }
                                  },
                                ),
                              )
                            : const Padding(padding: EdgeInsets.zero),
                        otp
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: sp * 0.01,
                                  right: sp * 0.01,
                                  left: sp * 0.01,
                                ),
                                child: const Text(
                                  'Should be a 3-30 characters combination of lowercase Alphanumeric, Symbols( _ , - , . ) with no whitespaces and should start with Alphanumeric or Underscore',
                                ),
                              )
                            : const Padding(padding: EdgeInsets.zero),
                        username
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: sp * 0.01,
                                  right: sp * 0.01,
                                  left: sp * 0.01,
                                ),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _controller3,
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
                                    if (!loginkey) {
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
                                    if (loginkey) {
                                      setState(() {
                                        loginkey = false;
                                      });
                                    }
                                  },
                                ),
                              )
                            : const Padding(padding: EdgeInsets.zero),
                        username
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
                            right: sp * 0.01,
                            left: sp * 0.01,
                            bottom: sp * 0.01,
                          ),
                          child: ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () async {
                              if (otp && username && loginkey) {
                                if (_formKey.currentState!.validate()) {
                                  var res = await _registerUser();
                                  if (res.statusCode == 200) {
                                    var key =
                                        await SharedPreferences.getInstance();
                                    key.setBool('Login', true);
                                    await _requestPermission();
                                    final mydata = MyData(
                                      username: _controller2.text,
                                      name: widget.name,
                                      number: widget.number,
                                      dp: widget.dp,
                                      bio: widget.bio,
                                      moments: [],
                                    );
                                    m.db.myTb.put(mydata);
                                    /*Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: ((context) {
                                          return const FaceAuth();
                                        }),
                                      ),
                                    );*/
                                    Navigator.of(context).pushReplacementNamed(
                                        HomeScreen.routename);
                                  } else {
                                    Navigator.of(context).pop();
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
                                }
                              } else if (!otp) {
                                var res = await _confirmOtp();
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
                                        'Inncorrect otp please try again.',
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
                                        'Something went wrong please try again!',
                                      ),
                                    ),
                                  );
                                }
                              } else if (!username) {
                                if (_formKey.currentState!.validate()) {
                                  var res = await _checkUsername();
                                  if (res.statusCode == 200) {
                                    setState(() {
                                      username = true;
                                    });
                                  } else if (res.statusCode == 404) {
                                    var suggestions =
                                        json.decode(res.body)["suggestions"]
                                            as List;
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
                                                    _controller2.text =
                                                        suggestions[i];
                                                    username = true;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            });
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
                                }
                              } else {
                                if (_formKey.currentState!.validate()) {
                                  var res = await _checkLoginkey();
                                  if (res.statusCode == 200) {
                                    var suggestions =
                                        json.decode(res.body)["suggestions"]
                                            as List;
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
                                                    _controller3.text =
                                                        suggestions[i];
                                                    loginkey = true;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            });
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

/*class FaceAuth extends StatefulWidget {
  const FaceAuth({Key? key}) : super(key: key);
  @override
  _FaceAuthState createState() => _FaceAuthState();
}

class _FaceAuthState extends State<FaceAuth> {
  bool faceid = false;

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
                padding: EdgeInsets.all(sp * 0.01),
                child: Text(
                  'PING',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: sp * 0.05,
                  ),
                ),
              ),
              Container(
                //height: ,
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
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: sp * 0.02,
                          right: sp * 0.01,
                          left: sp * 0.01,
                        ),
                        child: const Text(
                            'Register FaceId as 2-Factor-Authentication'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: sp * 0.03,
                        ),
                        child: GestureDetector(
                          child: faceid
                              ? CircleAvatar(
                                  child: Icon(
                                    Icons.check,
                                    size: sp * 0.09,
                                  ),
                                  radius: sp * 0.09,
                                )
                              : CircleAvatar(
                                  child: Icon(
                                    Icons.face,
                                    size: sp * 0.09,
                                  ),
                                  radius: sp * 0.09,
                                ),
                          onTap: () async {},
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
                          child:
                              faceid ? const Text('DONE') : const Text('SKIP'),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(HomeScreen.routename);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
