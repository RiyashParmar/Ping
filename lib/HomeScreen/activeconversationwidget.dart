import 'package:flutter/material.dart';
import '../ConversationScreen/conversationscreen.dart';

class ActiveConversation extends StatelessWidget {
  const ActiveConversation({Key? key, required this.users}) : super(key: key);
  final List users;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return SizedBox(
      height: media.size.height * 0.739,
      width: media.size.width,
      child: users.isEmpty
          ? Center(
              child: Text(
                'NO CONVERSATIONS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: sp * 0.02,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.zero,
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
                  trailing: Text(
                    '${DateTime(2022, 1, 1)}',
                  ),
                );
              },
              itemCount: users.length,
            ),
    );
  }
}
