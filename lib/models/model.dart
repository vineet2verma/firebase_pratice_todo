import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pratice_todo/constants/constants.dart';
import 'package:intl/intl.dart';

class NoteModel {
  String? selectedUser;
  String title;
  String desc;
  int? seleteDate;

  NoteModel(
      {required this.selectedUser,
      required this.title,
      required this.desc,
      this.seleteDate});

  var createDate = DateFormat('yyyy-MM-dd – HH:mm:ss').format(DateTime.now());

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createDate,
      "assignTo": selectedUser,
      "selectedUser": selectedUser,
      "seleteDate": seleteDate, // seleteDate,
      "title": title,
      "desc": desc
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
        seleteDate: json['seleteDate'],
        selectedUser: json['selectedUser'],
        title: json['title'],
        desc: json['desc']);
  }
}

class SignUpModel {
  String UserName;
  String PhoneNo;
  String EmailId;
  String? Password;

  SignUpModel({
    required this.UserName,
    required this.PhoneNo,
    required this.EmailId,
    this.Password,
  });

  Map<String, dynamic> toMap() {
    return {
      "CreatedAt": Utilities.formattedDate,
      "UserName": UserName,
      "PhoneNo": PhoneNo,
      "EmailId": EmailId,
      "Password": Password
    };
  }

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      UserName: json['UserName'],
      PhoneNo: json['PhoneNo'],
      EmailId: json['EmailId'],
      Password: json['Password'],
    );
  }
}
