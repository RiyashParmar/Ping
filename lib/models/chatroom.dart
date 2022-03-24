import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

import '../main.dart';

@Entity()
class ChatRoom {
  int? id = 0;
  String id_;
  String name;
  String type;
  String createdby;
  String dp;
  String description;
  List<String> members;
  List<String> msgs;

  ChatRoom({
    this.id,
    required this.id_,
    required this.name,
    required this.type,
    required this.createdby,
    required this.dp,
    required this.description,
    required this.members,
    required this.msgs,
  });
}

class ChatRooms with ChangeNotifier {
  final List<ChatRoom> _chatrooms = [];

  void refreshRoom(ChatRoom room) {
    _chatrooms.removeWhere((element) => element.id == room.id);
    for (var item in _chatrooms) {
      if (item.id == room.id) {
        _chatrooms.remove(item);
        break;
      }
    }
    _chatrooms.add(room);
    notifyListeners();
  }

  void init() async {
    if (_chatrooms.isEmpty) {
      Query<ChatRoom> query = db.chatroomTb.query().build();
      List<ChatRoom> user = query.find();
      query.close();
      for (var item in user) {
        _chatrooms.add(item);
      }
    }
  }

  void addMsg(ChatRoom room, String msg) {
    room.msgs.add(msg);
    ChatRoom x = ChatRoom(
      id: room.id,
      id_: room.id_,
      name: room.name,
      type: room.type,
      createdby: room.createdby,
      dp: room.dp,
      description: room.description,
      members: room.members,
      msgs: room.msgs,
    );
    db.chatroomTb.put(x);
    _chatrooms.remove(room);
    _chatrooms.add(x);
    notifyListeners();
  }

  void deleteRoom(ChatRoom room) {
    db.chatroomTb.remove(room.id as int);
    _chatrooms.remove(room);
    notifyListeners();
  }

  void clearRoomMsg(ChatRoom a) {
    a.msgs = [];
    ChatRoom room = ChatRoom(
      id_: a.id_,
      name: a.name,
      type: a.type,
      createdby: a.createdby,
      dp: a.dp,
      description: a.description,
      members: a.members,
      msgs: a.msgs,
    );
    db.chatroomTb.put(room);
    _chatrooms.remove(a);
    _chatrooms.add(room);
    notifyListeners();
  }

  void clearAll() {
    var n = _chatrooms.length;
    for (var i = 0; i < n; i++) {
      ChatRoom room = ChatRoom(
        id_: _chatrooms[i].id_,
        name: _chatrooms[i].name,
        type: _chatrooms[i].type,
        createdby: _chatrooms[i].createdby,
        dp: _chatrooms[i].dp,
        description: _chatrooms[i].description,
        members: _chatrooms[i].members,
        msgs: [],
      );
      db.chatroomTb.put(room);
      _chatrooms.removeAt(i);
      _chatrooms.add(room);
    }
    notifyListeners();
  }

  List<String> getMsg(id) {
    List<String> msgs = [];
    for (var item in _chatrooms) {
      if (item.id == id) {
        msgs = [...item.msgs];
      }
    }
    return msgs;
  }

  List getMembers(ChatRoom a) {
    List members = [];
    for (var i = 0; i < _chatrooms.length; i++) {
      if (a.id_ == _chatrooms[i].id_) {
        members = _chatrooms[i].members;
      }
    }
    return members;
  }

  ChatRoom getRoom(ChatRoom r) {
    for (var i = 0; i < _chatrooms.length; i++) {
      if (_chatrooms[i].id_ == r.id_) {
        r = _chatrooms[i];
      }
    }
    return r;
  }

  void addRoom(ChatRoom room) {
    db.chatroomTb.put(room);
    _chatrooms.add(room);
    notifyListeners();
  }

  List<ChatRoom> get getRooms {
    return [..._chatrooms];
  }
}
