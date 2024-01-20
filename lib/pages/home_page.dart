import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pratice_todo/constants/constants.dart';
import 'package:firebase_pratice_todo/models/note_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class MyHomePage extends StatefulWidget {
  String userId;

  MyHomePage({super.key, required this.userId });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseFirestore firestore ;

  var controllerTitle = TextEditingController();
  var controllerDesc = TextEditingController();

  getClearTextController(){
    controllerTitle.clear();
    controllerDesc.clear();
  }

  @override
  void initState(){
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Pratice"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () async{
                var pref = await SharedPreferences.getInstance();
                pref.setString(Utilities.loginpref, "");

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyLoginPage();
                },) );
              },
              child: Icon(Icons.logout)),
          ),
        ],
      ),
      drawer: buildDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CollectionReference notes = firestore.collection(Utilities.dbusers);
          buildShowModalBottomSheet(context, notes);

        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream: firestore.collection(Utilities.dbusers).doc(widget.userId).collection(Utilities.dbnotes).snapshots(),
        // stream: firestore.collection(Utilities.dbnotes).doc(widget.userId).collection(Utilities.dbusernotes).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError){
            return Center(
                child: Text("Check The Error")
            );
          }
          if(snapshot.hasData){
            var mdata = snapshot.data!.docs;
            return ListView.builder(
                itemCount: mdata.length,
                itemBuilder: (context, index) {
                  NoteModel currModel = NoteModel.fromJson(mdata[index].data());
                  return
                      ListTile(
                        title: Text(currModel.title),
                        subtitle: Text(currModel.desc),
                        onTap: () {
                            print(mdata[index].id);
                        },
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                child: Icon(Icons.edit,size: 31,color: CupertinoColors.activeGreen,),
                                onTap: () {
                                  print(mdata[index].id);
                                  // notes.doc(mdata[index]
                                  //     .id
                                  //     .toString())
                                  //     .update(
                                  //
                                  //
                                  // );
                                },
                              ),
                              InkWell(
                                child: Icon(Icons.delete,size: 31 ,color: Colors.red),
                                onTap: () {
                                  // notes.doc(mdata[index].id.toString()).delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                },
            );
          }

          return Container(child: Center(child: Text("Data Was Not Loaded")));
        },


      ),
    );
  }

  Drawer buildDrawer() {
    return Drawer(

      backgroundColor: Colors.blueAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10,),
          Container(
            height: 200,
            child: CircleAvatar(
                // child: Image.network(Utilities.loginUserImage.toString()),
                backgroundColor: Colors.yellow,
                maxRadius: 70),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("User :"),
                Text("${FirebaseAuth.instance.currentUser!.phoneNumber}"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Phone :"),
                StreamBuilder(
                  stream:FirebaseFirestore.instance.collection('users').doc().snapshots() ,
                  builder: (context, snapshot) =>  Text('${FirebaseFirestore.instance.collection('users').doc().get()}')),
                ///

              ],
            ),
          ),

        ],
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context, CollectionReference<Object?> notes) {
    return showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                children: [
                  SizedBox(height: 20,),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerDesc,
                      decoration: InputDecoration(
                          labelText: "Desc",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21))),

                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              getClearTextController();
                            },
                            child: Text("Cancel") ),
                        TextButton(
                            onPressed: () {
                              firestore
                                  .collection(Utilities.dbusers)
                                  .doc(widget.userId)
                                  .collection(Utilities.dbnotes)
                                  .add(
                                    NoteModel(
                                      title: controllerTitle.text.toString(),
                                      desc: controllerDesc.text.toString()).toMap()
                              ).then((value) => print("Note Added")).catchError((e){
                                return print("Error : ${e}");
                              }
                              ) ;
                              getClearTextController();
                            },
                            child: Text("Submit") ),
                      ],
                    ),
                  ),
                ],

              );
            },
        );
  }
}


