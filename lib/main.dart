import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bn_home.dart';
import 'notifications.dart';
import 'sign_in.dart';
import 'sign_up.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool isLogin = sp.getBool('login') ?? false;
  // bool isID = sp.getString('user_id') != null ? true : false;

  OneSignal.shared.setAppId("b982fb3a-3ee4-4843-9dfb-353cde914720");
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  OneSignal.shared.setNotificationOpenedHandler((value) {
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => NotificationPage(),
      ),
    );
  });

  await Future.delayed(const Duration(seconds: 3));
  runApp(
    MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: Home(),
      // home: Contact(),
    ),
  );
}