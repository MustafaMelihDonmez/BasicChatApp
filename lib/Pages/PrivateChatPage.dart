import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Services/chat_service.dart';

class PrivateChatPage extends StatefulWidget {
  final String userUid;
  final String friendUid;
  final String friendEmail;

  PrivateChatPage(this.userUid, this.friendUid, this.friendEmail);

  @override
  State<PrivateChatPage> createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  final messageController = TextEditingController();

  void sendMessage() async {
    final chatService = Provider.of<ChatService>(context, listen: false);
    String message = messageController.text;

    if (message.isNotEmpty) {
      await chatService.sendPrivateMessage(widget.userUid, widget.friendUid, message);
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friendEmail),
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
              stream: chatService.getPrivateChat(widget.userUid, widget.friendUid),
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

Widget _buildMessageBox(QueryDocumentSnapshot<Object?> message){
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