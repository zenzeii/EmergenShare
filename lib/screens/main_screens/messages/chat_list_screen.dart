import 'dart:math';
import 'package:emergenshare/screens/start_screens/custom_start_screen.dart';
import 'package:emergenshare/services/delete_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emergenshare/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergenshare/screens/main_screens/messages/conversation_screen.dart';
import 'package:emergenshare/screens/main_screens/messages/search_users_screen.dart';
import 'package:emergenshare/screens/start_screens/sub_screens/put_user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

final myChatsRef = FirebaseFirestore.instance.collection('chats');

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String conversationPartnerName(List users) {
    if (users[0] == FirebaseAuth.instance.currentUser!.displayName) {
      return users[1];
    } else {
      return users[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyText1?.color),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'CHATS',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1?.color),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchUsersScreen()),
                );
              },
              icon: Icon(Icons.search_rounded)),
          PopupMenuButton(
            onSelected: (choice) async {
              switch (choice) {
                case 'signout':
                  await FirebaseAuth.instance.signOut();
                  break;
                case 'change profile picture':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PutUserInfoWidget()),
                  );
                  break;
                case 'delete user':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeleteAccountScreen(),
                    ),
                  );
              }
            },
            icon: const Icon(Icons.more_vert_rounded),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Sign out'),
                  value: 'signout',
                ),
                PopupMenuItem(
                  child: Text('Change profile picture'),
                  value: 'change profile picture',
                ),
                PopupMenuItem(
                  child: Text('Delete User'),
                  value: 'delete user',
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Theme.of(context).dividerColor.withOpacity(0.05),
          ],
        )),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: myChatsRef
              .where('userIds',
                  arrayContains: FirebaseAuth.instance.currentUser!.uid)
              .where('chatStarted', isEqualTo: true)
              .orderBy('lastTime', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Something went wrong :("),
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Loading messages.."),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.requireData.size == 0) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/components/assets/illustration/chats.png',
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                      Text("No messages"),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.requireData.size,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationScreen(
                            (snapshot.requireData.docs[index].id),
                            conversationPartnerName(snapshot
                                .requireData.docs[index]
                                .data()["usernames"])),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).dividerColor,
                            radius: 25.0,
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      conversationPartnerName((snapshot
                                          .requireData.docs[index]
                                          .data())["usernames"]),
                                      style: const TextStyle(fontSize: 18),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      DateFormat('dd.MM.yyyy, HH:mm')
                                          .format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  (snapshot
                                                      .requireData.docs[index]
                                                      .data())["lastTime"]))
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DeleteAccountScreen extends StatefulWidget {
  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

//TODO if wrong password then alert user
class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _password = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool isPasswordCorrect = true;

  Future<void> checkPassword() async {
    if (formKey.currentState!.validate()) {
      AuthMethods()
          .signInWithEmailAndPassword(
              FirebaseAuth.instance.currentUser!.email ?? "", _password.text)
          .then((val) {
        if (val == "wrong-password") {
          setState(() {
            isPasswordCorrect = false;
          });
          formKey.currentState!.validate();
          setState(() {
            isPasswordCorrect = true;
          });
        } else {
          setState(() {
            isPasswordCorrect = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Delete Account"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Center(
                child: Text(
                    "Please type password to confirm to delete your account")),
          ),
          roundedBox(passwordInput()),
          deleteButton(),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(
                child: Text(
                    "Note: If you enter the wrong password you will be log out and your Account is NOT deleted")),
          ),
        ],
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key: formKey,
        child: TextFormField(
          validator: (val) {
            return val!.isNotEmpty ? null : "Can not be empty";
          },
          obscureText: true,
          controller: _password,
          decoration: const InputDecoration(
              hintText: "Password",
              border: InputBorder.none,
              fillColor: Colors.black),
        ),
      ),
    );
  }

  Widget deleteButton() {
    return ElevatedButton(
      onPressed: () async {
        await AuthMethods()
            .signInWithEmailAndPassword(
                FirebaseAuth.instance.currentUser!.email ?? "", _password.text)
            .then((val) async {
          if (val == "wrong-password") {
            setState(() {
              isPasswordCorrect = false;
            });
          } else {
            setState(() {
              isPasswordCorrect = true;
            });
          }
        });
        if (formKey.currentState!.validate()) {
          await AuthService().deleteUser(
              FirebaseAuth.instance.currentUser!.email ?? "", _password.text);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => StartScreen()),
            (route) => false,
          );
        }
      },
      child: Text("DELTE USER"),
    );
  }

  Widget roundedBox(Widget widget) {
    return Card(
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: widget,
      ),
    );
  }
}
