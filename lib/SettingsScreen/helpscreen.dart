import 'package:flutter/material.dart';

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
                builder: (ctx) => const Report(),
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
                builder: (ctx) => const Feedback(),
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
  const Report({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text(
                'Describe your problem in brief and we will look into it (Mention your phone name and model)'),
            subtitle: TextField(
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
            ),
            contentPadding: EdgeInsets.only(
              top: sp * 0.01,
              left: sp * 0.02,
              right: sp * 0.02,
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.grey,
                    duration: Duration(seconds: 2),
                    content: Text(
                        'SUBMITED... sorry for inconvenience we will fix it asap!!'),
                  ),
                );
              },
              child: const Text('SUBMIT'),
            ),
          ),
        ],
      ),
    );
  }
}

class Feedback extends StatelessWidget {
  const Feedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text(
                'Write about your idea or suggested improvement like UI, Performance, Latency etc'),
            subtitle: TextField(
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
            ),
            contentPadding: EdgeInsets.only(
              top: sp * 0.01,
              left: sp * 0.02,
              right: sp * 0.02,
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.grey,
                    duration: Duration(seconds: 2),
                    content: Text('Thank you for the help by contributing!!'),
                  ),
                );
              },
              child: const Text('SUBMIT'),
            ),
          ),
        ],
      ),
    );
  }
}
