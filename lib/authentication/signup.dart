
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_crud_app/authentication/login.dart';
import 'package:firestore_crud_app/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  String email = "", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController mailcontroller = TextEditingController();

  bool isVisible = false;

  final _formkey = GlobalKey<FormState>();
  File? _pickedImageFile;

  pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImageFile = File(pickedImage!.path);
    });
  }

  registration() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Registered Successfully",
        style: TextStyle(fontSize: 20.0),
      )));

      final storageRef = FirebaseStorage.instance.ref()
            .child('users')
            .child(userCredential.user!.uid);

      await storageRef.putFile(_pickedImageFile!);
      final downloadImgUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'username': name,
            'email': email,
            'imageUrl': downloadImgUrl,
          });

      await FirebaseDatabase.instance.ref().child('users')
        .child(userCredential.user!.uid)
        .set({
          'username': name,
          'email': email,
          'imageUrl': downloadImgUrl,
        });

      Navigator.push(context, 
        MaterialPageRoute(builder: (context) => const MyDashboard())
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Password Provided is too Weak",
              style: TextStyle(fontSize: 18.0),
            )));
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Account Already exists",
              style: TextStyle(fontSize: 18.0),
            )));
      }
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
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
                InkWell(
                  onTap: () {
                    pickImage();
                  },
                  child: _pickedImageFile == null
                      ? const CircleAvatar(
                          backgroundColor: Colors.purple,
                          radius: 50,
                          child: Icon(Icons.account_circle,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(_pickedImageFile!),
                          radius: 50,
                        ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(  //Name field
                          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Name';
                              }
                              return null;
                            },
                            controller: namecontroller,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Name",
                                hintStyle: TextStyle(color: Color(0xFFb2b7bf), fontSize: 18.0),
                                prefixIcon: Icon(Icons.person)
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Container( //Email field
                          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                          decoration: BoxDecoration(
                              color: const Color(0xFFedf0f8),
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Email';
                              }
                              if (!isValidEmail(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            controller: mailcontroller,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(
                                color: Color(0xFFb2b7bf), 
                                fontSize: 18.0
                              ),
                              prefixIcon: Icon(Icons.email)
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Container(  //Password field
                          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFedf0f8),
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              }
                              return null;
                            },
                            controller: passwordcontroller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: const TextStyle(
                                color: const Color(0xFFb2b7bf), 
                                fontSize: 18.0
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                }, 
                                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                              )
                            ),
                            obscureText: !isVisible,  
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        GestureDetector(
                          onTap: (){
                            if(_formkey.currentState!.validate()){
                              setState(() {
                                email=mailcontroller.text;
                                name= namecontroller.text;
                                password=passwordcontroller.text;
                              });
                            }
                            registration();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF273671),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: const Center(
                              child: Text("Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w500
                                ),
                              )
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",
                      style: TextStyle(
                        color: Color(0xFF8c8e98),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500
                      )
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const LogIn())
                        );
                      },
                      child: const Text(
                        "LogIn",
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
