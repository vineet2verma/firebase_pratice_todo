import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pratice_todo/constants/constants.dart';
import 'package:firebase_pratice_todo/pages/home_page.dart';
import 'package:firebase_pratice_todo/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLoginPage extends StatefulWidget {
  // const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  var controllerLoginEmail = TextEditingController();
  var controllerLoginPswd = TextEditingController();
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
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
              SizedBox(
                height: 40,
              ),
              Text("Sign in",
                  style: TextStyle(fontSize: 31, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: controllerLoginEmail,
                decoration: InputDecoration(
                    labelText: "Email id",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21))),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: controllerLoginPswd,
                obscureText: _passwordVisible,
                decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        child: Icon(Icons.remove_red_eye_rounded)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21))),
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () {
                    return print("Forgot Password");
                  },
                  child: Text("Forgot Password")),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  var auth = FirebaseAuth.instance;
                  try {
                    var userCred = await auth.signInWithEmailAndPassword(
                        email: controllerLoginEmail.text
                                .toString()
                                .contains("@")
                            ? controllerLoginEmail.text.toString()
                            : controllerLoginEmail.text.toString() + "@abc.com",
                        password: controllerLoginPswd.text.toString());
                    var pref = await SharedPreferences.getInstance();
                    pref.setString(Utilities.loginpref, userCred.user!.uid);

                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return MyHomePage(userId: userCred.user!.uid);
                      },
                    ));
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("No user found for that email.")));
                    } else if (e.code == 'wrong-password') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("Wrong password provided for that user.")));
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    color: Colors.blue,
                  ),
                  child: Center(
                      child: Text("Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 31))),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return MySignUpPage();
                    },
                  ));
                },
                child: Text("Does not have account?  Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
