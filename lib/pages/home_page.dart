import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pratice_todo/constants/constants.dart';
import 'package:firebase_pratice_todo/models/model.dart';
import 'package:firebase_pratice_todo/pages/add_update_notes.dart';
import 'package:firebase_pratice_todo/pages/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class MyHomePage extends StatefulWidget {
  String userId;
  MyHomePage({super.key, required this.userId});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseFirestore firestore;
  late FirebaseAuth fireauth;
  dynamic usernamelist = [];

  bool _selectedDatebool = false;
  String? _selectedDateVal;

  dateFormatFunc(seldataIntVal) {
    var dateformat = DateFormat('dd-MMM-yyyy - HH:mm:ss').format(
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(seldataIntVal.toString())));
    return dateformat;
  }

  Future<void> DatePickerFunc(context) async {
    DateTime? _selectedDateVal = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    setState(() {
      _selectedDateVal;
      _selectedDatebool = true;
      print(_selectedDateVal);
    });
  }

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    fireauth = FirebaseAuth.instance;
  }

  // addFunc() {
  //   firestore
  //       .collection(Utilities.dbusers)
  //       .doc(fireauth.currentUser!.email)
  //       .collection(Utilities.dbnotes)
  //       .add(NoteModel(
  //               title: controllerTitle.text.toString(),
  //               desc: controllerDesc.text.toString(),
  //               seleteDate: DateTime.now().millisecondsSinceEpoch.toString())
  //           .toMap())
  //       .then((value) => print("Note Added"))
  //       .catchError((e) {
  //     return print("Error : ${e}");
  //   });
  // }

  updateFunc(currdocID, selecteduser, updatetitle, updatedesc) {
    firestore
        .collection(Utilities.dbusers)
        .doc(fireauth.currentUser!.email)
        .collection(Utilities.dbnotes)
        .doc(currdocID)
        .update(NoteModel(
                selectedUser: selecteduser,
                title: updatetitle,
                desc: updatedesc,
                seleteDate: DateTime.now().millisecondsSinceEpoch)
            .toMap());

    // firestore
    //     .collection(Utilities.dbusers)
    //     .doc(fireauth.currentUser!.email)
    //     .collection(Utilities.dbnotes)
    //     .doc(currDocId)
    //     .update(NoteModel(
    //             title: updatetitle,
    //             desc: updatedesc,
    //             time: DateTime.now().millisecondsSinceEpoch.toString())
    //         .toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text("Firebase Pratice"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
                onTap: () async {
                  var pref = await SharedPreferences.getInstance();
                  pref.setString(Utilities.loginpref, "");

                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return MyLoginPage();
                    },
                  ));
                },
                child: Icon(Icons.logout)),
          ),
        ],
      ),
      drawer: MyDrawer(), // buildDrawer(),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        isExtended: true,
        focusColor: Colors.green,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return MyAddUpdatePage(
                mychoice: "Add",
              );
            },
          ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore
            .collection(Utilities.dbusers)
            .doc(fireauth.currentUser!.email)
            .collection(Utilities.dbnotes)
            // .orderBy("createAt",descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Check The Error"));
          }
          if (snapshot.hasData) {
            var mdata = snapshot.data!.docs;

            // mdata.forEach((element) {
            //   print(element.id);
            // });

            return mdata.isNotEmpty
                ? ListView.builder(
                    itemCount: mdata.length,
                    itemBuilder: (context, index) {
                      var currDocId = mdata[index].id;

                      NoteModel currModel =
                          NoteModel.fromJson(mdata[index].data());
                      // print(currModel.toMap());

                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ListTile(
                          tileColor: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21),
                              side: BorderSide(
                                width: 2,
                              )),
                          title: Text(currModel.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${currModel.desc} : (User : ${currModel.selectedUser})"),
                            ],
                          ),
                          onTap: () {
                            print(currDocId);
                          },
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  child: Icon(
                                    Icons.edit,
                                    size: 31,
                                    color: CupertinoColors.activeGreen,
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return MyAddUpdatePage(
                                          mychoice: "Update",
                                          docID: currDocId,
                                          mytitle: currModel.title,
                                          mydesc: currModel.desc,
                                          myselecteduser:
                                              currModel.selectedUser,
                                          mypickDate: currModel.seleteDate,
                                        );
                                      },
                                    ));
                                  },
                                ),
                                InkWell(
                                  child: Icon(Icons.delete,
                                      size: 31, color: Colors.red),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Confirmation"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancel")),
                                            TextButton(
                                                onPressed: () {
                                                  firestore
                                                      .collection(
                                                          Utilities.dbusers)
                                                      .doc(fireauth
                                                          .currentUser!.email)
                                                      .collection(
                                                          Utilities.dbnotes)
                                                      .doc(snapshot
                                                          .data!.docs[index].id)
                                                      .delete();
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Confirm")),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text("No Data!!!"),
                  );
          }

          return Container(child: Center(child: Text("Data Was Not Loaded")));
        },
      ),
    );
  }
}
