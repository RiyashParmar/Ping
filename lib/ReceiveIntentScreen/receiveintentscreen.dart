import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class ReceiveIntentScreen extends StatefulWidget {
  const ReceiveIntentScreen({Key? key}) : super(key: key);
  static const routeName = '/receive';
  @override
  State<ReceiveIntentScreen> createState() => _ReceiveIntentScreenState();
}

class _ReceiveIntentScreenState extends State<ReceiveIntentScreen> {
  late List<bool> check = List.filled(35, false);
  String selected = '';

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final user = Provider.of<Users>(context);
    user.init();
    List<User> users = user.getUsers;

    final appBar = AppBar(
      title: const Text('Share'),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              check = List.filled(35, false);
              selected = '';
            });
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: media.size.width,
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(!check[0] ? Icons.image : Icons.check),
                ),
                title: const Text('Share to your Moments'),
                contentPadding: EdgeInsets.all(sp * 0.010),
                onTap: () {
                  setState(() {
                    check[0] = !check[0];
                    check[0]
                        ? selected += 'Your Moment, '
                        : selected = selected.replaceAll('Your Moment, ', '');
                  });
                  if (selected.isNotEmpty) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(days: 1),
                        content: Text(selected),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }
                },
              ),
            ),
            SizedBox(
              height: media.size.height -
                  media.viewPadding.top -
                  appBar.preferredSize.height -
                  media.size.height * 0.1 -
                  media.viewPadding.bottom,
              width: media.size.width,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (ctx, i) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(!check[i + 1] ? Icons.person : Icons.check),
                    ),
                    title: Text(
                      users[i].name,
                      maxLines: 1,
                    ),
                    contentPadding: EdgeInsets.all(sp * 0.010),
                    onTap: () {
                      setState(() {
                        check[i + 1] = !check[i + 1];
                        check[i + 1]
                            ? selected += users[i].name + ', '
                            : selected =
                                selected.replaceAll(users[i].name + ', ', '');
                      });
                      if (selected.isNotEmpty) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(days: 1),
                            content: Text(selected, maxLines: 1),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: check.contains(true)
          ? FloatingActionButton(
              child: const Icon(Icons.arrow_forward),
              onPressed: () {},
            )
          : null,
    );
  }
}
