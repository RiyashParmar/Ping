// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';

//import '../WebRtc/webrtc.dart';
import '../models/user.dart';
import '../models/mydata.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key, required this.user}) : super(key: key);
  final String user;
  //bool mode;
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  final key = GlobalKey();
  bool _inCalling = false;
  List<MediaDeviceInfo>? _mediaDevicesList;

  bool video = true;
  bool voice = true;
  bool back = true;

  void initRenderers() async {
    await _localRenderer.initialize();
  }

  void _makeCall() async {
    final mediaConstraints = <String, dynamic>{
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    try {
      var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
      _localStream = stream;
      _localRenderer.srcObject = _localStream;
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;

    setState(() {
      _inCalling = true;
    });
  }

  void _hangUp() async {
    try {
      await _localStream?.dispose();
      _localRenderer.srcObject = null;
      setState(() {
        _inCalling = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _toggleCamera() async {
    if (_localStream == null) throw Exception('Stream is not initialized');

    final videoTrack = _localStream!
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');
    await Helper.switchCamera(videoTrack);
  }

  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  @override
  void dispose() {
    super.dispose();
    if (_inCalling) {
      _hangUp();
    }
    _localRenderer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    final me = Provider.of<My>(context);
    final MediaQueryData media = MediaQuery.of(context);

    final appBar = AppBar(
      title: Text(video ? 'Video Call' : 'Voice Call'),
      /*actions: [
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
      ],*/
    );
    final bottomNavigationBar = PreferredSize(
      preferredSize: Size.fromHeight(appBar.preferredSize.height),
      child: _inCalling ? Row(
        key: key,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          /*IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () {},
                ),*/
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
            icon:
                Icon(back ? Icons.video_camera_back : Icons.video_camera_front),
            onPressed: () {
              setState(() {
                back = !back;
              });
            },
          )
        ],
      ) : const Padding(padding: EdgeInsets.zero),
      /*: Row(
              key: key,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /*IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () {},
                ),*/
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
            ),*/
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Center(child: RTCVideoView(_localRenderer, mirror: true)),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
