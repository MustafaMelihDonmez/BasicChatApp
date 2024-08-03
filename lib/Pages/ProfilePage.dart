import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Icon(Icons.person, size: 60),
                  radius: 40,
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      color: Colors.grey.shade200,
                      width: 250,
                      child: Text("E-mail: ${_firebaseAuth.currentUser!.email}"),
                    ),
                    TextButton(
                        onPressed: (){
                          Clipboard.setData(ClipboardData(text: _firebaseAuth.currentUser!.uid));
                        },
                        child: Text("Get UID")
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
