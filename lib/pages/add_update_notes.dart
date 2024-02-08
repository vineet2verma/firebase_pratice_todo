import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/constants.dart';
import '../models/model.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class MyAddUpdatePage extends StatefulWidget {
  String mychoice;
  String? myselecteduser;
  String? mytitle;
  String? mydesc;
  String? docID;
  int? mypickDate = DateTime.now().millisecondsSinceEpoch;
  List<String> list;

  MyAddUpdatePage(
      {required this.mychoice,
      this.myselecteduser,
      this.mytitle,
      this.mydesc,
      this.docID,
      this.mypickDate,
      required this.list});

  @override
  State<MyAddUpdatePage> createState() => _MyAddUpdatePageState();
}

class _MyAddUpdatePageState extends State<MyAddUpdatePage> {
  late FirebaseFirestore firestore;
  late FirebaseAuth fireauth;

  static final controllerTitle = TextEditingController();
  static final controllerDesc = TextEditingController();
  static final controllerSelectedUser = TextEditingController();
  int? pickDate;
  bool _selectedDatebool = false;
  String? userMailId;

  getClearTextController() {
    controllerTitle.clear();
    controllerDesc.clear();
    controllerSelectedUser.clear();
  }

  bool dateboolfunc() {
    return _selectedDatebool = true;
  }

  getUserMailId(userId) {
    if (userId == "user1") {
      return userMailId = "user1@abc.com";
    }
    if (userId == "user2") {
      return userMailId = "user2@abc.com";
    }
    if (userId == "user3") {
      return userMailId = "user3@abc.com";
    }
    if (userId == "user4") {
      return userMailId = "user4@abc.com";
    }
    if (userId == "user5") {
      return userMailId = "user5@abc.com";
    } else
      return userMailId = "admin@abc.com";
  }

  addFunc() {
    firestore
        .collection(Utilities.dbtasks) // remove this
        .add(NoteModel(
                title: controllerTitle.text.toString(),
                desc: controllerDesc.text.toString(),
                selectedUser:
                    controllerSelectedUser.text.toString(), // taken user id
                seleteDate: pickDate == null
                    ? DateTime.now().millisecondsSinceEpoch
                    : pickDate)
            .toMap())
        .then((value) => print("Note Added"))
        .then((value) => getClearTextController())
        .catchError((e) {
      return print("Error : $e");
    });
    Navigator.pop(context);
  }

  updateFunc(currdocID, updatepickDate, updatetitle, updatedesc, updateuser) {
    print(DateFormat("dd-MMM-yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(pickDate!))
        .toString());
    firestore
        .collection(Utilities.dbtasks)
        .doc(widget.docID)
        .update(NoteModel(
                selectedUser: controllerSelectedUser.text.toString(),
                title: controllerTitle.text.toString(),
                desc: controllerDesc.text.toString(),
                seleteDate: int.parse(pickDate
                    .toString()) // DateFormat("dd-MMM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(pickDate!)).toString()
                )
            .toMap())
        .then((value) => Navigator.pop(context))
        .then((value) => print("Note Updated"));
  }

  Future<void> DatePickerFunc(BuildContext context) async {
    final DateTime? selectedDateVal;
    selectedDateVal = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDate: DateTime.now(),
    );

    setState(() {
      pickDate = selectedDateVal!.millisecondsSinceEpoch;
      dateboolfunc();
    });
  }

  @override
  void initState() {
    firestore = FirebaseFirestore.instance;
    fireauth = FirebaseAuth.instance;
    addAndUpdateFunc();
  }

  void addAndUpdateFunc() {
    pickDate = widget.mypickDate;
    widget.mychoice == "Add" ? '' : dateboolfunc();
    widget.mychoice == "Add" ? '' : controllerTitle.text = widget.mytitle!;
    widget.mychoice == "Add" ? '' : controllerDesc.text = widget.mydesc!;
    widget.mychoice == "Add"
        ? ''
        : controllerSelectedUser.text = widget.myselecteduser.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            widget.mychoice == "Add" ? Text("Add Task") : Text("Update Task"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),

            // Date
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 50,
                    width: 225,
                    child: ElevatedButton(
                        child: _selectedDatebool
                            ? Text(
                                "${DateFormat("dd-MMM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(pickDate!)).toString()}")
                            : Text("Select Date"),
                        onPressed: () {
                          DatePickerFunc(context);
                        }),
                  ),
                ],
              ),
            ),
            // Select User

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text("Select User :"),
                  Flexible(
                    child: DropdownButtonHideUnderline(
                      child: DropdownMenu(
                        enabled: true,
                        enableSearch: true,
                        hintText: "Assign To..",
                        initialSelection: widget.myselecteduser,
                        textStyle: TextStyle(color: Colors.black),
                        dropdownMenuEntries: widget.list
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                        enableFilter: true,
                        inputDecorationTheme: InputDecorationTheme(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21))),
                        width: MediaQuery.of(context).size.width - 20,
                        controller: controllerSelectedUser,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerTitle,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21))),
              ),
            ),
            // Description
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerDesc,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Cancel // Submit
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        getClearTextController();
                        Navigator.pop(context);
                      },
                      child: Text("Cancel")),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.green)),
                      onPressed: () {
                        widget.mychoice == "Add"
                            ? addFunc()
                            : updateFunc(widget.docID, pickDate, widget.mytitle,
                                widget.mydesc, widget.myselecteduser);
                      },
                      child: Text(
                        widget.mychoice == "Add" ? "Add Task" : "Update Task",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
