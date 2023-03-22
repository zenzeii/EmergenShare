import 'package:firebase_auth/firebase_auth.dart';

class HelperFunctions {
  static String? getUserNameSharedPreference() {
    return FirebaseAuth.instance.currentUser!.displayName;
  }

  static void updateUserNameSharedPreference(String username) {
    FirebaseAuth.instance.currentUser!.updateDisplayName(username);
  }

  static String? getUserEmailSharedPreference() {
    return FirebaseAuth.instance.currentUser!.email;
  }

  static String getUserIdSharedPreference() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static bool userIsLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }
}
