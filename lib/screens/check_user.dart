import 'dart:math';
import 'package:emergenshare/screens/Messages/chat_list_screen.dart';
import 'package:emergenshare/screens/start_screens/custom_sign_up_screen.dart';
import 'package:emergenshare/screens/start_screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckUser extends StatefulWidget {
  final int screenNumber;
  const CheckUser({Key? key, required this.screenNumber}) : super(key: key);

  @override
  _CheckUserState createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  List screen = [
    ChatListScreen(),
    ChatListScreen(),
    ChatListScreen(),
  ];

  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (FirebaseAuth.instance.currentUser == null) {
              return StartScreen();
            }

            return screen[widget.screenNumber];
          } else {
            return StartScreen();
          }
        },
      );
}
