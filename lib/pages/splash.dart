import 'dart:async';
import 'package:firebase_pratice_todo/constants/constants.dart';
import 'package:firebase_pratice_todo/pages/home_page.dart';
import 'package:firebase_pratice_todo/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page2.dart';

class MySplashPage extends StatefulWidget {
  // const MySplashPage({super.key});

  @override
  State<MySplashPage> createState() => _MySplashPageState();
}

class _MySplashPageState extends State<MySplashPage> {
  Future<void> checkLoginStatus() async {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginStatus();

    Timer(Duration(seconds: 1), () async {
      var pref = await SharedPreferences.getInstance();
      var userid = pref.getString(Utilities.loginpref);
      Widget toNavigate = MyLoginPage();
      if (userid != null && userid.isNotEmpty) {
        toNavigate = MyHomePage(userId: userid);
      }
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return toNavigate;
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar( ),
      backgroundColor: Colors.blueAccent,
      body: Container(
        child: Center(child: Text("Welcome to To Do App")),
      ),
    );
  }
}
