import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart';

import 'user.dart';
import 'chatroom.dart';
import 'mydata.dart';

class Db {
  late final Store store;
  late final Box<User> userTb;
  late final Box<ChatRoom> chatroomTb;
  late final Box<MyData> myTb;

  Db._create(this.store) {
    userTb = store.box<User>();
    chatroomTb = store.box<ChatRoom>();
    myTb = store.box<MyData>();
  }

  static Future<Db> create() async {
    var dir = await getApplicationDocumentsDirectory();
    final store = Store(getObjectBoxModel(), directory: dir.path);
    return Db._create(store);
  }
}
