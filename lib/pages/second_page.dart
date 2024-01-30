import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_pratice_todo/constants/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MySecondPage extends StatefulWidget {
  String? myTaskType;
  String docID;
  String mytitle;
  String mydesc;
  String? myselecteduser;
  int? mypickDate;

  MySecondPage(
      {required this.myTaskType,
      required this.docID,
      required this.mytitle,
      required this.mydesc,
      required this.myselecteduser,
      required this.mypickDate});

  @override
  State<MySecondPage> createState() => _MySecondPageState();
}

String? profilePicUrl;
List<String>? imageUrllist;

class _MySecondPageState extends State<MySecondPage> {
  dateFormatFunc(seldataIntVal) {
    var dateformat = DateFormat('dd-MMM-yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(seldataIntVal.toString())));
    return dateformat;
  }

  String? radioStatus;
  late FirebaseFirestore firestore;
  late FirebaseAuth fireauth;
  late FirebaseStorage firebaseStorage;
  CroppedFile? cropImage;

  void radioButton() {
    // RadioListTile(
    //   title: Text("Done"),
    //   value: "Done",
    //   groupValue: radioStatus,
    //   onChanged: (value) {
    //     setState(() {
    //       radioStatus = value.toString();
    //       print(radioStatus);
    //     });
    //   },
    // ),
    // RadioListTile(
    //   title: Text("Not Done"),
    //   value: "Not Done",
    //   groupValue: radioStatus,
    //   onChanged: (value) {
    //     setState(() {
    //       radioStatus = value.toString();
    //       print(radioStatus);
    //     });
    //   },
    // ),
  }

  AlertDialog radioMenuFunc(BuildContext context) {
    return AlertDialog(
      title: Text("Status"),
      actions: [
        RadioListTile(
          title: Text("Done"),
          value: "Done",
          groupValue: radioStatus,
          onChanged: (value) {
            setState(() {
              radioStatus = value.toString();
              print(radioStatus);
            });
          },
        ),
        RadioListTile(
          title: Text("Not Done"),
          value: "Not Done",
          groupValue: radioStatus,
          onChanged: (value) {
            setState(() {
              radioStatus = value.toString();
              print(radioStatus);
            });
          },
        ),
      ],
    );
  }

  Future<void> _showSimpleDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            // <-- SEE HERE
            title: const Text('Select Status'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  radioStatus = "Done";
                  firestoreUpdate();
                  Navigator.of(context).pop();
                },
                child: const Text('Done ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SimpleDialogOption(
                onPressed: () {
                  radioStatus = "Not Done";
                  firestoreUpdate();
                  Navigator.of(context).pop();
                },
                child: const Text('Not Done'),
              ),
              TextField()
            ],
          );
        });
  }

  void firestoreUpdate() {
    firestore
        .collection(Utilities.dbusers)
        .doc(fireauth.currentUser?.email.toString())
        .collection(Utilities.dbnotes)
        .doc(widget.docID)
        .update({
      "task 1 status": radioStatus.toString(),
      "task 1 date": DateTime.now()
    });
    // Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    firestore = FirebaseFirestore.instance;
    fireauth = FirebaseAuth.instance;
    firebaseStorage = FirebaseStorage.instance;
  }

  uploadFunc(CropFilePath) {
    var currTime = DateTime.now().millisecondsSinceEpoch;
    final storage = firebaseStorage.ref();

    //   FOLDER
    final storageRef = storage.child("image/profilepic/Image_$currTime.jpg");
    try {
      storageRef.putFile(CropFilePath).then((value) async {
        var imageUrl = await value.ref.getDownloadURL();
        firestore
            .collection("users")
            .doc("admin@abc.com")
            .collection("images")
            .add({
          "imageUrl": imageUrl,
          "uploadAt": DateTime.now().millisecondsSinceEpoch
        });
      });
    } on FirebaseException catch (e) {
      print("Error Uploading {e}");
      // ...
    }
  }

  void openImagePicker() async {
    var pickImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickImage != null) {
      cropImage = await ImageCropper().cropImage(
        sourcePath: pickImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      setState(() {});
    }
    if (pickImage != null) {
      uploadFunc(File(cropImage!.path));
    }
  }

  getImageUrllist() {
    FirebaseFirestore.instance
        .collection(Utilities.dbusers)
        .doc('admin@abc.com')
        .collection('images')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // print(doc["name"]);
        imageUrllist!.add(doc['imageUrl']);
        // selectedChiplist.add(doc['UserName']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utilities.bgcolor,
      appBar: AppBar(
        title: Text("Task Status"),
        centerTitle: true,
        backgroundColor: Utilities.bgcolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    // child: Image.network(imageUrllist![0]),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(21),
                    //   color: Colors.blueAccent.shade400,
                    // ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          print("Camera");
                          openImagePicker();
                        },
                        child: Text("Image Added")),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Title : => ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Date : ${dateFormatFunc(widget.mypickDate)}",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
              Text(
                "${widget.mytitle}",
                style: TextStyle(fontSize: 21),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Detail : => ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                "${widget.mydesc}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),

              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    _showSimpleDialog();
                  },
                  child: Text("Update << Task 1 >> Status ")),

              //
            ],
          ),
        ),
      ),
    );
  }
}
