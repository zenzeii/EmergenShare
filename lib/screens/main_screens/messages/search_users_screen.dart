import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergenshare/components/colors.dart';
import 'package:emergenshare/screens/main_screens/messages/conversation_screen.dart';
import 'package:emergenshare/services/database.dart';
import 'package:emergenshare/services/helperfunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final moviesReff = FirebaseFirestore.instance.collection('users');

class SearchUsersScreen extends StatefulWidget {
  @override
  _SearchUsersScreenState createState() => _SearchUsersScreenState();

  void createChatRoomAndStartConversation(
      String userId, String userName, BuildContext context) {
    final String chatId =
        getChatRoomId(userId, HelperFunctions.getUserIdSharedPreference());
    final List<String> userids = [
      userId,
      HelperFunctions.getUserIdSharedPreference()
    ];
    final List<String> usernames = [
      userName,
      FirebaseAuth.instance.currentUser!.displayName!
    ];
    final Map<String, dynamic> chatRoomMap = {
      "userIds": userids,
      "chatId": chatId,
      "usernames": usernames,
      "lastTime": DateTime.now().millisecondsSinceEpoch,
      "chatStarted": false,
      "newMsgFor": "",
      "lastMsg": "",
    };
    DatabaseMethods().createChat(chatId, chatRoomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen(chatId, userName)));
  }
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  @override
  void initState() {
    super.initState();
  }

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();
  QuerySnapshot? searchSnapshot;

  Widget searchUserTile({required QueryDocumentSnapshot snapshot}) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        SearchUsersScreen().createChatRoomAndStartConversation(
            snapshot.id, (snapshot.data() as Map)['username'], context);
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
                          (snapshot.data() as Map)['username'],
                          style: const TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? searchSnapshot!.docs.length > 0
            ? ListView.builder(
                itemCount: searchSnapshot!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return searchUserTile(
                    snapshot: searchSnapshot!.docs[index],
                  );
                })
            : Container(
                child: Center(child: Text("Nichts gefunden :/")),
              )
        : Container(
            child: userSuggestions(),
          );
  }

  Widget userSuggestions() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: moviesReff.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.requireData;

        return ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                SearchUsersScreen().createChatRoomAndStartConversation(
                    snapshot.data!.docs[index].id,
                    (snapshot.data!.docs[index].data()['username']),
                    context);
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    ((data.docs[index].data())["username"]),
                                    style: const TextStyle(fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyText1?.color),
        title: TextField(
          controller: searchTextEditingController,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {
            print(value);
            final String val = value.toLowerCase();
            databaseMethods.getUsersByUsername(val).then((val) {
              setState(() {
                searchSnapshot = val;
              });
            });
          },
          onSubmitted: (value) {
            final String val = value.toLowerCase();
            databaseMethods.getUsersByUsername(val).then((val) {
              setState(() {
                searchSnapshot = val;
              });
            });
          },
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Benutzer suchen...",
            hintStyle: TextStyle(color: inputInside),
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.all(8),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                if (searchTextEditingController.text != "") {
                  searchTextEditingController.text = "";
                } else {
                  Navigator.pop(context);
                }
              });
            },
          ),
        ],
      ),
      body: searchList(),
    );
  }
}

//TODO search only in started conversations

String getChatRoomId(String a, String b) {
  if (a.compareTo(b) == 1) {
    return "${b}_$a";
  } else {
    return "${a}_$b";
  }
}
