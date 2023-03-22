import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final User? firebaseUser = result.user;
      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return 'wrong-password';
      }
    } catch (e) {
      print(e);
    }
  }

  Future resetPass(String email) async {
    try {
      return await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }
}
