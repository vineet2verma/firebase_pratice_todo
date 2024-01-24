import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';
import '../models/model.dart';

class MyAddUpdatePage extends StatefulWidget {
  String mychoice;
  String? myselecteduser;
  String? mytitle;
  String? mydesc;
  String? docID;
  List userList;
  DateTime? mypickDate = DateTime.now();

  MyAddUpdatePage(
      {required this.mychoice,
      this.myselecteduser,
      this.mytitle,
      this.mydesc,
      this.docID,
      required this.userList,
      this.mypickDate});

  @override
  State<MyAddUpdatePage> createState() => _MyAddUpdatePageState();
}

class _MyAddUpdatePageState extends State<MyAddUpdatePage> {
  late FirebaseFirestore firestore;
  late FirebaseAuth fireauth;

  static final controllerTitle = TextEditingController();
  static final controllerDesc = TextEditingController();
  static final controllerSelectedUser = TextEditingController();
  DateTime? pickDate;
  bool _selectedDatebool = false;
  var list = <String>['One', 'Two', 'Three', 'Four'];

  getClearTextController() {
    controllerTitle.clear();
    controllerDesc.clear();
  }

  addFunc() {
    print("=>    ${pickDate}");
    firestore
        .collection(Utilities.dbusers)
        .doc(fireauth.currentUser!.email)
        .collection(Utilities.dbnotes)
        .add(NoteModel(
                title: controllerTitle.text.toString(),
                desc: controllerDesc.text.toString(),
                selectedUser: controllerSelectedUser.text.toString(),
                seleteDate: pickDate == null
                    ? DateTime.now().millisecondsSinceEpoch.toString()
                    : pickDate.toString())
            .toMap())
        .then((value) => print("Note Added"))
        .catchError((e) {
      return print("Error : $e");
    });
    getClearTextController();
    Navigator.pop(context);
  }

  void addAndUpdateFunc() {
    widget.mychoice == "Add" ? '' : controllerTitle.text = widget.mytitle!;
    widget.mychoice == "Add" ? '' : controllerDesc.text = widget.mydesc!;
    widget.mychoice == "Add"
        ? ''
        : controllerDesc.text = widget.myselecteduser!;

    widget.mychoice == "Add"
        ? addFunc()
        : updateFunc(widget.docID, widget.myselecteduser, widget.mytitle,
            widget.mydesc, widget.mypickDate);
  }

  Future<void> DatePickerFunc(BuildContext context) async {
    final DateTime? selectedDateVal = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    setState(() {
      pickDate = selectedDateVal;
      print(pickDate);
      _selectedDatebool = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestore = FirebaseFirestore.instance;
    fireauth = FirebaseAuth.instance;

    // addAndUpdateFunc();
  }

  updateFunc(currdocID, updatetitle, updatedesc, pickDate, updateuser) {
    firestore
        .collection(Utilities.dbusers)
        .doc(fireauth.currentUser!.email)
        .collection(Utilities.dbnotes)
        .doc(currdocID)
        .update(NoteModel(
                selectedUser: updateuser,
                title: updatetitle,
                desc: updatedesc,
                seleteDate: pickDate.toString())
            .toMap());
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
                    width: 200,
                    child: ElevatedButton(
                        child: _selectedDatebool
                            ? Text(
                                "${DateFormat("dd-MMM-yyyy").format(pickDate!)}")
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
                        hintText: "Select A User",
                        dropdownMenuEntries:
                            list.map<DropdownMenuEntry<String>>((String value) {
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
                        addFunc();
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
