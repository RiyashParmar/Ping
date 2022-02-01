import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Helpers/users.dart';
import 'momemtbarwidget.dart';
import 'activeconversationwidget.dart';
import 'bottombarwidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routename = '/Home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    user.getcontacts();
    List<User> users = user.users;
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;

    return Scaffold(
      body: SizedBox(
        height: media.size.height,
        width: media.size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: media.viewPadding.bottom + (sp * 0.01),
                  right: media.viewPadding.right + (sp * 0.01),
                  left: media.viewPadding.left + (sp * 0.01),
                  top: media.viewPadding.top + (sp * 0.01),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(sp * 0.015),
                    ),
                    color: Theme.of(context).backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: sp * 0.4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      MomentBar(users: users),
                      Divider(
                        thickness: sp * 0.005,
                        color: Theme.of(context).backgroundColor == Colors.black
                            ? Colors.grey
                            : null,
                      ),
                      ActiveConversation(users: users),
                    ],
                  ),
                ),
              ),
              const BottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
