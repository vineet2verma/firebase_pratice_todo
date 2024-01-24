
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pratice_todo/constants/constants.dart';
import 'package:firebase_pratice_todo/models/model.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_pratice_todo/pages/login.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

class MySignUpPage extends StatefulWidget {
  // const MyLoginPage({super.key});

  @override
  State<MySignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {

  var controllerSignUpUserName = TextEditingController();
  var controllerSignUpPhone = TextEditingController();
  var controllerSignUpEmail = TextEditingController();
  var controllerSignUpPswd = TextEditingController();
  bool passwordVisible = true;

  void clearVal(){
    controllerSignUpUserName.clear();
    controllerSignUpPhone.clear();
    controllerSignUpEmail.clear();
    controllerSignUpPswd.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up Screen"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              TextFormField(
                controller: controllerSignUpUserName,
                decoration: InputDecoration(
                    labelText: "User Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21))),
              ), // User Name
              SizedBox(height: 10,),
              TextFormField(
                controller: controllerSignUpPhone,
                decoration: InputDecoration(
                    labelText: "Phone No",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21))),
              ), // Phone no
              SizedBox(height: 10,),
              TextFormField(
                controller: controllerSignUpEmail,
                decoration: InputDecoration(
                    labelText: "Email Id",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21))),
              ), // Email Id
              SizedBox(height: 10,),
              TextFormField(
                controller: controllerSignUpPswd,
                obscureText: passwordVisible,
                decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                      child: passwordVisible==true?Icon(Icons.remove_red_eye_rounded):Icon(Icons.remove_red_eye_outlined) ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21))),
              ), // Password

              SizedBox(height: 20,),
              InkWell(
                onTap: () async{
                  var firebase = FirebaseFirestore.instance;
                  var auth = FirebaseAuth.instance;
                  var usercred = await auth.createUserWithEmailAndPassword(
                      email: controllerSignUpEmail.text.toString(),
                      password: controllerSignUpPswd.text.toString()
                  );
                  var uuid = usercred.user!.email;
                  firebase.collection(Utilities.dbusermaster).doc(uuid).set(
                      SignUpModel(
                        EmailId: controllerSignUpEmail.text.toString(),
                        Password: controllerSignUpPswd.text.toString(),
                        PhoneNo: controllerSignUpPhone.text.toString(),
                        UserName: controllerSignUpUserName.text.toString(),
                      ).toMap()
                  );


                  firebase.collection(Utilities.dbusers).doc(uuid).set(
                    SignUpModel(
                      EmailId: controllerSignUpEmail.text.toString(),
                      Password: controllerSignUpPswd.text.toString(),
                      PhoneNo: controllerSignUpPhone.text.toString(),
                      UserName: controllerSignUpUserName.text.toString(),
                      ).toMap()
                      ).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Created")) )     );
                  clearVal();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyLoginPage();
                  },) );

                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    color: Colors.blue,
                  ),
                  child: Center(
                      child: Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 31))),
                ),
              ),
              SizedBox(height: 10,),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyLoginPage();
                  },) );
                },
                child: Text("If You have account? Sign in"),
              ),

            ],
          ),
        ),
      ),

    );
  }
}
