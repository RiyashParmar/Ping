import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

import '../models/mydata.dart';

import 'profilewidget.dart';
import 'generalwidget.dart';
import 'conversationwidget.dart';
import 'notificationwidget.dart' as n;
//import 'helpscreen.dart';
//import 'aboutusscreen.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const routeName = '/Settings';
  // ignore: prefer_typing_uninitialized_variables

  @override
  Widget build(BuildContext context) {
    final mydata = Provider.of<My>(context);
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    final me = mydata.getMe;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(
              top: sp * 0.03,
              left: sp * 0.03,
              right: sp * 0.02,
              bottom: sp * 0.01,
            ),
            leading: CircleAvatar(
              backgroundImage: FileImage(File(me.dp)),
              radius: sp * 0.04,
            ),
            title: Text(
              'My Profile',
              style: TextStyle(
                fontSize: sp * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text('Edit Profile Details'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const Profile(),
                ),
              );
            },
          ),
          Divider(thickness: sp * 0.002, color: Colors.grey),
          ListTile(
            contentPadding: EdgeInsets.only(
              top: sp * 0.01,
              left: sp * 0.05,
              right: sp * 0.02,
              bottom: sp * 0.01,
            ),
            leading: const Icon(Icons.vpn_key_rounded),
            title: Text(
              'General',
              style: TextStyle(
                fontSize: sp * 0.025,
              ),
            ),
            subtitle: const Text('Security, Privacy, Change-Number'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const General(),
                ),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.only(
              top: sp * 0.01,
              left: sp * 0.05,
              right: sp * 0.02,
              bottom: sp * 0.01,
            ),
            leading: const Icon(Icons.chat_rounded),
            title: Text(
              'Conversation',
              style: TextStyle(
                fontSize: sp * 0.025,
              ),
            ),
            subtitle: const Text('Wallpaper, History, Theme'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const Conversation(),
                ),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.only(
              top: sp * 0.01,
              left: sp * 0.05,
              right: sp * 0.02,
              bottom: sp * 0.01,
            ),
            leading: const Icon(Icons.notifications_active),
            title: Text(
              'Notification',
              style: TextStyle(
                fontSize: sp * 0.025,
              ),
            ),
            subtitle: const Text('Call and Text tones'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const n.Notification(),
                ),
              );
            },
          ),
          /*ListTile(
            contentPadding: EdgeInsets.only(
              top: sp * 0.01,
              left: sp * 0.05,
              right: sp * 0.02,
              bottom: sp * 0.01,
            ),
            leading: const Icon(Icons.help),
            title: Text(
              'Help',
              style: TextStyle(
                fontSize: sp * 0.025,
              ),
            ),
            subtitle: const Text('Help Center'),
            onTap: () => Navigator.of(context).pushNamed(HelpScreen.routeName),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(
              top: sp * 0.01,
              left: sp * 0.05,
              right: sp * 0.02,
              bottom: sp * 0.01,
            ),
            leading: const Icon(Icons.emoji_emotions),
            title: Text(
              'About Us',
              style: TextStyle(
                fontSize: sp * 0.025,
              ),
            ),
            subtitle: const Text('Know your devs'),
            onTap: () =>
                Navigator.of(context).pushNamed(AboutUsScreen.routeName),
          ),*/
          ListTile(
            contentPadding: EdgeInsets.only(
              top: sp * 0.01,
              left: sp * 0.05,
              right: sp * 0.02,
              bottom: sp * 0.01,
            ),
            leading: const Icon(Icons.share_sharp),
            title: Text(
              'Share',
              style: TextStyle(
                fontSize: sp * 0.025,
              ),
            ),
            subtitle: const Text('Spread the word'),
            onTap: () {
              Share.share('Hey use these amazing app');
            },
          ),
        ],
      ),
    );
  }
}
