import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:android_intent_plus/android_intent.dart';
import '../NewGroupScreen/newgroupscreen.dart';
import '../SettingsScreen/aboutusscreen.dart';

import '../Helpers/users.dart';
import '../ConversationScreen/conversationscreen.dart';

class NewConversationScreen extends StatefulWidget {
  const NewConversationScreen({Key? key}) : super(key: key);
  static const routeName = '/NewChat';

  @override
  State<NewConversationScreen> createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final user = Provider.of<Users>(context);

    List<User> users = user.users;
    String state = 'loaded';

    FlutterContacts.addListener(() {
      user.updatecontacts();
      setState(() {});
    });

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('USERS'),
            Text(
              '${users.length} people',
              style: TextStyle(
                fontSize: sp * 0.015,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            iconSize: sp * 0.034,
            onPressed: () {
              setState(() {
                state = 'loading';
                user.updatecontacts();
              });
            },
            icon: state == 'loaded'
                ? const Icon(Icons.replay_circle_filled_sharp)
                : const CircularProgressIndicator(
                    color: Colors.black,
                  ),
          ),
        ],
      ),
      body: users.isEmpty
          ? const Center(
              child: Text('No Users in your Contacts'),
            )
          : state == 'loading'
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemBuilder: (context, i) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ConversationScreen.routeName,
                          arguments: [users[i].name, users[i].number],
                        );
                      },
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        users[i].name,
                        maxLines: 1,
                      ),
                      contentPadding: EdgeInsets.all(sp * 0.010),
                    );
                  },
                  itemCount: users.length,
                ),
      floatingActionButton: SpeedDial(
        foregroundColor: Theme.of(context).iconTheme.color,
        backgroundColor: Theme.of(context).primaryColor,
        renderOverlay: false,
        spaceBetweenChildren: sp * 0.009,
        spacing: sp * 0.009,
        child: const Icon(Icons.favorite),
        children: [
          SpeedDialChild(
            backgroundColor: Theme.of(context).primaryColor,
            labelBackgroundColor:
                Theme.of(context).backgroundColor == Colors.black
                    ? Colors.grey
                    : Colors.white,
            child: const Icon(Icons.person_add_alt_1_sharp),
            label: 'Add Contact',
            onTap: () async {
              await FlutterContacts.openExternalInsert();
            },
          ),
          SpeedDialChild(
            backgroundColor: Theme.of(context).primaryColor,
            labelBackgroundColor:
                Theme.of(context).backgroundColor == Colors.black
                    ? Colors.grey
                    : Colors.white,
            child: const Icon(Icons.my_library_books_rounded),
            label: 'Contacts',
            onTap: () async {
              AndroidIntent(
                action: 'action_view',
                data: Uri.encodeFull('content://contacts/people'),
              ).launch();
            },
          ),
          SpeedDialChild(
            backgroundColor: Theme.of(context).primaryColor,
            labelBackgroundColor:
                Theme.of(context).backgroundColor == Colors.black
                    ? Colors.grey
                    : Colors.white,
            child: const Icon(Icons.emoji_emotions_outlined),
            label: 'About Us',
            onTap: () {
              Navigator.of(context).pushNamed(AboutUsScreen.routeName);
            },
          ),
          SpeedDialChild(
            backgroundColor: Theme.of(context).primaryColor,
            labelBackgroundColor:
                Theme.of(context).backgroundColor == Colors.black
                    ? Colors.grey
                    : Colors.white,
            child: const Icon(Icons.people_sharp),
            label: 'New Group',
            onTap: () {
              Navigator.of(context).pushNamed(NewGroupScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
