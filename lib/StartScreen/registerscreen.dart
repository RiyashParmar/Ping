import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
  var dp = null;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1903, 1, 1),
      lastDate: date,
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  Future<int> _confirmNumber() async {
    var url = Uri.parse('http://10.0.2.2:3000/register/sendOtp');
    var response = await http.post(
      url,
      body: {'number': '+' + code + _controller2.text},
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
                              final picker = ImagePicker();
                              dp = await picker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() {
                                _controller1.text = dp != null ? dp.path : '';
                              });
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
                                if (await _confirmNumber() == 200) {
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
                                } else {
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

                        /**
                        TextButton(
                          child: const Text('Submit'),
                          onPressed: () async {
                            var key = await SharedPreferences.getInstance();
                            key.setBool('Login', true);
                            
                          },
                        ),**/
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

  bool otp = false;
  String userState = '';
  String keyState = '';

  final _formKey = GlobalKey<FormState>();
  final _formFieldKey1 = GlobalKey<FormFieldState>();
  final _formFieldKey2 = GlobalKey<FormFieldState>();

  Future<int> _confirmOtp() async {
    var url = Uri.parse('http://10.0.2.2:3000/register/confirmOtp');
    var response = await http.post(
      url,
      body: {'otp': _controller1.text, 'number': widget.number},
    );
    return response.statusCode;
  }

  Future<int> _checkUsername() async {
    var url = Uri.parse('http://10.0.2.2:3000/register/checkUsername');
    var response = await http.post(
      url,
      body: {'username': _controller2.text},
    );
    return response.statusCode;
  }

  Future<int> _checkLoginkey() async {
    var url = Uri.parse('http://10.0.2.2:3000/register/checkLoginkey');
    var response = await http.post(
      url,
      body: {'loginkey': _controller3.text},
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
                                  key: _formFieldKey1,
                                  controller: _controller2,
                                  decoration: InputDecoration(
                                    suffix: userState == 'loading'
                                        ? const CircularProgressIndicator()
                                        : userState == 'ok'
                                            ? const Icon(Icons.check_box)
                                            : const Icon(Icons.cancel),
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
                                  onChanged: (value) async {
                                    if (_formFieldKey1.currentState!
                                        .validate()) {
                                      setState(() {
                                        userState = 'loading';
                                      });
                                      var res = await _checkUsername();
                                      if (res == 305) {
                                        setState(() {
                                          userState = 'not ok';
                                        });
                                      } else if (res == 200) {
                                        setState(() {
                                          userState = 'ok';
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 5),
                                            content: Text(
                                              'Something went wrong! please type again',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  validator: (value) {
                                    var reg = RegExp(
                                        r'^[a-zA-Z0-9+_]+[a-zA-Z0-9+_+\-+.]*[^\s]\1*[a-zA-Z0-9+_]$');
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
                                  'Should be a 3-30 characters combination of Alphanumeric, Symbols( _ , - , . ) with no whitespaces and should start with Alphanumeric or Underscore',
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
                                child: TextFormField(
                                  key: _formFieldKey2,
                                  controller: _controller3,
                                  decoration: InputDecoration(
                                    suffix: keyState == 'loading' ? const CircularProgressIndicator() : null,
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
                                  onChanged: (value) async {
                                    if (_formFieldKey2.currentState!
                                        .validate()) {
                                      setState(() {
                                        keyState = 'loading';
                                      });
                                      var res = await _checkLoginkey();
                                      if (res == 300) {
                                        setState(() {
                                          keyState = '';
                                        });
                                        //show suggestions....
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 5),
                                            content: Text(
                                              'Something went wrong! please type again',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  validator: (value) {
                                    var reg = RegExp(r'[a-zA-Z]$');
                                    if (value!.trim().length < 8) {
                                      return 'Too short!! Not very strong you see 😏';
                                    } else if (value.trim().length > 200) {
                                      return 'Too Long!! Bet you will forget these 😂';
                                    } else if (!reg.hasMatch(value.trim())) {
                                      return 'Invalid format! Might as well follow the instructions 😏';
                                    } else {
                                      return null;
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
                                  'Enter a sentence of atleast 8 characters (Only Alphabets without any space in between) and we will give you suggestions pick one from them.',
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
                              if (otp) {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.of(context)
                                      .pushNamed(HomeScreen.routename);
                                }
                              } else {
                                if (await _confirmOtp() == 200) {
                                  setState(() {
                                    otp = true;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text(
                                        'Inncorrect otp please try again',
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
