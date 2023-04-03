import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future deleteuser() {
    return userCollection.doc(uid).delete();
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future deleteUser(String email, String password) async {
    try {
      final User? user = _auth.currentUser;
      final AuthCredential credentials =
          EmailAuthProvider.credential(email: email, password: password);
      final UserCredential result =
          await user!.reauthenticateWithCredential(credentials);
      await DatabaseService(uid: result.user!.uid).deleteuser();
      await result.user!.delete();
      return true;
    } catch (e) {
      return null;
    }
  }
}
