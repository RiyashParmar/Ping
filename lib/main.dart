//Import flutter and dart packages also your own widgets
// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ping/models/chatroom.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:socket_io_client/socket_io_client.dart' as s;

import 'ReceiveIntentScreen/receiveintentscreen.dart';
import 'HomeScreen/homescreen.dart';
import 'ConversationScreen/conversationscreen.dart';
import 'ConversationScreen/shareddatascreen.dart';
import 'NewConversationScreen/newconversationscreen.dart';
import 'SettingsScreen/settingsscreen.dart';
import 'NewBroadcastScreen/newbroadcastscreen.dart';
import 'NewGroupScreen/newgroupscreen.dart';
import 'StartScreen/loginscreen.dart';
import 'HomeScreen/searchscreen.dart';
import 'SettingsScreen/aboutusscreen.dart';
import 'SettingsScreen/helpscreen.dart';
import 'StartScreen/registerscreen.dart';
import 'ConversationScreen/conversationdetailscreen.dart';
import 'ChatRoomScreen/chatroomscreen.dart';
import 'ChatRoomScreen/chatroomdetailscreen.dart';
import 'WatchPartyScreen/watchpartyscreen.dart';
import 'NotificationService/notificationservice.dart';
import 'models/db.dart';
import 'models/user.dart';
import 'models/mydata.dart';

String ip = 'http://10.0.2.2:3000/'; // Configure as per your system

//The Main function the entry point of the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessary before running app
  db == null ? db = await Db.create() : null; // Db init
  theme = await mode(); // Chceking and setting theme
  check = await login(); // Checking Login status
  await NotificationService().init(); // Notification service
  runApp(const Ping()); // Starting execution from root class
}

bool check = false;
var db;
int theme = 0;

s.Socket socket = s.io(
  ip,
  s.OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      .disableAutoConnect() // disable auto-connection
      .build(),
);

Future<bool> login() async {
  var key = await SharedPreferences.getInstance();
  //key.setBool('Login', false); // testing reomve later....
  return key.getBool('Login') ?? false;
}

Future<int> mode() async {
  var key = await SharedPreferences.getInstance();
  return key.getInt('Theme') ?? 0;
}

//Root class which gets executed first
class Ping extends StatefulWidget {
  const Ping({Key? key}) : super(key: key);
  @override
  State<Ping> createState() => _PingState();
}

class _PingState extends State<Ping> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    db == null
        ? Db.create().then((value) {
            return db = value;
          })
        : null;

    ReceiveSharingIntent.getInitialText().then((String? value) {
      value != null
          ? navigatorKey.currentState!.pushReplacementNamed(
              ReceiveIntentScreen.routeName,
              arguments: value)
          : null;
    });

    ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
      navigatorKey.currentState!.pushReplacementNamed(
          ReceiveIntentScreen.routeName,
          arguments: value);
    }, onError: (err) {
      //print("getIntentDataStream error: $err");
    });

    ReceiveSharingIntent.getInitialMedia().then((List value) {
      value.isNotEmpty
          ? navigatorKey.currentState!.pushReplacementNamed(
              ReceiveIntentScreen.routeName,
              arguments: value)
          : null;
    });

    ReceiveSharingIntent.getTextStream().listen((String value) {
      navigatorKey.currentState!.pushReplacementNamed(
          ReceiveIntentScreen.routeName,
          arguments: value);
    }, onError: (err) {
      //print("getLinkStream error: $err");
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media =
        MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    final double sp = media.size.height > media.size.width
        ? media.size.height
        : media.size.width;

    return MultiProvider(
      //Provider of users contact app wide
      providers: [
        ChangeNotifierProvider(create: (context) => ChatRooms()),
        ChangeNotifierProvider(create: (context) => Users()),
        ChangeNotifierProvider(create: (context) => My()),
      ],

      child: AdaptiveTheme(
        light: ThemeData(
          //Light Theme Parameters
          primaryColor: Colors.lightGreen,
          primarySwatch: Colors.green,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.black,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp * 0.04),
            ),
          ),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.black,
            textColor: Colors.black,
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          textTheme: const TextTheme(
            bodyText2: TextStyle(
              overflow: TextOverflow.clip,
              color: Colors.black,
            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Theme.of(context).primaryColor,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.black,
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp * 0.04),
            ),
          ),
          dialogTheme: DialogTheme(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp * 0.05),
            ),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp * 0.02),
            ),
            behavior: SnackBarBehavior.fixed,
          ),
          bottomSheetTheme: BottomSheetThemeData(
            modalBackgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp * 0.04),
            ),
          ),
        ),

        dark: ThemeData(
          //Dark Theme Parameters
          primaryColor: Colors.lightGreen,
          primarySwatch: Colors.green,
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shadowColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp * 0.04),
            ),
          ),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.white,
            textColor: Colors.white,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyText2: TextStyle(
              overflow: TextOverflow.clip,
              color: Colors.white,
            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Theme.of(context).primaryColorDark,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.white,
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp * 0.04),
            ),
          ),
          dialogTheme: DialogTheme(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp * 0.05),
            ),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp * 0.02),
            ),
            behavior: SnackBarBehavior.fixed,
          ),
          bottomSheetTheme: BottomSheetThemeData(
            modalBackgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp * 0.04),
            ),
          ),
        ),

        initial: theme == 0
            ? AdaptiveThemeMode.system
            : theme == 1
                ? AdaptiveThemeMode.light
                : AdaptiveThemeMode.dark, //Defining app wide theme mode

        builder: (theme, dark) => MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Ping',
          theme: theme,
          darkTheme: dark,
          builder: (context, child) {
            //Setting App wide TextScalefactor
            final MediaQueryData data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(
                textScaleFactor: data.orientation == Orientation.portrait
                    ? data.size.height * 0.0013
                    : data.size.width * 0.0013,
              ),
              child: child!,
            );
          },
          routes: {
            // App routes for different screens
            '/': (ctx) {
              if (check) {
                return const HomeScreen();
              } else {
                return const LoginScreen();
              }
            }, // The first screen to be showed in app
            HomeScreen.routename: (ctx) => const HomeScreen(),
            ConversationScreen.routeName: (ctx) => const ConversationScreen(),
            NewConversationScreen.routeName: (ctx) =>
                const NewConversationScreen(),
            SharedDataScreen.routeName: (ctx) => SharedDataScreen(),
            Search.routeName: (ctx) => const Search(),
            SettingsScreen.routeName: (ctx) => const SettingsScreen(),
            HelpScreen.routeName: (ctx) => const HelpScreen(),
            AboutUsScreen.routeName: (ctx) => const AboutUsScreen(),
            NewBroadcastScreen.routeName: (ctx) => const NewBroadcastScreen(),
            NewGroupScreen.routeName: (ctx) => const NewGroupScreen(),
            LoginScreen.routeName: (ctx) => const LoginScreen(),
            RegisterScreen.routeName: (ctx) => const RegisterScreen(),
            ConversationDetailScreen.routeName: (ctx) =>
                const ConversationDetailScreen(),
            ChatRoomScreen.routeName: (ctx) => const ChatRoomScreen(),
            ChatRoomDetailScreen.routeName: (ctx) =>
                const ChatRoomDetailScreen(),
            ReceiveIntentScreen.routeName: (ctx) => const ReceiveIntentScreen(),
            WatchPartyScreen.routeName: (ctx) => const WatchPartyScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
