import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

import 'playerwidget.dart';

String ip = 'http://192.168.43.62:3000';
//String ip = 'http://10.0.2.2:3000';

class WatchPartyScreen extends StatefulWidget {
  const WatchPartyScreen({Key? key}) : super(key: key);
  static const routeName = '/WatchParty';
  @override
  State<WatchPartyScreen> createState() => _WatchPartyScreenState();
}

class _WatchPartyScreenState extends State<WatchPartyScreen> {
  bool init = true;
  var selected = [];
  var unselected = [];

  Future<http.Response> _startParty() async {
    List<String> _selected = [];
    for (var item in selected) {
      _selected.add(item.username);
    }

    var url = Uri.parse(ip + '/app/startParty');
    var response = await http.post(
      url,
      body: {
        'invites': jsonEncode(_selected),
      },
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
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
                              selected.add(unselected[i]);
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
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: selected.length,
          itemBuilder: (ctx, i) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: FileImage(
                  File(selected[i].dp),
                ),
              ),
              title: Text(selected[i].name),
              subtitle: Text(selected[i].username),
              trailing: const Icon(Icons.delete, color: Colors.red),
              onTap: () {
                setState(() {
                  unselected.add(selected[i]);
                  selected.remove(selected[i]);
                });
              },
            );
          },
        ),
      ),
      floatingActionButton: selected.isNotEmpty
          ? FloatingActionButton(
              child: const Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return const Player();
                },),);
              },
            )
          : null,
    );
  }
}
