import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pratice_todo/constants/constants.dart';
import 'package:intl/intl.dart';

class NoteModel {
  String? selectedUser;
  String title;
  String desc;
  int? seleteDate;
  String? status;

  NoteModel({
    required this.selectedUser,
    required this.title,
    required this.desc,
    this.seleteDate,
    this.status,
  });

  var createDate = DateFormat('yyyy-MM-dd – HH:mm:ss').format(DateTime.now());

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createDate,
      "seleteDate": seleteDate, // seleteDate,
      "assignTo": selectedUser,
      "title": title,
      "desc": desc,
      "status": "Pending"
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    // List<ImageModel> listImages = [];
    // for (Map<String, dynamic> eachMap in json['images']) {
    //   listImages.add(ImageModel.fromJson(eachMap));
    // }

    return NoteModel(
        seleteDate: json['seleteDate'],
        selectedUser: json['assignTo'],
        title: json['title'],
        desc: json['desc'],
        status: json['status']);
  }
}

class ImageModel {
  num? imageUploadAt;
  String? imageUrl;

  ImageModel({required this.imageUploadAt, required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {"imageUploadAt": imageUploadAt, "imageUrl": imageUrl};
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
        imageUploadAt: json['imageUploadAt'], imageUrl: json['imageUrl']);
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
