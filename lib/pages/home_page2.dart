// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_pratice_todo/constants/constants.dart';
// import 'package:firebase_pratice_todo/models/model.dart';
// import 'package:firebase_pratice_todo/pages/add_update_notes.dart';
// import 'package:firebase_pratice_todo/pages/drawer.dart';
// import 'package:firebase_pratice_todo/pages/second_page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'login.dart';
//
// class MyHomePage extends StatefulWidget {
//   String userId;
//   MyHomePage({super.key, required this.userId});
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   late FirebaseFirestore firestore;
//   late FirebaseAuth fireauth;
//   // user name list
//   List<String> usernamelist = [];
//   // date
//   bool _selectedDatebool = false;
//   String? _selectedDateVal;
//   // chip
//   bool isSelected = false;
//   List<String> selectedChiplist = ['all'];
//   // search
//   bool searchBool = false;
//   TextEditingController controllerSearch = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Utilities.bgcolor,
//       appBar: AppBar(
//         title: searchBool == false
//             ? Text("Firebase Pratice")
//             : Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   onChanged: (value) {
//                     searchFunc(value);
//                   },
//                   controller: controllerSearch,
//                   decoration: InputDecoration(
//                       labelText: "Search",
//                       fillColor: Colors.white,
//                       filled: true,
//                       isDense: true,
//                       suffixIcon: Icon(Icons.search),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(21))),
//                 ),
//               ),
//         backgroundColor: Utilities.bgcolor,
//         centerTitle: true,
//         actions: [
//           Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: IconButton(
//                 icon: Icon(Icons.search),
//                 onPressed: () {
//                   return setState(() {
//                     searchBool = !searchBool;
//                   });
//                 },
//               )),
//           Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: InkWell(
//                 onTap: () async {
//                   var pref = await SharedPreferences.getInstance();
//                   pref.setString(Utilities.loginpref, "");
//
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) {
//                       return MyLoginPage();
//                     },
//                   ));
//                 },
//                 child: Icon(Icons.logout)),
//           ),
//         ],
//       ),
//       drawer: MyDrawer(), //
//       floatingActionButton: fireauth.currentUser!.email != "admin@abc.com"
//           ? null
//           : FloatingActionButton(
//               foregroundColor: Colors.black,
//               isExtended: true,
//               focusColor: Colors.yellowAccent,
//               tooltip: "Add Task",
//               autofocus: true,
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(
//                   builder: (context) {
//                     return MyAddUpdatePage(
//                       mychoice: "Add",
//                       list: usernamelist,
//                     );
//                   },
//                 ));
//               },
//               child: Icon(Icons.add),
//               backgroundColor: Colors.blue,
//             ),
//
//       body: Column(
//         children: [
//           /// Selection Chip
//           Flexible(
//             child: Container(
//               height: 10,
//               width: double.infinity,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 // child: Padding(
//                 //   padding: const EdgeInsets.all(8.0),
//                 //   child: Row(
//                 //     children: <Widget>[
//                 //
//                 //       for (var item in usernamelist)
//                 //         Padding(
//                 //           padding: const EdgeInsets.only(right: 1.0, left: 1),
//                 //           child: ChoiceChip(
//                 //             label: Text("${item}"),
//                 //             selected: isSelected,
//                 //             onSelected: (value) {
//                 //               setState(() {
//                 //                 // if (selectedChiplist.contains(item)) {
//                 //                 //   selectedChiplist.remove(item);
//                 //                 // } else {
//                 //                 //   selectedChiplist.add(item);
//                 //                 // }
//                 //                 // ScaffoldMessenger.of(context).showSnackBar(
//                 //                 //     SnackBar(
//                 //                 //         content: Text("Selected : ${item}")));
//                 //               });
//                 //             },
//                 //           ),
//                 //         ),
//                 //     ],
//                 //   ),
//                 // ),
//               ),
//             ),
//           ),
//
//           /// Project Task
//           Expanded(
//             flex: 4,
//             child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//               stream: firestore
//                   .collection(Utilities.dbusers)
//                   .doc(fireauth.currentUser!.email)
//                   .collection(Utilities.dbnotes)
//                   // .where("selectedUser", whereIn: selectedChiplist)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text("Check The Error"));
//                 }
//                 if (snapshot.hasData) {
//                   var mdata = snapshot.data!.docs;
//
//                   return mdata.isNotEmpty
//                       ? ListView.builder(
//                           itemCount: mdata.length,
//                           itemBuilder: (context, index) {
//                             var currDocId = mdata[index].id;
//
//                             NoteModel currModel =
//                                 NoteModel.fromJson(mdata[index].data());
//                             // print(currModel.toMap());
//                             var leftdays = DateTime.now()
//                                 .difference(DateTime.fromMillisecondsSinceEpoch(
//                                     currModel.seleteDate!.toInt()))
//                                 .inDays;
//
//                             return Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: ListTile(
//                                 tileColor: currModel.status == "Pending"
//                                     ? Colors.amber[400]
//                                     : Colors.lightGreen[300],
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(21),
//                                     side: BorderSide(
//                                       width: 2,
//                                     )),
//                                 title: Text(currModel.title,
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold)),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("${currModel.desc}",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w600),
//                                         softWrap: true),
//                                     Row(
//                                       children: [
//                                         Text(
//                                             "Date : ${dateFormatFunc(currModel.seleteDate)} \t Days Left: ${leftdays}"),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 onTap: () {
//                                   Navigator.push(context, MaterialPageRoute(
//                                     builder: (context) {
//                                       return MySecondPage(
//                                           myTaskType: "taskUser1",
//                                           docID: currDocId,
//                                           mytitle: currModel.title,
//                                           mydesc: currModel.desc,
//                                           myselecteduser:
//                                               currModel.selectedUser,
//                                           mypickDate: currModel.seleteDate);
//                                     },
//                                   ));
//                                 },
//                                 // Add & Edit & Cancel Button
//                                 trailing: fireauth.currentUser?.email ==
//                                         "admin@abc.com"
//                                     ? SizedBox(
//                                         width: 100,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceAround,
//                                           children: [
//                                             InkWell(
//                                               child: Icon(
//                                                 Icons.edit,
//                                                 size: 31,
//                                                 color:
//                                                     CupertinoColors.activeGreen,
//                                               ),
//                                               onTap: () {
//                                                 Navigator.push(context,
//                                                     MaterialPageRoute(
//                                                   builder: (context) {
//                                                     return MyAddUpdatePage(
//                                                       mychoice: "Update",
//                                                       docID: currDocId,
//                                                       mytitle: currModel.title,
//                                                       mydesc: currModel.desc,
//                                                       myselecteduser: currModel
//                                                           .selectedUser,
//                                                       mypickDate:
//                                                           currModel.seleteDate,
//                                                       list: usernamelist,
//                                                     );
//                                                   },
//                                                 ));
//                                               },
//                                             ),
//                                             InkWell(
//                                               child: Icon(Icons.delete,
//                                                   size: 31, color: Colors.red),
//                                               onTap: () {
//                                                 showDialog(
//                                                   context: context,
//                                                   builder: (context) {
//                                                     return AlertDialog(
//                                                       title:
//                                                           Text("Confirmation"),
//                                                       actions: [
//                                                         TextButton(
//                                                             onPressed: () {
//                                                               Navigator.pop(
//                                                                   context);
//                                                             },
//                                                             child:
//                                                                 Text("Cancel")),
//                                                         TextButton(
//                                                             onPressed: () {
//                                                               firestore
//                                                                   .collection(
//                                                                       Utilities
//                                                                           .dbusers)
//                                                                   .doc(fireauth
//                                                                       .currentUser!
//                                                                       .email)
//                                                                   .collection(
//                                                                       Utilities
//                                                                           .dbnotes)
//                                                                   .doc(snapshot
//                                                                       .data!
//                                                                       .docs[
//                                                                           index]
//                                                                       .id)
//                                                                   .delete();
//                                                               Navigator.pop(
//                                                                   context);
//                                                             },
//                                                             child: Text(
//                                                                 "Confirm")),
//                                                       ],
//                                                     );
//                                                   },
//                                                 );
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     : null,
//                               ),
//                             );
//                           },
//                         )
//                       : Center(
//                           child: Text("No Data!!!"),
//                         );
//                 }
//
//                 return Container(
//                     child: Center(child: Text("Data Was Not Loaded")));
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     firestore = FirebaseFirestore.instance;
//     fireauth = FirebaseAuth.instance;
//     getusernamelist();
//     setState(() {});
//   }
//
//   dateFormatFunc(seldataIntVal) {
//     var dateformat = DateFormat('dd-MMM-yyyy').format(
//         DateTime.fromMillisecondsSinceEpoch(
//             int.parse(seldataIntVal.toString())));
//     return dateformat;
//   }
//
//   searchFunc(value) {
//     print(value);
//     // var searchResult =
//   }
//
//   getusernamelist() {
//     FirebaseFirestore.instance
//         .collection(Utilities.dbusers)
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         // print(doc["name"]);
//         usernamelist.add(doc['UserName']);
//         selectedChiplist.add(doc['UserName']);
//       });
//     });
//   }
// }
