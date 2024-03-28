import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_crud_app/authentication/auth.dart';
import 'package:firestore_crud_app/authentication/forgot_password.dart';
import 'package:firestore_crud_app/authentication/signup.dart';
import 'package:firestore_crud_app/dashboard.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  String email = "", password = "";

  TextEditingController mailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(context, 
        MaterialPageRoute(builder: (context) => const MyDashboard())
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0),
            )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0),
            )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "images/login.png",
                      fit: BoxFit.cover,
                    )),
                const SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                          decoration: BoxDecoration(
                              color: const Color(0xFFedf0f8),
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter E-mail';
                              }
                              return null;
                            },
                            controller: mailcontroller,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(
                                    color: Color(0xFFb2b7bf), fontSize: 18.0)),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                          decoration: BoxDecoration(
                              color: const Color(0xFFedf0f8),
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            controller: passwordcontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Color(0xFFb2b7bf), fontSize: 18.0)),
                       obscureText: true,   ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        GestureDetector(
                          onTap: (){
                            if(_formkey.currentState!.validate()){
                              setState(() {
                                email= mailcontroller.text;
                                password=passwordcontroller.text;
                              });
                            }
                            userLogin();
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13.0, horizontal: 30.0),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF273671),
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Center(
                                  child: Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w500),
                              ))),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ForgotPassword()));
                  },
                  child: const Text("Forgot Password?",
                      style: TextStyle(
                          color: Color(0xFF8c8e98),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                const Text(
                  "or LogIn with",
                  style: TextStyle(
                      color: Color(0xFF273671),
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        AuthMethods().signInWithGoogle(context);
                      },
                      child: Image.asset(
                        "images/google.png",
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",
                        style: TextStyle(
                            color: Color(0xFF8c8e98),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const SignUp()));
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                            color: Color(0xFF273671),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
