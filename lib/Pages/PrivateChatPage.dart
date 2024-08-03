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
      ),
      body: Column(
        children: [
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