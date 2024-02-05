import 'dart:io' as io;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_pratice_todo/constants/constants.dart';
import 'package:firebase_pratice_todo/models/custom_Button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MySecondPage extends StatefulWidget {
  String? myTaskType;
  String docID;
  String mytitle;
  String mydesc;
  String? myselecteduser;
  int? mypickDate;
  List? imagelist;

  MySecondPage(
      {required this.myTaskType,
      required this.docID,
      required this.mytitle,
      required this.mydesc,
      required this.myselecteduser,
      required this.mypickDate,
      this.imagelist});

  @override
  State<MySecondPage> createState() => _MySecondPageState();
}

class _MySecondPageState extends State<MySecondPage> {
  dateFormatFunc(seldataIntVal) {
    var dateformat = DateFormat('dd-MMM-yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(seldataIntVal.toString())));
    return dateformat;
  }

  late FirebaseFirestore firestore;
  late FirebaseAuth fireauth;
  late FirebaseStorage firebaseStorage;
  String? radioStatus;
  CroppedFile? cropImage;
  List<String> myimagelist = [];

  Future<void> showSimpleDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            // <-- SEE HERE
            title: const Text('Select Status'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  radioStatus = "Completed";
                  firestoreUpdate();
                  Navigator.of(context).pop();
                },
                child: const Text('Completed',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SimpleDialogOption(
                onPressed: () {
                  radioStatus = "Pending";
                  firestoreUpdate();
                  Navigator.of(context).pop();
                },
                child: const Text('Pending'),
              ),
              TextField()
            ],
          );
        });
  }

  @override
  void initState() {
    firestore = FirebaseFirestore.instance;
    fireauth = FirebaseAuth.instance;
    firebaseStorage = FirebaseStorage.instance;
    getImageUrllist();

    print(widget.imagelist!.length);
  }

  getImageUrllist() {
    FirebaseFirestore.instance
        .collection(Utilities.dbtasks)
        .doc(widget.docID)
        .collection('images')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        myimagelist.add(doc['imageUrl']);
        // widget.imageUrlList.add(doc["imageUrl"]);
        setState(() {
          print(" =>  ${myimagelist.length}");
        });
      });
    });

    // selectedChiplist.add(doc['UserName']);
  }

  void openImagePicker() async {
    var pickImage = await ImagePicker().pickImage(source: ImageSource.camera);

    // if (pickImage != null) {
    //   cropImage = await ImageCropper().cropImage(
    //     sourcePath: pickImage.path,
    //     aspectRatioPresets: [
    //       CropAspectRatioPreset.square,
    //       CropAspectRatioPreset.ratio3x2,
    //       CropAspectRatioPreset.original,
    //       CropAspectRatioPreset.ratio4x3,
    //       CropAspectRatioPreset.ratio16x9
    //     ],
    //     uiSettings: [
    //       AndroidUiSettings(
    //           toolbarTitle: 'Cropper',
    //           toolbarColor: Colors.deepOrange,
    //           toolbarWidgetColor: Colors.white,
    //           initAspectRatio: CropAspectRatioPreset.original,
    //           lockAspectRatio: false),
    //       IOSUiSettings(
    //         title: 'Cropper',
    //       ),
    //       WebUiSettings(
    //           context: context,
    //           boundary: CroppieBoundary(
    //               height: (MediaQuery.of(context).size.height * 0.5).toInt(),
    //               width: (MediaQuery.of(context).size.width * 0.5).toInt()),
    //           enableZoom: true,
    //           enableResize: false,
    //           showZoomer: true,
    //           presentStyle: CropperPresentStyle.page),
    //     ],
    //   );
    //   setState(() {});
    // }
    if (pickImage != null) {
      print("File Path ------------=>   ${io.File(pickImage!.path)}");
      // uploadFunc(File(cropImage!.path));
      uploadFunc(io.File(pickImage.path));
    }
  }

  uploadFunc(file) {
    var currTime = DateTime.now().millisecondsSinceEpoch;
    final storage = firebaseStorage.ref();

    //   FOLDER
    final storageRef = storage.child("image/Image_$currTime.jpg");
    try {
      storageRef.putFile(file).then((value) async {
        var imageUrl = await value.ref.getDownloadURL();
        firebaseAddImage(imageUrl);
      });
    } on FirebaseException catch (e) {
      print("Error Uploading {e}");
      // ...
    }
  }

  void firebaseAddImage(imagesUrl) {
    firestore
        .collection(Utilities.dbtasks)
        .doc(widget.docID)
        .collection("images")
        .add({
      "imageUrl": imagesUrl,
      "imageUploadAt": DateTime.now().millisecondsSinceEpoch
    });
  }

  void firestoreUpdate() {
    firestore.collection(Utilities.dbtasks).doc(widget.docID).update(
        {"status": radioStatus.toString(), "status date": DateTime.now()});
    // Navigator.pop(context);
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: myimagelist.length, //widget.imagelist!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 300,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                        image: NetworkImage(
                            myimagelist[index]), //myimagefilelist[index]),
                        // image: NetworkImage(widget.imagelist![index]), //myimagefilelist[index]),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(21),
                  ),
                );
              },
            ),
          ),

          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: ElevatedButton(
                          onPressed: () {
                            print("Camera");
                            openImagePicker();
                          },
                          child:
                              Center(child: Text("Click Here For Image Add"))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Title : => ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Date : ${dateFormatFunc(widget.mypickDate)}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text("\n${widget.mytitle}",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text("Detail : => ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text(
                      "\n${widget.mydesc}",
                      style: TextStyle(fontSize: 16),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          buttontext: "Task 1",
                          minSize: double.infinity,
                          snakBarMsg: "Task 1 Done",
                          onTap: () {
                            showSimpleDialog();
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          buttontext: "Task 2",
                          minSize: double.infinity,
                          snakBarMsg: "Task 2 Done",
                          onTap: () {
                            showSimpleDialog();
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          buttontext: "Task 3",
                          minSize: double.infinity,
                          snakBarMsg: "Task 3 Done",
                          onTap: () {
                            showSimpleDialog();
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          buttontext: "Task 4",
                          minSize: double.infinity,
                          snakBarMsg: "Task 4 Done",
                          onTap: () {
                            showSimpleDialog();
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          buttontext: "Task 5",
                          minSize: double.infinity,
                          snakBarMsg: "Task 5 Done",
                          onTap: () {
                            showSimpleDialog();
                          },
                        )),
                  ],
                ),
              ),
            ),
          ),

          //
        ],
      ),
    );
  }
}
