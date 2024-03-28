import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_crud_app/screens/home_screen.dart';
import 'package:firestore_crud_app/splash_screen.dart';
import 'package:firestore_crud_app/screens/userslist.dart';
import 'package:flutter/material.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key});

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My DashBoard"),
          foregroundColor: Colors.white,
          backgroundColor: Colors.purple.shade300,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: (){
                firebaseAuth.signOut().then((value){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const SplashScreen()));
              });
              }, 
              icon: const Icon(Icons.logout, color: Colors.white,)
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home, color: Colors.white,),
                text: "Home",
              ),
              Tab(
                icon: Icon(Icons.person, color: Colors.white,),
                text: "Users",
              )
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 5,
          ),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(),
            MyUsers()
          ],
        ),
      ),
    );
  }
}