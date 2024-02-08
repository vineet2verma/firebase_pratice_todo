import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_pratice_todo/constants/constants.dart';
import 'package:firebase_pratice_todo/models/model.dart';
import 'package:firebase_pratice_todo/pages/add_update_notes.dart';
import 'package:firebase_pratice_todo/pages/drawer.dart';
import 'package:firebase_pratice_todo/pages/second_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class MyHomePage extends StatefulWidget {
  String? userId;
  final List<String> imageUrlList = [];

  MyHomePage({super.key, this.userId});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseFirestore firestore;
  late FirebaseAuth fireauth;

  // user name list
  List<String> usernamelist = [];
  List<String> usernamefilterlist = ['admin'];

  // date
  bool _selectedDatebool = false;
  String? _selectedDateVal;
  // chip
  bool isSelected = false;
  final bool checkAdmin = true;
  List<String> selectedChiplist = ['all'];

  // search
  bool searchBool = false;
  TextEditingController controllerSearch = TextEditingController();
  // filter Data In List

  @override
  Widget build(BuildContext context) {
    // print("=>   ${usernamefilterlist}");

    return Scaffold(
      backgroundColor: Utilities.bgcolor,
      appBar: AppBar(
        title: searchBool == false
            ? Text("Firebase Pratice")
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    initState();
                    // searchFunc(value);
                  },
                  controller: controllerSearch,
                  decoration: InputDecoration(
                      labelText: "Search",
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21))),
                ),
              ),
        backgroundColor: Utilities.bgcolor,
        centerTitle: true,
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  return setState(() {
                    searchBool = !searchBool;
                  });
                },
              )),
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
      drawer: MyDrawer(), //
      floatingActionButton: fireauth.currentUser!.email != "admin@abc.com"
          ? null
          : FloatingActionButton(
              foregroundColor: Colors.black,
              isExtended: true,
              focusColor: Colors.yellowAccent,
              tooltip: "Add Task",
              autofocus: true,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return MyAddUpdatePage(
                      mychoice: "Add",
                      list: usernamelist,
                    );
                  },
                ));
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore
            .collection(Utilities.dbtasks)
            .where("assignTo", whereIn: usernamefilterlist)
            .where("status", isEqualTo: "Pending")
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

            return mdata.isNotEmpty
                ? ExpansionTile(
                    title: Text("Pending Tasks"),
                    initiallyExpanded: true,
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    expandedAlignment: Alignment.center,
                    collapsedShape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)),
                    children: mdata.map((e) {
                      var currDocId = e.id;

                      NoteModel currModel = NoteModel.fromJson(e.data());

                      var leftdays = DateTime.now()
                          .difference(DateTime.fromMillisecondsSinceEpoch(
                              currModel.seleteDate!.toInt()))
                          .inDays;

                      return ExpansionTile(
                        title: Text(currModel.selectedUser.toString()),
                        collapsedBackgroundColor: Colors.blueAccent,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21)),
                        initiallyExpanded: false,
                        children: [
                          ListTile(
                            leading: Text(currModel.selectedUser.toString()),
                            title: Text(currModel.title,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${currModel.desc}  \n${currModel.status}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                    softWrap: true),
                                Row(
                                  children: [
                                    Text(
                                        "Date : ${dateFormatFunc(currModel.seleteDate)} \t Days Left: ${leftdays}"),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return MySecondPage(
                                    myTaskType: "taskUser1",
                                    docID: currDocId,
                                    mytitle: currModel.title,
                                    mydesc: currModel.desc,
                                    myselecteduser: currModel.selectedUser,
                                    mypickDate: currModel.seleteDate,
                                    imagelist: widget.imageUrlList,
                                  );
                                },
                              ));
                            },
                            // Add & Edit & Cancel Button
                            trailing: PopupMenuButton(
                              onSelected: (value) {
                                setState(() {
                                  if (value == "Edit") {
                                    //   edit
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
                                          list: usernamelist,
                                        );
                                      },
                                    ));
                                  } // edit end
                                  else {
                                    //   delete
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
                                                    child: Text("Confirm"),
                                                    onPressed: () {
                                                      firestore
                                                          .collection(
                                                              Utilities.dbtasks)
                                                          .doc(e.id)
                                                          .delete();
                                                      Navigator.pop(context);
                                                    })
                                              ]);
                                        });
                                  } // delete end
                                });
                              },
                              itemBuilder: (BuildContext bc) {
                                return const [
                                  PopupMenuItem(
                                    child: Text("Edit"),
                                    value: 'Edit',
                                  ),
                                  PopupMenuItem(
                                    child: Text("Delete"),
                                    value: 'Delete',
                                  ),
                                ];
                              },
                            ),
                          ),
                        ],
                      );
                      // },
                    }).toList())
                : Center(
                    child: Text("No Data!!!"),
                  );
          }

          return Container(child: Center(child: Text("Data Was Not Loaded")));
        },
      ),
    );
  }

  @override
  void initState() {
    firestore = FirebaseFirestore.instance;
    fireauth = FirebaseAuth.instance;
    getusernamelist();
    getImageUrllist();
    setState(() {});
  }

  searchFunc(value) {
    // print(value);
  }

  getImageUrllist() {
    FirebaseFirestore.instance
        .collection(Utilities.dbtasks)
        .doc()
        .collection(Utilities.dbimages)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        widget.imageUrlList.add(doc["imageUrl"]);
        setState(() {
          // print(widget.imageUrlList.length);
        });
      });
    });

    // selectedChiplist.add(doc['UserName']);
  }

  dateFormatFunc(seldataIntVal) {
    var dateformat = DateFormat('dd-MMM-yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(seldataIntVal.toString())));
    return dateformat;
  }

  getusernamelist() {
    // var firebase = FirebaseFirestore.instance;
    var _userEmailid = fireauth.currentUser!.email.toString();
    if (_userEmailid.contains("admin")) {
      firestore
          .collection(Utilities.dbusers)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          usernamelist.add(doc['UserName']);
          usernamefilterlist.add(doc['UserName']);
        });
      });
    } else {
      firestore
          .collection(Utilities.dbusers)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          usernamelist.add(doc['UserName']);
          usernamefilterlist.clear();
          usernamefilterlist.add(_userEmailid.split("@")[0].toString());
        });
      });
    }
  }
}

class ExpansionItem extends StatefulWidget {
  String header;
  bool isExpanded;
  dynamic items;

  ExpansionItem(
      {required this.header, required this.isExpanded, required this.items});

  @override
  State<ExpansionItem> createState() => _ExpansionItemState();
}

class _ExpansionItemState extends State<ExpansionItem> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.header),
      children: [widget.items],
    );
  }
}
