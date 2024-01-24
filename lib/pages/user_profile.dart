import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MyUserProfilePage extends StatefulWidget {
  // const UserProfilePage({super.key});
  String? profilePicUrl;

  @override
  State<MyUserProfilePage> createState() => _MyUserProfilePageState();
}

class _MyUserProfilePageState extends State<MyUserProfilePage> {
  var firebaseStorage = FirebaseStorage.instance;
  CroppedFile? cropImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  uploadFunc(CropFilePath) {
    final storage = firebaseStorage.ref();
    var currTime = DateTime.now().millisecondsSinceEpoch;

    //   FOLDER
    final storageRef = storage.child("image/profilepic/Image_$currTime.jpg");

    try {
      storageRef.putFile(CropFilePath).then((value) async {
        print(value);
        var imageUrl = await value.ref.getDownloadURL();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 100,
              width: 100,
              child: cropImage != null
                  ? Image.file(File(cropImage!.path))
                  : Text(""),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                openImagePicker();
              },
              child: Text("Pick Image"),
            ),
            SizedBox(
              height: 20,
            ),
            cropImage != null
                ? ElevatedButton(
                    onPressed: () {
                      uploadFunc(File(cropImage!.path));
                    },
                    child: Text("Upload An Image"),
                  )
                : Text("Select An Image"),
          ],
        ),
      ),
    );
  }
}
