// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart' as p;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:file_picker/file_picker.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ConversationBar extends StatefulWidget {
  ConversationBar({Key? key, this.update}) : super(key: key);
  var update;
  @override
  State<ConversationBar> createState() => _ConversationState();
}

class _ConversationState extends State<ConversationBar> {
  late final TextEditingController controller;
  final recorder = Record();
  bool voice = false;
  int mt = 0;
  int mo = 0;
  int st = 0;
  int so = 0;

  void location() async {
    Location location = Location();

    if (await location.serviceEnabled() == false) {
      location.requestService();
    } else if (await location.serviceEnabled() == false) {
      return;
    }

    if (await location.hasPermission() == PermissionStatus.denied) {
      location.requestPermission();
    } else if (await location.hasPermission() == PermissionStatus.denied) {
      return;
    }

    final loc = await location.getLocation();
    AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: Uri.encodeFull(
          'http://maps.google.com/maps?saddr=${loc.latitude},${loc.longitude}&daddr=${loc.latitude},${loc.longitude}'),
    ).launch();
  }

  void watch() {
    so++;
    if (so <= 9) {
      mounted ? setState(() {}) : null;
    } else if (so >= 10) {
      so = 0;
      st < 5 ? st++ : st = 0;
      mounted
          ? setState(() {
              if (st == 0 && so == 0) {
                mo < 9 ? mo++ : mo = 0;
                mounted
                    ? setState(() {
                        if (mo == 0 && st == 0 && so == 0) {
                          mt < 5 ? mt++ : mt = 0;
                        }
                      })
                    : null;
              }
            })
          : null;
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;
    return SizedBox(
      height: sp * 0.07,
      width: media.size.width * 0.97,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sp * 0.04),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: sp * 0.005,
            ),
          ],
        ),
        child: voice
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await recorder.stop();
                        setState(() {
                          voice = !voice;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Text('$mt$mo:$st$so'),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.send_sharp),
                      onPressed: () async {
                        await recorder.stop();
                        var timestamp = DateFormat("hh:mm:ss a")
                            .format(DateTime.now())
                            .toString();
                        widget.update != null
                            ? widget.update(controller.text, timestamp)
                            : null;
                        controller.clear();
                        setState(() {
                          voice = !voice;
                        });
                      },
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return BottomSheet(
                              onClosing: () {},
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text('Take a picture'),
                                      onTap: () {},
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.videocam),
                                      title: const Text('Record a video'),
                                      onTap: () {},
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.library_add),
                                      title: const Text('Pick from gallery'),
                                      onTap: () {},
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.camera),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      width: sp * 0.0045,
                      child: TextField(
                        controller: controller,
                        enableInteractiveSelection: true,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: Theme.of(context).iconTheme.color),
                          hintText: 'Type to Text',
                          border: InputBorder.none,
                        ),
                        onChanged: (s) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: SpeedDial(
                      foregroundColor: Theme.of(context).iconTheme.color,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      renderOverlay: false,
                      spaceBetweenChildren: sp * 0.009,
                      spacing: sp * 0.009,
                      child: const Icon(Icons.push_pin),
                      children: [
                        SpeedDialChild(
                          backgroundColor: Theme.of(context).primaryColor,
                          labelBackgroundColor:
                              Theme.of(context).backgroundColor == Colors.black
                                  ? Colors.grey
                                  : Colors.white,
                          child: const Icon(Icons.play_circle),
                          label: 'Send Media or Files',
                          onTap: () async {
                            await FilePicker.platform.pickFiles(
                                type: FileType.any, allowMultiple: true);
                          },
                        ),
                        SpeedDialChild(
                          backgroundColor: Theme.of(context).primaryColor,
                          labelBackgroundColor:
                              Theme.of(context).backgroundColor == Colors.black
                                  ? Colors.grey
                                  : Colors.white,
                          child: const Icon(Icons.location_on),
                          label: 'Send Location',
                          onTap: () {
                            location();
                          },
                        ),
                        SpeedDialChild(
                          backgroundColor: Theme.of(context).primaryColor,
                          labelBackgroundColor:
                              Theme.of(context).backgroundColor == Colors.black
                                  ? Colors.grey
                                  : Colors.white,
                          child: const Icon(Icons.people),
                          label: 'Send Contact',
                          onTap: () async {
                            AndroidIntent(
                              action: 'android.intent.action.VIEW',
                              data: Uri.encodeFull('content://contacts/people'),
                            ).launch();
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: controller.text.isEmpty
                        ? IconButton(
                            icon: const Icon(Icons.mic),
                            onPressed: () async {
                              if (await p.Permission.microphone.isGranted) {
                                setState(() {
                                  voice = !voice;
                                });
                                Directory? dir =
                                    await getExternalStorageDirectory();
                                String file = '';
                                var timestamp = DateFormat("/hh:mm:ss a")
                                        .format(DateTime.now())
                                        .toString() +
                                    '.mp3';
                                dir!.path.isNotEmpty
                                    ? file = dir.path + timestamp
                                    : null;
                                await recorder.start(path: file);
                              } else {
                                await p.Permission.microphone.request();
                                if (await p.Permission.microphone.isGranted) {
                                  setState(() {
                                    voice = !voice;
                                  });
                                  Directory? dir =
                                      await getExternalStorageDirectory();
                                  String file = '';
                                  var timestamp = DateFormat("/hh:mm:ss a")
                                          .format(DateTime.now())
                                          .toString() +
                                      '.mp3';
                                  dir!.path.isNotEmpty
                                      ? file = dir.path + timestamp
                                      : null;
                                  await recorder.start(path: file);
                                }
                              }
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.send_sharp),
                            onPressed: () {
                              var timestamp = DateFormat("hh:mm:ss a")
                                  .format(DateTime.now())
                                  .toString();
                              widget.update != null
                                  ? widget.update(controller.text, timestamp)
                                  : null;
                              controller.clear();
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
