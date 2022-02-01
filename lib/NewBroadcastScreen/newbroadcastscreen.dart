import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Helpers/users.dart';
import 'broadcastwidget.dart';

class NewBroadcastScreen extends StatefulWidget {
  const NewBroadcastScreen({Key? key}) : super(key: key);
  static const routeName = '/NewBroadcast';
  @override
  State<NewBroadcastScreen> createState() => _NewBroadcastScreenState();
}

class _NewBroadcastScreenState extends State<NewBroadcastScreen> {
  List<User> selected = [];
  List<User> unselected = [];
  bool a = true;
  int n = 0;
  int len = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;

    if (a) {
      unselected = user.users;
      len = unselected.length;
      a = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('New Broadcast'),
            Text(
              '$n selected of $len users',
              style: TextStyle(fontSize: sp * 0.015),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                a = true;
                selected = [];
                n = 0;
              });
            },
            icon: const Icon(Icons.refresh_sharp),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: unselected.isEmpty && selected.isEmpty
          ? const Center(
              child: Text(
                'NO USERS IN YOUR CONTACTS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  selected.isEmpty
                      ? const Padding(padding: EdgeInsets.zero)
                      : Padding(
                          padding: EdgeInsets.all(sp * 0.009),
                          child: SizedBox(
                            width: media.size.width,
                            height: sp * 0.1,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return SizedBox(
                                  width: sp * 0.1,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            unselected.add(selected[i]);
                                            selected.removeAt(i);
                                            n--;
                                          });
                                        },
                                        child: CircleAvatar(
                                          child: const Icon(Icons.person),
                                          radius: sp * 0.03,
                                        ),
                                      ),
                                      SizedBox(height: sp * 0.01),
                                      Text(
                                        selected[i].name,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: selected.length,
                            ),
                          ),
                        ),
                  SizedBox(
                    width: sp,
                    height: selected.isEmpty ? sp * 0.87 : sp * 0.77,
                    child: ListView.builder(
                      itemBuilder: (context, i) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              selected.add(unselected[i]);
                              unselected.removeAt(i);
                              n++;
                            });
                          },
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                            unselected[i].name,
                            maxLines: 1,
                          ),
                          contentPadding: EdgeInsets.all(sp * 0.010),
                        );
                      },
                      itemCount: unselected.length,
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: selected.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (ctx) => Broadcast(user: selected),
                      ),
                    )
                    .then(
                      (value) => setState(
                        () {
                          a = true;
                          selected = [];
                          n = 0;
                        },
                      ),
                    );
              },
              child: const Icon(Icons.check),
            ),
    );
  }
}
