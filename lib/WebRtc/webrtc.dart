// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as s;

//import '../models/chatroom.dart';
//import '../models/user.dart';

String ip = 'http://192.168.43.62:3000';
//String ip = 'http://10.0.2.2:3000';

class WebRtc {
  void connect() async {
    late final RTCPeerConnection peerConnection;
    RTCDataChannel dataChannel;

    s.Socket socket = s.io(
        ip,
        s.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());

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
      RTCDataChannelInit init = RTCDataChannelInit();
      dataChannel = await peerConnection.createDataChannel('dataChannel', init);

      peerConnection.onIceCandidate = (event) {
        if (event.candidate != null) {
          socket.emit('connection', {'iceCandidate': event.candidate});
        }
      };

      peerConnection.onRenegotiationNeeded = () {
        createoffer();
      };

      peerConnection.onDataChannel = (event) {
        dataChannel = event;
      };

      dataChannel.onMessage = (event) {
        /*String message = event.text;
        Users a = Users();
        a.addMsg(user, message);*/
      };
      //dataChannel.stateChangeStream = (event) {};
      //dataChannel.onDataChannelState = (event) {};
    }

    socket.connect();
    createConnection();

    socket.on('connection', (message) async {
      //print('Connect: ${socket.id}');
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
          try {
            await peerConnection.addCandidate(message.iceCandidate);
          } catch (e) {
            rethrow;
          }
        }
      }
    });
  }
}
