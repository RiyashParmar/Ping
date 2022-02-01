// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:share_plus/share_plus.dart';

import 'searchscreen.dart';
import '../NewConversationScreen/newconversationscreen.dart';
import '../SettingsScreen/settingsscreen.dart';
import '../SettingsScreen/helpscreen.dart' as h;
import '../NewBroadcastScreen/newbroadcastscreen.dart';
import '../NewGroupScreen/newgroupscreen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  bool open = false;

  void update() {
    setState(() {
      open = !open;
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return SizedBox(
      height: sp * 0.079,
      width: media.size.width,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(media.size.height * 0.2),
          color: Theme.of(context).backgroundColor == Colors.black
              ? Colors.black
              : Theme.of(context).primaryColor,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Search.routeName);
                },
                icon: const Icon(
                  Icons.search_sharp,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'PING',
                  style: TextStyle(
                    fontSize: sp * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              flex: 9,
            ),
            Expanded(
              flex: 2,
              child: open
                  ? Button(update: update, sp: sp)
                  : SpeedDial(
                      foregroundColor: Theme.of(context).iconTheme.color,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      renderOverlay: false,
                      spaceBetweenChildren: sp * 0.009,
                      spacing: sp * 0.009,
                      onClose: () {
                        setState(() {
                          open = !open;
                        });
                      },
                      child: const Icon(Icons.more_vert_sharp),
                      children: [
                        SpeedDialChild(
                          backgroundColor: Theme.of(context).primaryColor,
                          labelBackgroundColor:
                              Theme.of(context).backgroundColor == Colors.black
                                  ? Colors.grey
                                  : Colors.white,
                          child: const Icon(
                            Icons.chat,
                          ),
                          label: 'New Conversation',
                          onTap: () {
                            open = !open;
                            Navigator.of(context)
                                .pushNamed(NewConversationScreen.routeName);
                          },
                        ),
                        SpeedDialChild(
                          backgroundColor: Theme.of(context).primaryColor,
                          labelBackgroundColor:
                              Theme.of(context).backgroundColor == Colors.black
                                  ? Colors.grey
                                  : Colors.white,
                          child: const Icon(
                            Icons.bug_report,
                          ),
                          label: 'Report Problems',
                          onTap: () {
                            open = !open;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const h.Report(),
                              ),
                            );
                          },
                        ),
                        SpeedDialChild(
                          backgroundColor: Theme.of(context).primaryColor,
                          labelBackgroundColor:
                              Theme.of(context).backgroundColor == Colors.black
                                  ? Colors.grey
                                  : Colors.white,
                          child: const Icon(
                            Icons.help_sharp,
                          ),
                          label: 'App-Guide',
                          onTap: () {
                            open = !open;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => const h.Guide(),
                              ),
                            );
                          },
                        ),
                        SpeedDialChild(
                          backgroundColor: Theme.of(context).primaryColor,
                          labelBackgroundColor:
                              Theme.of(context).backgroundColor == Colors.black
                                  ? Colors.grey
                                  : Colors.white,
                          child: const Icon(
                            Icons.settings,
                          ),
                          label: 'Settings',
                          onTap: () {
                            open = !open;
                            Navigator.of(context)
                                .pushNamed(SettingsScreen.routeName);
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({Key? key, required this.update, required this.sp})
      : super(key: key);
  final VoidCallback update;
  final double sp;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      isOpenOnStart: true,
      foregroundColor: Theme.of(context).iconTheme.color,
      backgroundColor: Colors.transparent,
      elevation: 0,
      renderOverlay: false,
      spaceBetweenChildren: sp * 0.009,
      spacing: sp * 0.009,
      onClose: () {
        update();
      },
      child: const Icon(
        Icons.more_vert_sharp,
      ),
      children: [
        SpeedDialChild(
          backgroundColor: Theme.of(context).primaryColor,
          labelBackgroundColor:
              Theme.of(context).backgroundColor == Colors.black
                  ? Colors.grey
                  : Colors.white,
          child: const Icon(
            Icons.volume_up,
          ),
          label: 'New Broadcast',
          onTap: () =>
              Navigator.of(context).pushNamed(NewBroadcastScreen.routeName),
        ),
        SpeedDialChild(
          backgroundColor: Theme.of(context).primaryColor,
          labelBackgroundColor:
              Theme.of(context).backgroundColor == Colors.black
                  ? Colors.grey
                  : Colors.white,
          child: const Icon(
            Icons.people,
          ),
          label: 'New Group',
          onTap: () =>
              Navigator.of(context).pushNamed(NewGroupScreen.routeName),
        ),
        SpeedDialChild(
          backgroundColor: Theme.of(context).primaryColor,
          labelBackgroundColor:
              Theme.of(context).backgroundColor == Colors.black
                  ? Colors.grey
                  : Colors.white,
          child: const Icon(
            Icons.feedback,
          ),
          label: 'Feedback',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const h.Feedback(),
              ),
            );
          },
        ),
        SpeedDialChild(
          backgroundColor: Theme.of(context).primaryColor,
          labelBackgroundColor:
              Theme.of(context).backgroundColor == Colors.black
                  ? Colors.grey
                  : Colors.white,
          child: const Icon(
            Icons.share,
          ),
          label: 'Share',
          onTap: () {
            Share.share('Hey use these amazing app');
          },
        ),
      ],
    );
  }
}
