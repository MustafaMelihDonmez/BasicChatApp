import 'package:chatapp/Pages/PrivateChatPage.dart';
import 'package:chatapp/Services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatefulWidget {
  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _uidController = TextEditingController();
  String _email = '';

  Future<void> _searchByUid() async {
    String uid = _uidController.text.trim();
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      setState(() {
        if (userDoc.exists) {
          if (userDoc['email'] != _firebaseAuth.currentUser!.email){
            _email = userDoc['email'];
          } else {
            _email = "It's you :)";
          }
        } else {
          _email = 'No user found';
        }
      });
    } catch (e) {
      setState(() {
        _email = 'Error retrieving user';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Friends'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 24, 32),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _uidController,
                      decoration: InputDecoration(
                        hintText: 'Enter UID',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _searchByUid,
                      child: const Text(
                        "Search by UID",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                color: Colors.grey.shade300,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            _email,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        if (_email.isNotEmpty && _email != 'No user found' && _email != 'Error retrieving user' && _email!= "It's you :)")
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () async {
                                await chatService.addFriend(_firebaseAuth.currentUser!.uid, _uidController.text.trim());
                                setState(() {
                                  _email = '';
                                  _uidController.clear();
                                });
                              },
                              child: Text("Add Friend"),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: chatService.getFriends(_firebaseAuth.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No friends found."));
                  } else {
                    List<Map<String, String>> friends = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
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
                            tileColor: Colors.grey.shade200,
                            title: Text(friends[index]['friend_email'] ?? ''),
                            trailing: IconButton(
                              icon: Icon(Icons.chat),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PrivateChatPage(
                                      _firebaseAuth.currentUser!.uid,
                                      friends[index]['friend_uid'] ?? '',
                                      friends[index]['friend_email'] ?? '',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
