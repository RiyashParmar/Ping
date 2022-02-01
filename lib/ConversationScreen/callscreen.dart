// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  CallScreen({Key? key, required this.user, required this.mode})
      : super(key: key);
  final String user;
  bool mode;
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final key = GlobalKey();
  bool video = true;
  bool voice = true;
  bool back = true;
  List<String> person = ['Person1'];

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text(widget.mode ? 'Video Call' : 'Voice Call'),
      actions: [
        IconButton(
          icon: Icon(widget.mode ? Icons.call : Icons.videocam),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                      'Switch to ${widget.mode ? 'Voice Call' : 'Video Call'}'),
                  content: const Text('Switch the call mode?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          widget.mode = !widget.mode;
                        });
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text('Requesting the callee to accept'),
                          ),
                        );
                      },
                      child: const Text('SWITCH'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {},
        ),
      ],
    );
    final bottomNavigationBar = PreferredSize(
      child: widget.mode
          ? Row(
              key: key,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(voice ? Icons.mic : Icons.mic_off),
                  onPressed: () {
                    setState(() {
                      voice = !voice;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('Call Ended'),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(video ? Icons.videocam : Icons.videocam_off),
                  onPressed: () {
                    setState(() {
                      video = !video;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(back
                      ? Icons.video_camera_back
                      : Icons.video_camera_front),
                  onPressed: () {
                    setState(() {
                      back = !back;
                    });
                  },
                )
              ],
            )
          : Row(
              key: key,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text('Call Ended'),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(voice ? Icons.mic : Icons.mic_off),
                  onPressed: () {
                    setState(() {
                      voice = !voice;
                    });
                  },
                ),
              ],
            ),
      preferredSize: Size.fromHeight(appBar.preferredSize.height),
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          SizedBox(
            height: media.size.height -
                media.viewPadding.top -
                appBar.preferredSize.height -
                bottomNavigationBar.preferredSize.height -
                media.viewPadding.bottom,
            width: media.size.width,
            child: GridView.builder(
                itemCount: person.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (ctx, i) {
                  return const Text('hii');
                }),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
