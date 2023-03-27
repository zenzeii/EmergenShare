import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergenshare/services/helperfunctions.dart';
import 'package:intl/intl.dart';
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

  Future<QuerySnapshot> getCoursesByCourseName(String username) {
    return FirebaseFirestore.instance
        .collection("courses")
        .where(
          "name",
          isGreaterThanOrEqualTo: username,
          isLessThan: username.substring(0, username.length - 1) +
              String.fromCharCode(username.codeUnitAt(username.length - 1) + 1),
        )
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCourseByCourseId(
      String id) {
    return FirebaseFirestore.instance.collection("courses").doc(id).get();
  }

  void uploadCourse(Map<String, dynamic> submissionMap) {
    FirebaseFirestore.instance.collection("courses").add(submissionMap);
  }

  updateCourse(String courseId, Map<String, dynamic> submissionMap,
      Map<String, dynamic> newSubmissionMap) async {
    bool courseExist = true;
    try {
      await FirebaseFirestore.instance
          .collection("courses")
          .doc(courseId)
          .get()
          .then((doc) {
        courseExist = doc.exists;
      });
    } catch (e) {
      courseExist = false;
    }
    if (courseExist) {
      FirebaseFirestore.instance
          .collection("courses")
          .doc(courseId)
          .set(submissionMap, SetOptions(merge: true));
    } else {
      FirebaseFirestore.instance
          .collection("courses")
          .doc(courseId)
          .set(newSubmissionMap, SetOptions(merge: true));
    }
  }

  Future<void> addRequest(
    Map<String, dynamic> reviewMap,
  ) async {
    FirebaseFirestore.instance.collection("requests").doc().set(reviewMap);
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

  Future<void> editOwnCourseReview(String courseID, String newComment) async {
    String oldComment;
    FirebaseFirestore.instance
        .collection("courses")
        .doc(courseID)
        .collection('reviews')
        .doc('reviewFrom' + HelperFunctions.getUserIdSharedPreference())
        .get()
        .then((value) => {
              oldComment = value.data()!["comment"],
              FirebaseFirestore.instance
                  .collection("courses")
                  .doc(courseID)
                  .collection('reviews')
                  .doc('reviewFrom' +
                      HelperFunctions.getUserIdSharedPreference())
                  .update({
                "comment": oldComment +
                    "\n\n" +
                    "Kommentar hinzugefügt am " +
                    DateFormat('MMMM yyyy').format(DateTime.now()).toString() +
                    " : \n" +
                    newComment
              }),
            });
  }

  Future<QuerySnapshot> getCourseReviews(String courseId) async {
    return FirebaseFirestore.instance
        .collection("courses")
        .doc(courseId)
        .collection("reviews")
        .orderBy("votes", descending: true)
        .get();
  }

  Future<void> likeReviewPost(
      String courseId, String reviewId, bool liked) async {
    var reviewRef = FirebaseFirestore.instance
        .collection("courses")
        .doc(courseId)
        .collection("reviews")
        .doc(reviewId);
    if (liked) {
      reviewRef
          .collection("voters")
          .doc(HelperFunctions.getUserIdSharedPreference())
          .set({});
      reviewRef.update({'votes': FieldValue.increment(1)});
    } else {
      reviewRef
          .collection("voters")
          .doc(HelperFunctions.getUserIdSharedPreference())
          .delete();
      reviewRef.update({'votes': FieldValue.increment(-1)});
    }
  }

  Future<bool> userAlreadyLikedReview(String courseId, String reviewId) async {
    final result = await FirebaseFirestore.instance
        .collection("courses")
        .doc(courseId)
        .collection("reviews")
        .doc(reviewId)
        .collection("voters")
        .where(FieldPath.documentId,
            isEqualTo: HelperFunctions.getUserIdSharedPreference())
        .get();

    return result.docs.isNotEmpty;
  }

  Future<bool> userNeverReviewed(String courseId) async {
    final result = await FirebaseFirestore.instance
        .collection("courses")
        .doc(courseId)
        .collection("reviews")
        .where(FieldPath.documentId,
            isEqualTo:
                'reviewFrom' + HelperFunctions.getUserIdSharedPreference())
        .get();

    return result.docs.isEmpty;
  }

  Future<void> upadateReviewsAfterUserDeletion(
    String userId,
  ) async {
    DocumentSnapshot<Map<String, dynamic>> temp =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    List<dynamic> userReviewedCourses = temp["courseReviewed"];

    for (int i = 0; i < userReviewedCourses.length; i++) {
      FirebaseFirestore.instance
          .collection("courses")
          .doc(userReviewedCourses[i])
          .collection('reviews')
          .doc('reviewFrom' + userId)
          .update({'authorName': '', 'authorId': ''});
    }
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
