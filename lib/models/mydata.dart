// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../objectbox.g.dart';
import '../main.dart';

@Entity()
class MyData {
  int? id = 0;
  String username;
  String name;
  String number;
  String dp;
  String bio;
  List<String> moments;

  MyData({
    this.id,
    required this.username,
    required this.name,
    required this.number,
    required this.dp,
    required this.bio,
    required this.moments,
  });
}

class My with ChangeNotifier {
  var me;
  String bgImg = '';

  void init() async {
    me = db.myTb.query().build().findFirst();
    var key = await SharedPreferences.getInstance();
    bgImg = key.getString('Conversation-Bg') ?? '';
  }

  void addMoment(String m) {
    me.moments.add(m);
    MyData n = MyData(
      id: me.id,
      username: me.username,
      name: me.name,
      number: me.number,
      dp: me.dp,
      bio: me.bio,
      moments: me.moments,
    );
    db.myTb.put(n);
    notifyListeners();
  }

  String get bg {
    return bgImg;
  }

  MyData get getMe {
    return me;
  }
}
