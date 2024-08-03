import 'package:chatapp/Pages/FriendsPage.dart';
import 'package:chatapp/Pages/LoginPage.dart';
import 'package:chatapp/Pages/ProfilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/Services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final messageController = TextEditingController();

  void sendMessage() async {
    final chatService = Provider.of<ChatService>(context, listen: false);
    String message = messageController.text;

    if (message.isNotEmpty) {
      await chatService.sendMessage(message);
      messageController.clear();
    }
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context, listen: false);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Chat App', style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Friends'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FriendsPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign Out'),
              onTap: () {
                _firebaseAuth.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatService.getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];

                    return _buildMessageBox(message);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
Widget _buildMessageBox(QueryDocumentSnapshot<Object?> message){
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  return Container(
    margin: EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: (message['sender'] ==_firebaseAuth.currentUser!.email)
          ?CrossAxisAlignment.end
          :CrossAxisAlignment.start,
      children: [
        Text(
          message['text'],
          style: TextStyle(
              fontSize: 16
            ),
        ),
        Text(
          message['sender'],
          style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12
          ),
        ),
      ],
    ),
  );
}
