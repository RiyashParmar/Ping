// ignore_for_file: must_be_immutable, unnecessary_null_comparison
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:provider/provider.dart';

// import '../models/user.dart';
// import '../models/mydata.dart';
import '../main.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({Key? key, required this.user, required this.mode})
      : super(key: key);
  final String user;
  final bool mode;
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late final RTCPeerConnection peerConnection;
  //late final RTCDataChannel dataChannel;

  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  MediaStream? _localStream;
  MediaStream? _remoteStream;

  final key = GlobalKey();

  bool inCalling = false;
  bool video = true;
  bool voice = true;
  bool back = true;

  var iceServers = {
    'servers': [
      {'url': 'stun:stun.l.google.com:19302'},
      {'url': 'stun:stun1.l.google.com:19302'},
      {'url': 'stun:stun2.l.google.com:19302'},
      {'url': 'stun:stun3.l.google.com:19302'},
      {'url': 'stun:stun4.l.google.com:19302'},
    ]
  };

  void getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };
    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = null;
    _localRenderer.srcObject = _localStream;
    setState(() {});
  }

  void createoffer() async {
    final offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);
    socket.emit('connection',
        {'username': widget.user, 'offer': json.encode(offer.toMap())});
  }

  void createConnection() async {
    peerConnection = await createPeerConnection(iceServers);

    peerConnection.onIceCandidate = (event) {
      print('----------------------------------------------');
      if (event.candidate != null) {
        socket.emit('connection',
            {'username': widget.user, 'iceCandidate': event.candidate});
      }
    };

    peerConnection.onRenegotiationNeeded = () {
      createoffer();
    };

    peerConnection.onTrack = (event) {
      _remoteStream!.addTrack(event.track);
      _remoteRenderer.srcObject = null;
      _remoteRenderer.srcObject = _remoteStream;
      setState(() {});
    };

    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        peerConnection.addTrack(track, _remoteStream as MediaStream);
      });
    }
  }

  // void _toggleCamera() async {
  //   if (_localStream == null) throw Exception('Stream is not initialized');

  //   final videoTrack = _localStream!
  //       .getVideoTracks()
  //       .firstWhere((track) => track.kind == 'video');
  //   await Helper.switchCamera(videoTrack);
  // }

  hangUp() async {
    await _localStream!.dispose();
    _localRenderer.srcObject = null;
    inCalling = false;
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    getUserMedia();
    initRenderers();
  }

  @override
  void dispose() {
    super.dispose();
    if (inCalling) {
      hangUp();
    }
    hangUp();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    socket.on('connection', (message) async {
      //print('Connect: ${socket.id}');
      if (message['rejected']) {
        // show call rejected...
      } else if (message['answer']) {
        final RTCSessionDescription remoteDescription =
            RTCSessionDescription(json.decode(message.answer), 'answer');
        await peerConnection.setRemoteDescription(remoteDescription);
      } else if (message['offer']) {
        if (_localStream == null) {
          //ask to continue
          getUserMedia();
          // if no then- socket.emit('connection', {'rejected':true});
        }
        if (peerConnection == null) {
          createConnection();
        }
        final RTCSessionDescription remoteDescription =
            RTCSessionDescription(json.decode(message.offer), 'offer');
        await peerConnection.setRemoteDescription(remoteDescription);
        final answer = await peerConnection.createAnswer();
        await peerConnection.setLocalDescription(answer);
        socket.emit('connection',
            {'username': widget.user, 'answer': json.encode(answer)});
      } else if (message['iceCandidate']) {
        if (peerConnection == null) {
          createConnection();
        }
        await peerConnection.addCandidate(message.iceCandidate);
      }
    });

    widget.mode ? createConnection() : null;

    final appBar = AppBar(
      title: Text(video ? 'Video Call' : 'Voice Call'),
    );
    final bottomNavigationBar = PreferredSize(
      preferredSize: Size.fromHeight(appBar.preferredSize.height),
      child: Row(
        key: key,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(voice ? Icons.mic : Icons.mic_off),
            onPressed: () {
              setState(() {
                voice = !voice;
              });
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
            icon:
                Icon(back ? Icons.video_camera_back : Icons.video_camera_front),
            onPressed: () {
              setState(() {
                back = !back;
              });
            },
          )
        ],
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: RTCVideoView(_remoteRenderer, mirror: true),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              child: RTCVideoView(_localRenderer, mirror: true),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
