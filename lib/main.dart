import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_manager/lifecycle_manager.dart';
import 'package:password_manager/view/auth/create.dart';
import 'package:password_manager/view/auth/login.dart';
import 'package:password_manager/view/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> _checkUserStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var result = pref.getBool('user');
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return LifecycleManager(
      child: FutureBuilder(
        future: _checkUserStatus(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Splash(),
            );
          } else {
            return GetMaterialApp(
              title: 'Password Manager',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                primarySwatch: Colors.blue,
              ),
              home: snapshot.data == null ? Create() : Login(),
            );
          }
        },
      ),
    );
  }
}
