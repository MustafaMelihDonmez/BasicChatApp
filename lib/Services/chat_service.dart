import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessages() {
    return _firestore.collection('messages').orderBy('timestamp').snapshots();
  }

  Future<void> sendMessage(String message) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _firestore.collection('messages').add({
        'text': message,
        'sender': user.email,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<User?> addFriend(String userUID, String friendUID) async {

    DocumentSnapshot friendDoc = await _firestore.collection('users').doc(friendUID).get();
    String friendEmail = friendDoc['email'];
    String userEmail = _firebaseAuth.currentUser?.email ?? '';

    await _firestore.collection('users').doc(userUID).collection('friends').doc(friendUID).set({
      'friend_uid': friendUID,
      'friend_email': friendEmail,
    });

    await _firestore.collection('users').doc(friendUID).collection('friends').doc(userUID).set({
      'friend_uid': userUID,
      'friend_email': userEmail,
    });
  }

  Future<List<Map<String, String>>> getFriends(String userUid) async {
    QuerySnapshot friendsSnapshot = await _firestore.collection('users').doc(userUid).collection('friends').get();

    return friendsSnapshot.docs.map((doc) {
      return {
        'friend_uid': doc['friend_uid'] as String,
        'friend_email': doc['friend_email'] as String,
      };
    }).toList();
  }

  Future<void> createPrivateChat(String userUID, String friendUID) async {
    String chatID;

    if (userUID.compareTo(friendUID) < 0) {
      chatID = userUID + friendUID;
    } else {
      chatID = friendUID + userUID;
    }

    CollectionReference<Map<String, dynamic>> messagesRef = _firestore.collection('chats').doc(chatID).collection('messages');

    await _firestore.collection('users').doc(userUID).collection('chats').doc(chatID).set({
      'chat_id': chatID,
    });
    await _firestore.collection('users').doc(friendUID).collection('chats').doc(chatID).set({
      'chat_id': chatID,
    });

    await messagesRef.doc('init').set({'message': 'Chat created.'});
  }

  Stream<QuerySnapshot> getPrivateChat(String userUID, String friendUID) {
    String chatID;

    if (userUID.compareTo(friendUID) < 0) {
      chatID = userUID + friendUID;
    } else {
      chatID = friendUID + userUID;
    }
    return _firestore.collection('chats').doc(chatID).collection('messages').orderBy('timestamp').snapshots();
  }

  Future<void> sendPrivateMessage(String userUID, String friendUID, String message) async {
    String chatID;

    if (userUID.compareTo(friendUID) < 0) {
      chatID = userUID + friendUID;
    } else {
      chatID = friendUID + userUID;
    }

    final user = FirebaseAuth.instance.currentUser;

    await _firestore.collection('chats').doc(chatID).collection('messages').add({
      'text': message,
      'sender': user!.email,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }


}
