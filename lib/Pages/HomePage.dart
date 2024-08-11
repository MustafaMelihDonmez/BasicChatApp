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
                color: Colors.blueGrey.shade600,
              ),
              child: Text(
                'Chat App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.blueGrey),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(Icons.people, color: Colors.blueGrey),
                  title: Text('Friends'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FriendsPage()));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.blueGrey),
                  title: Text('Sign Out'),
                  onTap: () {
                    _firebaseAuth.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: Text('General Chat Room'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
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

          Container(
            color: Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter a message...',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue.shade600),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildMessageBox(QueryDocumentSnapshot<Object?> message) {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isCurrentUser = message['sender'] == _firebaseAuth.currentUser!.email;

  return Container(
    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    child: Column(
      crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 350,
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue[100] : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: isCurrentUser ? Radius.circular(20) : Radius.circular(0),
                bottomRight: isCurrentUser ? Radius.circular(0) : Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message['text'],
                  style: TextStyle(
                    fontSize: 16,
                    color: isCurrentUser ? Colors.black : Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  message['sender'],
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}



