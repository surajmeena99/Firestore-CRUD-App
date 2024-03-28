import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyUsers extends StatefulWidget {
  const MyUsers({super.key});

  @override
  State<MyUsers> createState() => _MyUsersState();
}

class _MyUsersState extends State<MyUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              // final DocumentSnapshot user = users[index];
              Map<String, dynamic> user = users[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['imageUrl']),
                  // backgroundImage: AssetImage('images/login.jpg'),
                ),
                title: Text(user['username']),
                subtitle: Text(user['email']),
                onTap: () {},
              );
            },
          );
        },
      ),

      /*---------------------------------by FutureBuilder------------------------------- */

      // body: FutureBuilder<QuerySnapshot>(
      //   future: FirebaseFirestore.instance.collection('users').get(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     }
      //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //       return const Center(child: Text('No users found.'));
      //     }
      //     return ListView(
      //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
      //         Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      //         return ListTile(
      //           title: Text(data['username']),
      //           subtitle: Text(data['email']),
      //           // Add more fields as needed
      //         );
      //       }).toList(),
      //     );
      //   },
      // ),

    );
  }
}