import 'package:flutter/material.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService extends ChangeNotifier {
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get all the users except the current user
  // get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.data()['email'] != _auth.currentUser!.email)
          .map((doc) => doc.data())
          .toList();
    });
  }

// get all the user expect the blocked user

  Stream<List<Map<String, dynamic>>> getUsersStreamExceptBlocked() {
    final currentUser = _auth.currentUser;
    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      //get block user ids
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
      final userDocs = await _firestore.collection('Users').get();
      return userDocs.docs
          .where((doc) =>
              doc.data()['email'] != currentUser.email &&
              !blockedUserIds.contains(doc.id))
          .map((doc) => doc.data())
          .toList();
    });
  }

  //send message
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        recieverID: receiverId,
        message: message,
        timestamp: timestamp);

    // create chat room between users
    List<String> ids = [currentUserID, receiverId];
    // this is to make sure that the chat room is unique and same for both users
    ids.sort();
    String chatRoomId = ids.join('_');

    // add message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());

    notifyListeners(); // Notify listeners here
  }

  //getting messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots();
  }

  //Report User
  Future<void> reportUser(String userId, String messageId) async {
    final String currentUserID = _auth.currentUser!.uid;
    final report = {
      "reporter": currentUserID,
      "messageOwnerID": userId,
      "messageId": messageId,
      'timestamp': Timestamp.now()
    };
    await _firestore.collection("Reports").add(report);
  }

  //Block User
  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .doc(userId)
        .set({});
    notifyListeners(); // Notify listeners here
  }

  //Unblock User
  Future<void> unblockUser(String userId) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .doc(userId)
        .delete();
    // notifyListeners(); // Notify listeners here
  }

  //get blocked users stream
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();
      final userDocs = await Future.wait(blockedUserIds
          .map((id) => _firestore.collection('Users').doc(id).get()));
//return list of blocked users
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
  //Delete Message

  Future<void> deleteMessage(String chatRoomId, String messageId) async {
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .doc(messageId)
        .delete();
    notifyListeners();
  }
}
