import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/mydata.dart';
import '../main.dart' as m;

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);
  static const routeName = '/Help';

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Guide'),
            subtitle: const Text('Brief demo of our app'),
            contentPadding: EdgeInsets.only(
              top: sp * 0.01,
              left: sp * 0.03,
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const Guide(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.error),
            title: const Text('Report Issues'),
            subtitle: const Text('Bugs, Crashes, Conectivity issues etc'),
            contentPadding: EdgeInsets.only(
              top: sp * 0.01,
              left: sp * 0.03,
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => Report(),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Submit Feedback'),
            subtitle: const Text('Give your valuable feedback help us improve'),
            contentPadding: EdgeInsets.only(
              top: sp * 0.01,
              left: sp * 0.03,
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => Feedback(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Guide extends StatelessWidget {
  const Guide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide'),
      ),
      body: null,
    );
  }
}

class Report extends StatelessWidget {
  Report({Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormFieldState> _key = GlobalKey();

  Future<int> _reportBug(username) async {
    var url = Uri.parse(m.ip + 'app/reportBug');
    var response = await http.post(
      url,
      body: {
        'username': username,
        'report': _controller.text.trim(),
      },
    );
    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    final my = Provider.of<My>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final me = my.getMe;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text(
                'Describe your problem in brief and we will look into it (Mention your phone name and model)'),
            subtitle: TextFormField(
              key: _key,
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).iconTheme.color as Color,
                  ),
                ),
                hintText: 'REPORT ISSUES YOU FACED ',
                hintStyle: TextStyle(
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              validator: (value) {
                if (_controller.text.trim().length < 20) {
                  return 'Please be more descriptive...';
                } else if (_controller.text.trim().length > 1000) {
                  return 'Please be inside 1000 characters';
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
            title: ElevatedButton(
              child: const Text('SUBMIT'),
              onPressed: () async {
                if (_key.currentState!.validate()) {
                  if (await _reportBug(me.username) == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.grey,
                        duration: Duration(seconds: 2),
                        content: Text(
                          'SUBMITED... sorry for inconvenience we will fix it asap!!',
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.grey,
                        duration: Duration(seconds: 2),
                        content: Text(
                          'Something went wrong please try again.',
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
    );
  }
}

class Feedback extends StatelessWidget {
  Feedback({Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormFieldState> _key = GlobalKey();

  Future<int> _feedback(username) async {
    var url = Uri.parse(m.ip + 'app/feedback');
    var response = await http.post(
      url,
      body: {
        'username': username,
        'feedback': _controller.text.trim(),
      },
    );
    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    final my = Provider.of<My>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final me = my.getMe;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text(
                'Write about your idea or suggested improvement like UI, Performance, Latency etc'),
            subtitle: TextFormField(
              key: _key,
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).iconTheme.color as Color,
                  ),
                ),
                hintText: 'SUBMIT YOUR VALUABLE FEEDBACK',
                hintStyle: TextStyle(
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              validator: (value) {
                if (_controller.text.trim().length < 20) {
                  return 'Please be more descriptive...';
                } else if (_controller.text.trim().length > 1000) {
                  return 'Please be inside 1000 characters';
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
            title: ElevatedButton(
              child: const Text('SUBMIT'),
              onPressed: () async {
                if (_key.currentState!.validate()) {
                  if (await _feedback(me.username) == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.grey,
                        duration: Duration(seconds: 2),
                        content: Text(
                          'SUBMITED thanks for your input.',
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.grey,
                        duration: Duration(seconds: 2),
                        content: Text(
                          'Something went wrong please try again.',
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
    );
  }
}
