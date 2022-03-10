import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:objectbox/objectbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart';
import '../main.dart';

String ip = 'http://192.168.43.62:3000';
//String ip = 'http://10.0.2.2:3000';

@Entity()
class User {
  int? id = 0;
  String username;
  String name;
  String number;
  String dp;
  String bio;
  List<String> msgs;
  List<String> moments;

  User({
    this.id,
    required this.username,
    required this.name,
    required this.number,
    required this.dp,
    required this.bio,
    required this.msgs,
    required this.moments,
  });
}

class Users with ChangeNotifier {
  final List<User> _users = [];

  void refreshUser(User user) {
    _users.removeWhere((element) => element.username == user.username);
    _users.add(user);
    notifyListeners();
  }

  void updateUsers() async {
    if (await Permission.contacts.isGranted) {
      var checkList = [..._users];
      var cnt = await FlutterContacts.getContacts(withProperties: true);
      cnt.removeWhere((element) => element.phones.isEmpty);

      List<String> contacts = [];
      for (var i = 0; i < cnt.length; i++) {
        contacts.add((cnt[i].phones[0].number).replaceAll(RegExp(r'\s+'), ''));
      }
      contacts.remove(db.myTb.query().build().findFirst()!.number);

      var a = checkList.length;
      for (var i = 0; i < a; i++) {
        if (contacts.contains(checkList[i].number)) {
          contacts.remove(checkList[i].number);
          checkList.remove(checkList[i]);
        } else {
          Query<User> query =
              db.userTb.query(User_.number.equals(checkList[i].number)).build();
          User? a = query.findUnique();
          query.close();
          db.userTb.remove(a!.id as int);
          checkList.remove(checkList[i]);
          _users.remove(a);
          notifyListeners();
        }
      }

      if (contacts.isNotEmpty) {
        var url = Uri.parse(ip + '/app/checkUsers');
        var response = await http.post(
          url,
          body: {'users': json.encode(contacts)},
        );
        var res = json.decode(response.body)["contacts"] as List;

        if (res.isNotEmpty) {
          for (var item in res) {
            var buffer = base64.decode(item['dp']);
            final dir = await getApplicationDocumentsDirectory();
            final image = File(dir.path + '/' + item['username'] + '.jpg');
            image.writeAsBytesSync(buffer);

            User user = User(
              username: item['username'],
              name: item['name'],
              number: item['number'],
              dp: dir.path + '/' + item['username'] + '.jpg',
              bio: item['bio'],
              msgs: [],
              moments: [],
            );
            if (db.userTb
                .query(User_.username.equals(user.username))
                .build()
                .find()
                .isEmpty) {
              db.userTb.put(user);
              _users.add(user);
              notifyListeners();
            }
          }
        }
      }
    } else {
      await Permission.contacts.request().isGranted ? updateUsers() : null;
    }
  }

  void init() async {
    if (_users.isEmpty) {
      Query<User> query = db.userTb.query().build();
      List<User> user = query.find();
      query.close();
      for (var item in user) {
        _users.add(item);
      }
    }
  }

  void addMsg(User user, String msg) {
    user.msgs.add(msg);
    User x = User(
        id: user.id,
        username: user.username,
        name: user.name,
        number: user.number,
        dp: user.dp,
        bio: user.bio,
        msgs: user.msgs,
        moments: user.moments);
    db.userTb.put(x);
    _users.removeWhere((element) => element.id == user.id);
    _users.add(x);
    notifyListeners();
  }

  void clearUserMsg(User a) {
    User user = User(
      id: a.id,
      username: a.username,
      name: a.name,
      number: a.number,
      dp: a.dp,
      bio: a.bio,
      msgs: [],
      moments: a.moments,
    );
    db.userTb.put(a);
    _users.remove(a);
    _users.add(user);
  }

  void clearAll() {
    var n = _users.length;
    for (var i = 0; i < n; i++) {
      User a = User(
        id: _users[i].id,
        username: _users[i].username,
        name: _users[i].name,
        number: _users[i].number,
        dp: _users[i].dp,
        bio: _users[i].bio,
        msgs: [],
        moments: _users[i].moments,
      );
      db.userTb.put(a);
      _users.removeAt(i);
      _users.add(a);
    }
  }

  List<String> getMsg(id) {
    List<String> msgs = [];
    for (var item in _users) {
      if (item.id == id) {
        msgs = [...item.msgs];
      }
    }
    return msgs;
  }

  List<User> get getUsers {
    return [..._users];
  }
}
