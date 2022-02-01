import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'registerscreen.dart';
import '../HomeScreen/homescreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/Login';

  Future<void> _requestPermission() async {
    await [
      Permission.locationWhenInUse,
      Permission.microphone,
      Permission.contacts,
      Permission.storage,
    ].request();
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
                height: sp * 0.31,
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
                          top: sp * 0.04,
                          right: sp * 0.01,
                          left: sp * 0.01,
                        ),
                        child: TextField(
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: sp * 0.03,
                          right: sp * 0.01,
                          left: sp * 0.01,
                        ),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color,
                              ),
                            ),
                            hintText: '  Registered-Number(With Country Code)',
                            hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: sp * 0.01,
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            //await _makeGetRequest();
                            await _requestPermission();
                            Navigator.of(context)
                                .pushNamed(HomeScreen.routename);
                          },
                          child: const Text('Login'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: sp * 0.01,
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

class Recovery extends StatelessWidget {
  const Recovery({Key? key}) : super(key: key);
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
                height: sp * 0.17,
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
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color,
                              ),
                            ),
                            hintText: '  Registered number/Email',
                            hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: sp * 0.01,
                        ),
                        child: ElevatedButton(
                          child: const Text('CONFIRM'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 5),
                                content: Text(
                                  'LOGIN-KEY sent to your Registered Number/Email',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
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
}
