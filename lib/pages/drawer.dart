import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 200,
            child: CircleAvatar(backgroundColor: Colors.yellow, maxRadius: 70),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("User :"),
                  Text("${FirebaseAuth.instance.currentUser!.email}"),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Phone :"),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('admin')
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .snapshots(),
                      builder: (context, snapshot) =>
                          Text('${snapshot.data!.data()!['PhoneNo']}')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
