// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import '../models/mydata.dart';

String ip = 'http://192.168.43.62:3000';
//String ip = 'http://10.0.2.2:3000';

class General extends StatefulWidget {
  const General({Key? key}) : super(key: key);
  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  Future<int> theme() async {
    var mode = await AdaptiveTheme.getThemeMode();
    if (mode == AdaptiveThemeMode.system) {
      return 0;
    } else if (mode == AdaptiveThemeMode.light) {
      return 1;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('General'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
                leading: const Icon(Icons.app_settings_alt_rounded),
                title: const Text('App'),
                contentPadding: EdgeInsets.only(
                  top: sp * 0.01,
                  left: sp * 0.03,
                ),
                onTap: () async {
                  var mode = await theme();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => App(mode_: mode),
                    ),
                  );
                }),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Security'),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.03,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const Security(),
                ),
              ),
            ),
            /*ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Privacy'),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.03,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const Privacy(),
                ),
              ),
            ),*/
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Delete my account'),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.03,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const Delete(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key, required this.mode_}) : super(key: key);
  final int mode_;
  @override
  State<App> createState() => _AppState();
}

enum mode { system, light, dark }

class _AppState extends State<App> {
  String lang = 'English(US)';
  var m;

  @override
  void initState() {
    super.initState();
    m = widget.mode_ == 0
        ? mode.system
        : widget.mode_ == 1
            ? mode.light
            : mode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(
                left: sp * 0.02,
                top: sp * 0.01,
              ),
              leading: Icon(Theme.of(context).iconTheme.color == Colors.black
                  ? Icons.light_mode
                  : Icons.dark_mode),
              title: const Text('Theme'),
              subtitle: Text(
                m == mode.system
                    ? 'System'
                    : m == mode.light
                        ? 'Light'
                        : 'Dark',
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
                                title: const Text('System'),
                                value: mode.system,
                                groupValue: m,
                                onChanged: (dynamic val) async {
                                  var key =
                                      await SharedPreferences.getInstance();
                                  key.setInt('Theme', 0);
                                  AdaptiveTheme.of(context).setSystem();
                                  setState(() {
                                    m = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('Light'),
                                value: mode.light,
                                groupValue: m,
                                onChanged: (dynamic val) async {
                                  var key =
                                      await SharedPreferences.getInstance();
                                  key.setInt('Theme', 1);
                                  AdaptiveTheme.of(context).setLight();
                                  setState(() {
                                    m = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('Dark'),
                                value: mode.dark,
                                groupValue: m,
                                onChanged: (dynamic val) async {
                                  var key =
                                      await SharedPreferences.getInstance();
                                  key.setInt('Theme', 2);
                                  AdaptiveTheme.of(context).setDark();
                                  setState(() {
                                    m = val;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ).then((value) => setState(() {}));
              },
            ),
            /*ListTile(
              contentPadding: EdgeInsets.only(
                left: sp * 0.02,
                top: sp * 0.01,
              ),
              leading: const Icon(Icons.language),
              title: const Text('Langauge'),
              subtitle: Text(lang),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      content: null,
                    );
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

class Security extends StatelessWidget {
  const Security({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*ListTile(
              leading: const Icon(Icons.screen_lock_portrait),
              title: const Text('Two-Step Verification'),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.03,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const Verification(),
                ),
              ),
            ),*/
            ListTile(
              leading: const Icon(Icons.password),
              title: const Text('Change Login-Key'),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.03,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const LoginKey(),
                ),
              ),
            ),
            /*ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Change Number'),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.03,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const Number(),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

/*class Verification extends StatelessWidget {
  const Verification({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two-Step Verification'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.face_unlock_outlined),
              title: const Text('Face-Id'),
              contentPadding: EdgeInsets.only(top: sp * 0.01, left: sp * 0.03),
              trailing: Icon(
                Icons.check_circle_outline_rounded,
                size: sp * 0.05,
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.fingerprint),
              title: const Text('Fingerprint-Pattern'),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.03,
              ),
              trailing: Icon(
                Icons.check_circle_outline_rounded,
                size: sp * 0.05,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}*/

class LoginKey extends StatefulWidget {
  const LoginKey({Key? key}) : super(key: key);
  @override
  State<LoginKey> createState() => _LoginKeyState();
}

class _LoginKeyState extends State<LoginKey> {
  late final TextEditingController _controller1;
  late final TextEditingController _controller2;

  final _formKey = GlobalKey<FormState>();

  bool loginkey = true;
  var me;

  Future<http.Response> _editLoginkey() async {
    var url = Uri.parse(ip + '/app/editLoginkey');
    var response = await http.post(
      url,
      body: {
        'key': me.username,
        'Ologinkey': _controller1.text.trim(),
        'Nloginkey': _controller2.text.trim(),
      },
    );
    return response;
  }

  Future<int> _confirmLoginkey() async {
    var url = Uri.parse(ip + '/app/confirmLoginkey');
    var response = await http.post(
      url,
      body: {
        'key': me.username,
        'loginkey': _controller2.text.trim(),
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
    final my = Provider.of<My>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    me = my.getMe;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Login-Key'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                  title: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: sp * 0.002),
                    ),
                    child: TextFormField(
                      controller: _controller1,
                      readOnly: !loginkey,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).iconTheme.color as Color),
                        ),
                        hintText: '  CURRENT LOGIN-KEY',
                        hintStyle:
                            TextStyle(color: Theme.of(context).iconTheme.color),
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
                  contentPadding: EdgeInsets.only(
                    top: sp * 0.01,
                    left: sp * 0.02,
                    right: sp * 0.02,
                  )),
              ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: sp * 0.002),
                  ),
                  child: TextFormField(
                    controller: _controller2,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).iconTheme.color as Color),
                      ),
                      hintText: '  NEW LOGIN-KEY',
                      hintStyle: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    validator: (value) {
                      if (loginkey) {
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
                      if (!loginkey) {
                        setState(() {
                          loginkey = true;
                        });
                      }
                    },
                  ),
                ),
                contentPadding: EdgeInsets.only(
                  top: sp * 0.01,
                  left: sp * 0.02,
                  right: sp * 0.02,
                ),
              ),
              ListTile(
                title: loginkey
                    ? ElevatedButton(
                        child: const Text('CHANGE LOGIN-KEY'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var res = await _editLoginkey();
                            if (res.statusCode == 200) {
                              var suggestions =
                                  json.decode(res.body)["suggestions"] as List;
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
                                            _controller2.text = suggestions[i];
                                            loginkey = false;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            } else if (res.statusCode == 404) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.grey,
                                  duration: Duration(seconds: 5),
                                  content: Text('Wrong login key!'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.grey,
                                  duration: Duration(seconds: 5),
                                  content: Text(
                                    'Something went wrong please try again.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      )
                    : ElevatedButton(
                        child: const Text('CONFIRM'),
                        onPressed: () async {
                          if (await _confirmLoginkey() == 200) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.grey,
                                duration: Duration(seconds: 5),
                                content: Text(
                                  'Succesfully Changed!',
                                ),
                              ),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.grey,
                                duration: Duration(seconds: 5),
                                content: Text(
                                  'Something went wrong please try again.',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                subtitle: ElevatedButton(
                  child: const Text('RECOVER LOGIN-KEY'),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return const Recovery();
                    }));
                  },
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
      appBar: AppBar(
        title: const Text('Recover Login key'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                title: IntlPhoneField(
                  initialCountryCode: 'IN',
                  readOnly: otp,
                  controller: _controller1,
                  autovalidateMode: AutovalidateMode.always,
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
                contentPadding: EdgeInsets.only(
                  top: sp * 0.01,
                  left: sp * 0.02,
                  right: sp * 0.02,
                ),
              ),
              ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: sp * 0.002),
                  ),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _controller2,
                    readOnly: otp,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).iconTheme.color as Color,
                        ),
                      ),
                      hintText: ' Profile Name',
                      hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyText2!.color,
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
                contentPadding: EdgeInsets.only(
                  top: sp * 0.01,
                  left: sp * 0.02,
                  right: sp * 0.02,
                ),
              ),
              otp
                  ? ListTile(
                      title: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: sp * 0.002),
                        ),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _controller3,
                          readOnly: key,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color,
                              ),
                            ),
                            hintText: ' Confirm OTP',
                            hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
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
                      ),
                      contentPadding: EdgeInsets.only(
                        top: sp * 0.01,
                        left: sp * 0.02,
                        right: sp * 0.02,
                      ),
                    )
                  : const Padding(padding: EdgeInsets.zero),
              key
                  ? ListTile(
                      title: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: sp * 0.002),
                        ),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _controller4,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color,
                              ),
                            ),
                            hintText: ' Login-Key',
                            hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
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
                      ),
                      contentPadding: EdgeInsets.only(
                        top: sp * 0.01,
                        left: sp * 0.02,
                        right: sp * 0.02,
                      ),
                    )
                  : const Padding(padding: EdgeInsets.zero),
              key
                  ? ListTile(
                      title: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: sp * 0.002),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: sp * 0.01,
                            right: sp * 0.01,
                            left: sp * 0.01,
                          ),
                          child: const Text(
                            'Enter a sentence of atleast 8 characters (Only lowercase alphabets without any space in between) and we will give you suggestions pick one from them.',
                          ),
                        ),
                      ),
                      contentPadding: EdgeInsets.only(
                        top: sp * 0.01,
                        left: sp * 0.02,
                        right: sp * 0.02,
                      ),
                    )
                  : const Padding(padding: EdgeInsets.zero),
              ListTile(
                title: ElevatedButton(
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
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 5),
                            content: Text(
                              'Wrong Credentials!',
                            ),
                          ),
                        );
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
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 5),
                            content: Text(
                              'Wrong OTP!',
                            ),
                          ),
                        );
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
                    } else if (_formKey.currentState!.validate() &&
                        otp &&
                        key &&
                        !done) {
                      var res = await _checkLoginkey();
                      if (res.statusCode == 200) {
                        var suggestions =
                            json.decode(res.body)["suggestions"] as List;
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
                                      _controller4.text = suggestions[i];
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
                    } else if (_formKey.currentState!.validate() &&
                        otp &&
                        key &&
                        done) {
                      if (await _changeLoginkey() == 200) {
                        ScaffoldMessenger.of(context).clearSnackBars();
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
                ),
                contentPadding: EdgeInsets.only(
                  top: sp * 0.01,
                  left: sp * 0.02,
                  right: sp * 0.02,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*class Number extends StatelessWidget {
  const Number({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Number'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: sp * 0.002),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).iconTheme.color as Color),
                    ),
                    hintText: '  CONFIRM YOUR LOGIN-KEY',
                    hintStyle: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.02,
                right: sp * 0.02,
              ),
            ),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: sp * 0.002,
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).iconTheme.color as Color),
                    ),
                    hintText: '  CURRENT NUMBER(WITH COUNTRY CODE)',
                    hintStyle: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.02,
                right: sp * 0.02,
              ),
            ),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: sp * 0.002),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).iconTheme.color as Color),
                    ),
                    hintText: '  ENTER NEW NUMBER(WITH COUNTRY CODE)',
                    hintStyle: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
              subtitle: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('ENTER OTP'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: TextField(
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).iconTheme.color
                                          as Color,
                                    ),
                                  ),
                                  hintText: 'Sent to your old number',
                                  hintStyle: TextStyle(
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ),
                              subtitle: TextField(
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).iconTheme.color
                                          as Color,
                                    ),
                                  ),
                                  hintText: 'Sent to your new number',
                                  hintStyle: TextStyle(
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: Text('SUCESSFULLY CHANGED!'),
                                ),
                              );
                            },
                            child: const Text('CONFIRM'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('CHANGE NUMBER'),
              ),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.02,
                right: sp * 0.02,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);
  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  String lastseen = 'My connections';
  String displaypicture = 'My connections';
  String aboutme = 'My connections';
  String moments = 'My connections';
  bool read = true;
  String groups = 'My connections';
  String location = 'My connections';

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Last Seen'),
              subtitle: Text(lastseen),
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
                                title: const Text('My connections'),
                                value: 'My connections',
                                groupValue: lastseen,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    lastseen = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('My connections except'),
                                value: 'My connections except',
                                groupValue: lastseen,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    lastseen = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('None'),
                                value: 'None',
                                groupValue: lastseen,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    lastseen = val;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ).then((value) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Display Picture'),
              subtitle: Text(displaypicture),
              contentPadding: EdgeInsets.only(top: sp * 0.01, left: sp * 0.03),
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
                                title: const Text('My connections'),
                                value: 'My connections',
                                groupValue: displaypicture,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    displaypicture = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('My connections except'),
                                value: 'My connections except',
                                groupValue: displaypicture,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    displaypicture = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('None'),
                                value: 'None',
                                groupValue: displaypicture,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    displaypicture = val;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ).then((value) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('About me'),
              subtitle: Text(aboutme),
              contentPadding: EdgeInsets.only(top: sp * 0.01, left: sp * 0.03),
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
                                title: const Text('My connections'),
                                value: 'My connections',
                                groupValue: aboutme,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    aboutme = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('My connections except'),
                                value: 'My connections except',
                                groupValue: aboutme,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    aboutme = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('None'),
                                value: 'None',
                                groupValue: aboutme,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    aboutme = val;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ).then((value) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_emotions),
              title: const Text('Moments'),
              subtitle: Text(moments),
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
                                title: const Text('My connections'),
                                value: 'My connections',
                                groupValue: moments,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    moments = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('My connections except'),
                                value: 'My connections except',
                                groupValue: moments,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    moments = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('None'),
                                value: 'None',
                                groupValue: moments,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    moments = val;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ).then((value) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt_rounded),
              title: const Text('Read Receipts'),
              subtitle: const Text('Sent, Recevied and Seen'),
              trailing: read
                  ? Icon(
                      Icons.toggle_on_outlined,
                      color: Theme.of(context).backgroundColor == Colors.black
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).primaryColor,
                      size: sp * 0.07,
                    )
                  : Icon(
                      Icons.toggle_off_outlined,
                      size: sp * 0.07,
                      color: Theme.of(context).iconTheme.color,
                    ),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.03,
              ),
              onTap: () => setState(() {
                read = !read;
              }),
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('Groups'),
              subtitle: Text(groups),
              contentPadding: EdgeInsets.only(top: sp * 0.01, left: sp * 0.03),
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
                                title: const Text('My connections'),
                                value: 'My connections',
                                groupValue: groups,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    groups = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('My connections except'),
                                value: 'My connections except',
                                groupValue: groups,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    groups = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('None'),
                                value: 'None',
                                groupValue: groups,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    groups = val;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ).then((value) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Live location'),
              subtitle: Text(location),
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
                                title: const Text('My connections'),
                                value: 'My connections',
                                groupValue: location,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    location = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('My connections except'),
                                value: 'My connections except',
                                groupValue: location,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    location = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('None'),
                                value: 'None',
                                groupValue: location,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    location = val;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ).then((value) {
                  setState(() {});
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}*/

class Delete extends StatefulWidget {
  const Delete({Key? key}) : super(key: key);
  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  late TextEditingController _controller3;

  final _formKey = GlobalKey<FormState>();

  String code = '91';
  bool otp = false;

  Future<int> _deleteAccount() async {
    var url = Uri.parse(ip + '/app/deleteAccount');
    var response = await http.post(
      url,
      body: {
        'loginkey': _controller1.text.trim(),
        'number': '+' + code + _controller2.text.trim(),
      },
    );
    return response.statusCode;
  }

  Future<int> _confirmOtp() async {
    var url = Uri.parse(ip + '/app/confirmOtp');
    var response = await http.post(
      url,
      body: {
        'loginkey': _controller1.text.trim(),
        'number': '+' + code + _controller2.text.trim(),
        'otp': _controller3.text.trim(),
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
    final my = Provider.of<My>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final MyData me = my.getMe;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete my account'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.only(
                  left: sp * 0.02,
                  top: sp * 0.02,
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.dangerous_rounded,
                    size: sp * 0.05,
                    color: Colors.red,
                  ),
                ),
                title: Text(
                  'Deleting account will :',
                  style: TextStyle(
                    fontSize: sp * 0.025,
                  ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.only(
                  bottom: sp * 0.01,
                  left: sp * 0.084,
                ),
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text('- Delete account from Ping'),
                    Text('- Delete you from all your groups'),
                    Text('- Delete all your messages and conversations'),
                  ],
                ),
              ),
              /*ListTile(
                contentPadding: EdgeInsets.only(
                  left: sp * 0.03,
                  top: sp * 0.04,
                  bottom: sp * 0.04,
                  right: sp * 0.03,
                ),
                leading: const Icon(Icons.phonelink_setup_rounded),
                title: const Text('Change number?!'),
                subtitle: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const Number(),
                    ),
                  ),
                  child: const Text('CHANGE NUMBER'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      (Theme.of(context).backgroundColor == Colors.black
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),*/
              const Text('Confirm your Login-Key and Phone number to proceed.'),
              ListTile(
                title: TextFormField(
                  controller: _controller1,
                  readOnly: otp,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).iconTheme.color as Color),
                    ),
                    hintText: 'Login-Key',
                    hintStyle:
                        TextStyle(color: Theme.of(context).iconTheme.color),
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
              ListTile(
                title: IntlPhoneField(
                  initialCountryCode: 'IN',
                  readOnly: otp,
                  controller: _controller2,
                  autovalidateMode: AutovalidateMode.always,
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
                    } else if (value != me.number) {
                      return 'Invalid number';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              otp
                  ? ListTile(
                      title: TextFormField(
                        controller: _controller3,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color),
                          ),
                          hintText: 'Confirm Otp',
                          hintStyle: TextStyle(
                              color: Theme.of(context).iconTheme.color),
                        ),
                      ),
                    )
                  : const Padding(padding: EdgeInsets.zero),
              !otp
                  ? ListTile(
                      title: ElevatedButton(
                        child: const Text('DELETE'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            (Theme.of(context).backgroundColor == Colors.black
                                ? Colors.red[900]
                                : Colors.red),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var res = await _deleteAccount();
                            if (res == 200) {
                              setState(() {
                                otp = true;
                              });
                            } else if (res == 404) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 5),
                                  content: Text(
                                    'Wrong Credentials.',
                                  ),
                                ),
                              );
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
                      ),
                    )
                  : const Padding(padding: EdgeInsets.zero),
              otp
                  ? ListTile(
                      title: ElevatedButton(
                        child: const Text('CONFIRM'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            (Theme.of(context).backgroundColor == Colors.black
                                ? Colors.red[900]
                                : Colors.red),
                          ),
                        ),
                        onPressed: () async {
                          var res = await _confirmOtp();
                          if (res == 200) {
                            final dir =
                                await getApplicationDocumentsDirectory();
                            final path = dir.path + '/data.mdb';
                            await File(path).delete();
                            //var key = await SharedPreferences.getInstance();
                            //key.setBool('Login', false);
                            Navigator.of(context)
                                .popUntil(ModalRoute.withName('/'));
                          } else if (res == 404) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 5),
                                content: Text(
                                  'Wrong otp try again...',
                                ),
                              ),
                            );
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
                        },
                      ),
                    )
                  : const Padding(padding: EdgeInsets.zero),
            ],
          ),
        ),
      ),
    );
  }
}
