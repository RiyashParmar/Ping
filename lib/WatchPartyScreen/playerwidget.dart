// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../main.dart';

class Player extends StatefulWidget {
  const Player({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: 'S0NwPJBn1vY',
      flags: const YoutubePlayerFlags(autoPlay: false, hideControls: true));
  late final RTCPeerConnection peerConnection;

  late TextEditingController _controller1;
  late TextEditingController _controller2;
  final GlobalKey<FormFieldState> _key = GlobalKey();

  List<String> msgs = [];
  bool voice = false;
  bool play = false;
  bool init = true;

  var iceServers = {
    'servers': [
      {'url': 'stun:stun.l.google.com:19302'},
      {'url': 'stun:stun1.l.google.com:19302'},
      {'url': 'stun:stun2.l.google.com:19302'},
      {'url': 'stun:stun3.l.google.com:19302'},
      {'url': 'stun:stun4.l.google.com:19302'},
    ]
  };

  void createoffer() async {
    final offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);
    socket.emit('connection', {'offer': json.encode(offer.toMap())});
  }

  void createConnection() async {
    peerConnection = await createPeerConnection(iceServers);

    peerConnection.onIceCandidate = (event) {
      if (event.candidate != null) {
        socket.emit('connection', {'iceCandidate': event.candidate});
      }
    };

    peerConnection.onRenegotiationNeeded = () {
      createoffer();
    };
  }

  @override
  void initState() {
    super.initState();
    createConnection();
    _controller1 = TextEditingController();
    _controller2 = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;

    if (init) {
      init = false;
      socket.on('event', (data) {
        if (data['eve'] == 'play') {
          controller.play();
          setState(() {
            play = !play;
          });
          // DateTime d = DateTime.parse(data['time']);
          // Timer(d.difference(DateTime.now()), () => controller.play());
        } else if (data['eve'] == 'pause') {
          // () {
          //   controller.seekTo(data['time']);
          // };
          controller.pause();
          setState(() {
            play = !play;
          });
          //controller.seekTo(data['time']);
        } else if (data['eve'] == 'load') {
          String? videoid = YoutubePlayer.convertUrlToId(data['url']);
          controller.load(videoid!);
          controller.pause();
          setState(() {
            
          });
        } else if (data['eve'] == 'msg') {
          setState(() {
            msgs.add(data['msg']);
          });
        }
      });

      socket.on(
        'connection',
        (message) async {
          if (message.offer) {
            if (peerConnection == null) {
              createConnection();
            }
            final RTCSessionDescription remoteDescription =
                RTCSessionDescription(json.decode(message.offer), 'offer');
            await peerConnection.setRemoteDescription(remoteDescription);
            final answer = await peerConnection.createAnswer();
            await peerConnection.setLocalDescription(answer);
            socket.emit('connection', {'answer': json.encode(answer)});
          } else if (message.answer) {
            final RTCSessionDescription remoteDescription =
                RTCSessionDescription(json.decode(message.answer), 'answer');
            await peerConnection.setRemoteDescription(remoteDescription);
          } else if (message.iceCandidate) {
            if (peerConnection == null) {
              createConnection();
            } else {
              await peerConnection.addCandidate(message.iceCandidate);
            }
          }
        },
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: play ? const Text('Pause') : const Text('Play'),
                    onPressed: () {
                      if (play) {
                        setState(() {
                          play = !play;
                        });
                        socket.emit('event', {
                          'username': widget.username,
                          'eve': 'pause',
                          'time': controller.value
                        });
                        controller.pause();
                      } else {
                        setState(() {
                          play = !play;
                        });
                        // DateTime d =
                        //     DateTime.now().add(const Duration(seconds: 5));
                        // Timer(d.difference(DateTime.now()),
                        //     () => controller.play());
                        socket.emit('event', {
                          'username': widget.username,
                          'eve': 'play',
                          // 'time': d.toString()
                        });
                        controller.play();
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Text('CHANGE'),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return BottomSheet(
                            onClosing: () {},
                            builder: (ctx) {
                              return Column(
                                children: [
                                  TextFormField(
                                    key: _key,
                                    controller: _controller1,
                                    keyboardType: TextInputType.url,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color as Color,
                                        ),
                                      ),
                                      hintText: '  Enter Url',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .color,
                                      ),
                                      //errorText: _validate ? null : 'Invalid',
                                    ),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Enter a URL';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  ElevatedButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      if (_key.currentState!.validate()) {
                                        setState(
                                          () {
                                            String? videoid =
                                                YoutubePlayer.convertUrlToId(
                                                    _controller1.text);
                                            socket.emit('event', {
                                              'username': widget.username,
                                              'eve': 'load',
                                              'url': _controller1.text,
                                            });
                                            controller.load(videoid!);
                                            controller.pause();
                                            _controller1.clear();
                                          },
                                        );
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Full-Screen'),
                    onPressed: () {
                      controller.toggleFullScreenMode();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: media.size.height -
                  media.viewPadding.top -
                  sp * 0.4 -
                  MediaQuery.of(context).viewInsets.bottom,
              width: media.size.width,
              child: ListView.builder(
                itemCount: msgs.length,
                itemBuilder: (ctx, i) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: sp * 0.01,
                      left: msgs[i].startsWith('0') ? sp * 0.09 : sp * 0.005,
                      right: msgs[i].startsWith('0') ? sp * 0.005 : sp * 0.09,
                      bottom: sp * 0.01,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: msgs[i].startsWith('0')
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        msgs[i].substring(0, 1) == '0'
                            ? Text(
                                msgs[i].substring(2, 13),
                                style: TextStyle(fontSize: sp * 0.015),
                              )
                            : const Padding(padding: EdgeInsets.zero),
                        msgs[i].substring(0, 1) == '0'
                            ? SizedBox(width: sp * 0.01)
                            : const Padding(padding: EdgeInsets.zero),
                        Container(
                          constraints: BoxConstraints(maxWidth: sp * 0.30),
                          padding: EdgeInsets.all(sp * 0.013),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: sp * 0.005,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(sp * 0.02),
                            color: Theme.of(context).backgroundColor,
                          ),
                          child: Text(msgs[i].substring(16)),
                        ),
                        msgs[i].substring(0, 1) == '1'
                            ? SizedBox(width: sp * 0.01)
                            : const Padding(padding: EdgeInsets.zero),
                        msgs[i].substring(0, 1) == '1'
                            ? Text(
                                msgs[i].substring(2, 13),
                                style: TextStyle(fontSize: sp * 0.015),
                              )
                            : const Padding(padding: EdgeInsets.zero),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 2,
                      child: IconButton(
                        icon: voice
                            ? const Icon(Icons.mic)
                            : const Icon(Icons.mic_off),
                        onPressed: () {
                          if (voice) {
                            peerConnection.close();
                          } else {}
                          setState(() {
                            voice = !voice;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: SizedBox(
                        width: sp * 0.0045,
                        child: TextField(
                          controller: _controller2,
                          enableInteractiveSelection: true,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Theme.of(context).iconTheme.color),
                            hintText: 'Type to Text',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: IconButton(
                        icon: const Icon(Icons.send_sharp),
                        onPressed: () {
                          var timestamp = DateFormat("hh:mm:ss-a")
                              .format(DateTime.now())
                              .toString();
                          String msg =
                              '0 ' + timestamp + ' T ' + _controller2.text;
                          String _msg =
                              '1 ' + timestamp + ' T ' + _controller2.text;
                          setState(() {
                            msgs.add(msg);
                          });
                          socket.emit('event', {
                            'eve': 'msg',
                            'username': widget.username,
                            'msg': _msg
                          });
                          _controller2.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
