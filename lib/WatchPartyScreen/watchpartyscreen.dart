// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/mydata.dart';
import '../models/user.dart';
import '../main.dart';

import 'playerwidget.dart';

class WatchPartyScreen extends StatefulWidget {
  const WatchPartyScreen({Key? key}) : super(key: key);
  static const routeName = '/WatchParty';
  @override
  State<WatchPartyScreen> createState() => _WatchPartyScreenState();
}

class _WatchPartyScreenState extends State<WatchPartyScreen> {
  bool init = true;
  var selected;
  var unselected = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    final me = Provider.of<My>(context);
    if (init) {
      init = false;
      unselected = user.getUsers;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch Party'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ListView.builder(
                      itemCount: unselected.length,
                      itemBuilder: (ctx, i) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: FileImage(
                              File(unselected[i].dp),
                            ),
                          ),
                          title: Text(unselected[i].name),
                          subtitle: Text(unselected[i].username),
                          onTap: () {
                            setState(() {
                              selected = unselected[i];
                              unselected.remove(unselected[i]);
                              Navigator.of(context).pop();
                            });
                          },
                        );
                      },
                    );
                  });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: selected != null
            ? ListTile(
                leading: CircleAvatar(
                  backgroundImage: FileImage(
                    File(selected.dp),
                  ),
                ),
                title: Text(selected.name),
                subtitle: Text(selected.username),
                trailing: const Icon(Icons.delete, color: Colors.red),
                onTap: () {
                  setState(() {
                    unselected.add(selected);
                    selected = null;
                  });
                },
              )
            : null,
      ),
      floatingActionButton: selected != null
          ? FloatingActionButton(
              child: const Icon(Icons.check),
              onPressed: () {
                socket.emit('startparty', {
                  'invite': me.getMe.username,
                  'username': selected.username,
                });

                socket.on('resparty', (data) {
                  if (data['res'] == '1') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) {
                          return Player(username: selected.username);
                        },
                      ),
                    );
                  } else if (data['res'] == '2') {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text(
                          'Waiting for User...',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text(
                          'User declined or offline.',
                        ),
                      ),
                    );
                  }
                });
              },
            )
          : null,
    );
  }
}
