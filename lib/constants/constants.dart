import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utilities {

  // DateTime now = DateTime.now();
  // static String formattedDate = DateFormat('yyyy-MM-dd – HH:mm:ss').format(DateTime.now());
  static int formattedDate = DateTime.now().microsecondsSinceEpoch;

  static const String loginpref = 'isLogin';
  static String loginUserImage = "https://www.google.com/imgres?imgurl=https%3A%2F%2Fmedia.geeksforgeeks.org%2Fwp-content%2Fuploads%2F20230426115225%2Fcomputer-image-660.jpg&tbnid=3NFKnWOquL5MWM&vet=12ahUKEwjF6u3rieqDAxXlnGMGHfoBB58QMygPegUIARCSAQ..i&imgrefurl=https%3A%2F%2Fwww.geeksforgeeks.org%2Ftypes-of-computers%2F&docid=yD4U1a1PaIEYJM&w=660&h=469&itg=1&q=computer%20image&ved=2ahUKEwjF6u3rieqDAxXlnGMGHfoBB58QMygPegUIARCSAQ";
  static String loginUserName = "Default User";
  static String loginUserPhone = "00000-00000";

  static String dbusers = "users";
  static String dbnotes = "notes";
  static String dbusermaster = "usermaster";







}