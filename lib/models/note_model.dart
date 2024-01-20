
import 'package:firebase_pratice_todo/constants/constants.dart';

class NoteModel{
  String title;
  String desc;

  NoteModel({required this.title, required this.desc});

  Map<String,dynamic> toMap(){
    return {
      "Date": Utilities.formattedDate,
      "title":title,
      "desc":desc
    };
  }

  factory NoteModel.fromJson(Map<String,dynamic> json){
    return NoteModel(
        title : json['title'],
        desc  : json['desc']
    );
  }

}