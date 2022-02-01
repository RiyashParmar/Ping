import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HomeScreen/homescreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const routeName = '/Register';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController controller1;
  late final TextEditingController controller2;
  late final TextEditingController controller3;
  late final TextEditingController controller4;
  DateTime date = DateTime.now();

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

  @override
  void initState() {
    super.initState();
    controller1 = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
    controller4 = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
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
                height: sp * 0.62,
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
                          controller: controller1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color,
                              ),
                            ),
                            hintText: '  Phone-Number(With Country Code)',
                            hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        child: const Text('Submit'),
                        onPressed: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: sp * 0.01,
                          left: sp * 0.01,
                        ),
                        child: TextField(
                          controller: controller2,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color,
                              ),
                            ),
                            hintText: '  CONFIRM THE OTP',
                            hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Submit'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: sp * 0.01,
                          left: sp * 0.01,
                        ),
                        child: TextField(
                          controller: controller3,
                          keyboardType: TextInputType.number,
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
                      TextButton(
                        onPressed: () {},
                        child: const Text('Submit'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: sp * 0.01,
                          left: sp * 0.01,
                        ),
                        child: TextField(
                          controller: controller4,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color,
                              ),
                            ),
                            hintText: '  Full-Name',
                            hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: sp * 0.02,
                        ),
                        child: const Text('Enter your DOB'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: sp * 0.01,
                          left: sp * 0.01,
                        ),
                        child: TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text("${date.toLocal()}".split(' ')[0]),
                        ),
                      ),
                      TextButton(
                        child: const Text('Submit'),
                        onPressed: () async {
                          var key = await SharedPreferences.getInstance();
                          key.setBool('Login', true);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const OptionalField(),
                            ),
                          );
                        },
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

class OptionalField extends StatefulWidget {
  const OptionalField({Key? key}) : super(key: key);
  @override
  _OptionalFieldState createState() => _OptionalFieldState();
}

class _OptionalFieldState extends State<OptionalField> {
  late final TextEditingController controller1;
  late final TextEditingController controller2;
  late final TextEditingController controller3;

  @override
  void initState() {
    super.initState();
    controller1 = TextEditingController();
    controller2 = TextEditingController();
    controller3 = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
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
                height: sp * 0.49,
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
                          right: sp * 0.01,
                          left: sp * 0.01,
                        ),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color,
                              ),
                            ),
                            hintText: '  Email',
                            hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Submit'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: sp * 0.01,
                          left: sp * 0.01,
                        ),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color,
                              ),
                            ),
                            hintText: '  OTP',
                            hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Submit'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: sp * 0.01,
                          left: sp * 0.01,
                        ),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 5,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    Theme.of(context).iconTheme.color as Color,
                              ),
                            ),
                            hintText: '  Describe yourself',
                            hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        child: const Text('Submit'),
                        onPressed: () => Navigator.of(context)
                            .pushNamed(HomeScreen.routename),
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
