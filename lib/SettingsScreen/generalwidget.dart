// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class General extends StatefulWidget {
  const General({Key? key}) : super(key: key);
  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> {
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
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const App(),
                ),
              ),
            ),
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
            ListTile(
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
            ),
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
  const App({Key? key}) : super(key: key);
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String lang = 'English(US)';
  List<String> mode = ['System', 'Light', 'Dark'];

  @override
  void initState() {
    super.initState();
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
              leading: const Icon(Icons.light_mode),
              title: const Text('Theme'),
              subtitle: const Text(
                'System',
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
                                value: 'System',
                                groupValue: mode,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    mode = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: Text(
                                  'Light',
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      color: Theme.of(context).iconTheme.color),
                                  textScaleFactor:
                                      MediaQuery.of(context).textScaleFactor,
                                ),
                                value: 'Light',
                                groupValue: mode,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    mode = val;
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text('Dark'),
                                value: 'Dark',
                                groupValue: mode,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    mode = val;
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
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
            ),
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
            ListTile(
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
            ),
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
            ListTile(
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
            ),
          ],
        ),
      ),
    );
  }
}

class Verification extends StatelessWidget {
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
}

class LoginKey extends StatelessWidget {
  const LoginKey({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Login-Key'),
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
                    hintText: '  CURRENT LOGIN-KEY',
                    hintStyle:
                        TextStyle(color: Theme.of(context).iconTheme.color),
                  ),
                ),
              ),
              subtitle: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'RECOVERY',
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              subtitle: TextField(
                                maxLines: 3,
                                autofocus: true,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).iconTheme.color
                                          as Color,
                                    ),
                                  ),
                                  hintText:
                                      'Enter your registered phone number(With Country code) or email',
                                  hintStyle: TextStyle(
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ),
                              title: const Text(
                                  'We will send your Login-Key to below provided:-'),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.grey,
                                  duration: Duration(seconds: 2),
                                  content: Text('SENT!'),
                                ),
                              );
                            },
                            child: const Text('SEND'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Can\'t recall?! Recover your Login-Key'),
              ),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.02,
                right: sp * 0.02,
              ),
              onTap: () {},
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
                    hintText: '  NEW LOGIN-KEY',
                    hintStyle: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
              contentPadding: EdgeInsets.only(
                left: sp * 0.02,
                right: sp * 0.02,
              ),
              onTap: () {},
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
                    hintText: '  CONFIRM LOGIN-KEY',
                    hintStyle:
                        TextStyle(color: Theme.of(context).iconTheme.color),
                  ),
                ),
              ),
              subtitle: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.grey,
                      duration: Duration(seconds: 2),
                      content: Text('SUCESSFULLY CHANGED!'),
                    ),
                  );
                },
                child: const Text('CHANGE LOGIN-KEY'),
              ),
              contentPadding: EdgeInsets.only(
                top: sp * 0.01,
                left: sp * 0.02,
                right: sp * 0.02,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class Number extends StatelessWidget {
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
                                  backgroundColor: Colors.grey,
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
}

class Delete extends StatelessWidget {
  const Delete({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete my account'),
      ),
      body: SingleChildScrollView(
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
            ListTile(
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
            ),
            const Text('Confirm your Login-Key and Phone number to proceed.'),
            ListTile(
              title: TextField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).iconTheme.color as Color),
                  ),
                  hintText: 'Login-Key',
                  hintStyle:
                      TextStyle(color: Theme.of(context).iconTheme.color),
                ),
              ),
              subtitle: TextField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).iconTheme.color as Color),
                  ),
                  hintText: 'Phone number',
                  hintStyle:
                      TextStyle(color: Theme.of(context).iconTheme.color),
                ),
              ),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('CONFIRM OTP'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text(
                                  'These will permanately delete your account and can\'t be undone!!'),
                              subtitle: TextField(
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).iconTheme.color
                                          as Color,
                                    ),
                                  ),
                                  hintText: 'Sent to your registered number',
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
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                  content: Text('SUCESSFULLY DELETED!!'),
                                ),
                              );
                            },
                            child: const Text('CONFIRM DELETION'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('DELETE'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    (Theme.of(context).backgroundColor == Colors.black
                        ? Colors.red[900]
                        : Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
