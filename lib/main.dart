import 'package:firebase_pratice_todo/pages/home_page.dart';
import 'package:firebase_pratice_todo/pages/login.dart';
import 'package:firebase_pratice_todo/pages/signup.dart';
import 'package:firebase_pratice_todo/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase/firebase_options.dart';

// notes app TAsk
// shareprefrens
// splash
// login & signUp
// number otp screens
//
// notes add update delete
// notes search


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MySplashPage(),
    );
  }
}


