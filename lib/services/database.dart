import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  //Users----------------------------------------------------------------------

  Future<QuerySnapshot> getUsersByUsername(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where(
          "username",
          isGreaterThanOrEqualTo: username,
          isLessThan: username.substring(0, username.length - 1) +
              String.fromCharCode(username.codeUnitAt(username.length - 1) + 1),
        )
        .get();
  }

  Future<QuerySnapshot> getUserByUserEmail(String userEmail) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  void uploadUserInfo(String uid, Map<String, dynamic> userMap) {
    FirebaseFirestore.instance.collection("users").doc(uid).set(userMap);
  }

  void updateUserInfo(String uid, Map<String, dynamic> userMap) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(userMap, SetOptions(merge: true));
  }

  Future<bool> isUsernameValid(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return result.docs.isEmpty;
  }

  Future<bool> isEmailValid(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isEmpty;
  }

  //Requests---------------------------------------------------------------------

  Future<void> addRequest(
    Map<String, dynamic> reviewMap,
  ) async {
    FirebaseFirestore.instance.collection("requests").doc().set(reviewMap);
  }

  Future<void> updateRequest(
    String requestId,
    Map<String, dynamic> reviewMap,
  ) async {
    FirebaseFirestore.instance
        .collection("requests")
        .doc(requestId)
        .set(reviewMap);
  }

  Future<void> deleteRequest(String requestId) async {
    FirebaseFirestore.instance.collection("requests").doc(requestId).delete();
  }

  //Items---------------------------------------------------------------------

  Future<void> addInventoryItem(
    Map<String, dynamic> reviewMap,
  ) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('inventory')
        .doc()
        .set(reviewMap);
  }

  Future<void> updateInventoryItem(
    String inventoryItemId,
    Map<String, dynamic> reviewMap,
  ) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('inventory')
        .doc(inventoryItemId)
        .set(reviewMap);
  }

  Future<void> deleteInventoryItem(String inventoryItemId) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('inventory')
        .doc(inventoryItemId)
        .delete();
  }

  //Chats----------------------------------------------------------------------

  Future<void> createChat(
      String charRoomId, Map<String, dynamic> chatRoomMap) async {
    bool chatExist = true;
    try {
      await FirebaseFirestore.instance
          .collection("chats")
          .doc(charRoomId)
          .get()
          .then((doc) {
        chatExist = doc.exists;
      });
    } catch (e) {
      chatExist = false;
    }
    if (!chatExist) {
      FirebaseFirestore.instance
          .collection("chats")
          .doc(charRoomId)
          .set(chatRoomMap);
    }
  }

  //Conversation----------------------------------------------------------------------

  void setTimeOfLastChat(String chatRoomId, int time) {
    FirebaseFirestore.instance
        .collection("chats")
        .doc(chatRoomId)
        .set({"lastTime": time, "chatStarted": true}, SetOptions(merge: true));
  }

  void addMessage(String chatRoomId, Map<String, dynamic> messageMap) {
    FirebaseFirestore.instance
        .collection("chats")
        .doc(chatRoomId)
        .set({"chatStarted": true}, SetOptions(merge: true));
    FirebaseFirestore.instance
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .add(messageMap);
  }

  Future<Stream<QuerySnapshot>> getMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots();
  }
}
