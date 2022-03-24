import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

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
  late RTCPeerConnection _peerConnection;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  MediaStream? _localStream;
  MediaStream? _remoteStream;

  final key = GlobalKey();

  bool video = true;
  bool voice = true;
  bool back = true;
  bool check = true;

  var iceServers = {
    'servers': [
      {'url': 'stun:stun.l.google.com:19302'},
      {'url': 'stun:stun1.l.google.com:19302'},
      {'url': 'stun:stun2.l.google.com:19302'},
      {'url': 'stun:stun3.l.google.com:19302'},
      {'url': 'stun:stun4.l.google.com:19302'},
    ]
  };

  void _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };
    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = null;
    _localRenderer.srcObject = _localStream;
    _localStream!.getTracks().forEach((track) {
      _peerConnection.addTrack(track, _localStream!);
    });
    setState(() {});
  }

  void _createoffer() async {
    final offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);
    socket.emit('connection',
        {'username': widget.user, 'offer': offer.sdp, 'type': offer.type});
  }

  void _createConnection() async {
    _peerConnection = await createPeerConnection(iceServers);

    _peerConnection.onIceCandidate = (event) {
      if (event.candidate != null) {
        socket.emit(
          'connection',
          {
            'username': widget.user,
            'candidate': event.candidate,
            'sdpMid': event.sdpMid,
            'sdpMLineIndex': event.sdpMLineIndex
          },
        );
      }
    };

    //widget.mode ? _createoffer() : null;

    _peerConnection.onRenegotiationNeeded = () {
      widget.mode ? _createoffer() : null;
    };

    _peerConnection.onTrack = (event) {
      _remoteStream?.addTrack(event.track);
      _remoteRenderer.srcObject = null;
      _remoteRenderer.srcObject = _remoteStream;
      setState(() {});
    };

    _peerConnection.onConnectionState = (event) {
      if (event == ConnectionState.done) {
        print(
            '------------------------------------------------------------------------------------');
        _localStream!.getTracks().forEach((track) {
          _peerConnection.addTrack(track, _localStream!);
        });
      }
    };
  }

  void _toggleCamera() async {
    if (_localStream == null) throw Exception('Stream is not initialized');

    final videoTrack = _localStream!
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');
    await Helper.switchCamera(videoTrack);
  }

  void _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    _initRenderers();
    _getUserMedia();
    _createConnection();
  }

  @override
  void dispose() {
    super.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    socket.on('connection', (message) async {
      if (message['rejected'] != null) {
        // show call rejected...
      } else if (message['answer'] != null) {
        final RTCSessionDescription remoteDescription =
            RTCSessionDescription(message['answer'], message['type']);
        await _peerConnection.setRemoteDescription(remoteDescription);
      } else if (message['offer'] != null) {
        if (_localStream == null) {
          //ask to continue
          _getUserMedia();
          // if no then- socket.emit('connection', {'rejected':true});
        }
        // if (_peerConnection == null) {
        //   _createConnection();
        // }

        final RTCSessionDescription remoteDescription =
            RTCSessionDescription(message['offer'], message['type']);
        await _peerConnection.setRemoteDescription(remoteDescription);
        final answer = await _peerConnection.createAnswer();
        await _peerConnection.setLocalDescription(answer);
        socket.emit('connection', {
          'username': widget.user,
          'answer': answer.sdp,
          'type': answer.type
        });
      } else if (message['candidate'] != null) {
        // if (_peerConnection == null) {
        //   _createConnection();
        // }
        RTCIceCandidate iceCandidate = RTCIceCandidate(
            message['candidate'], message['sdpMid'], message['sdpMLineIndex']);
        await _peerConnection.addCandidate(iceCandidate);
      }
    });

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
              if (voice) {
                var track = _localStream?.getAudioTracks();
                track?.forEach((element) {
                  element.enabled = false;
                });
              } else {
                var track = _localStream?.getAudioTracks();
                track?.forEach((element) {
                  element.enabled = true;
                });
              }
              setState(() {
                voice = !voice;
              });
            },
          ),
          IconButton(
            icon: Icon(video ? Icons.videocam : Icons.videocam_off),
            onPressed: () {
              if (video) {
                var track = _localStream?.getVideoTracks();
                track?.forEach((element) {
                  element.enabled = false;
                });
              } else {
                var track = _localStream?.getVideoTracks();
                track?.forEach((element) {
                  element.enabled = true;
                });
              }
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
              _toggleCamera();
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
