import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class User {
  //Device contacts holder class
  String name;
  String number;
  User({
    required this.name,
    required this.number,
  });
}

class Users with ChangeNotifier {
  // Contacts getter and provider
  final List<User> _users = [];

  updatecontacts() async {
    // Updating contacts if any
    var contacts = await FlutterContacts.getContacts(withProperties: true);
    contacts.removeWhere((element) => element.phones.isEmpty);

    for (var i = 0; i < contacts.length; i++) {
      User a = User(
        name: contacts[i].displayName,
        number: contacts[i].phones[0].number,
      );

      if ((_users.where((element) => element.number == a.number)).isEmpty) {
        _users.add(a);
      }
    }

    notifyListeners();
  }

  getcontacts() async {
    // Getting the contacts first time
    if (await FlutterContacts.requestPermission() == true) {
      _users.isEmpty ? updatecontacts() : null;
    } else {
      await FlutterContacts.requestPermission();
      if (await FlutterContacts.requestPermission() == true) {
        _users.isEmpty ? updatecontacts() : null;
      }
    }
  }

  List<User> get users {
    // Getting the list of contacts
    return [..._users];
  }
}
