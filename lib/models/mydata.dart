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
  // ignore: prefer_typing_uninitialized_variables
  var me;
  String bgImg = '';

  void init() async {
    me = db.myTb.query().build().findFirst();
    var key = await SharedPreferences.getInstance();
    bgImg = key.getString('Conversation-Bg') ?? '';
  }

  String get bg {
    return bgImg;
  }

  MyData get getMe {
    return me;
  }
}
