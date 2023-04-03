import 'package:emergenshare/components/chat_appbar.dart';
import 'package:emergenshare/components/colors.dart';
import 'package:emergenshare/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  const ConversationScreen(this.chatRoomId, this.userName);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  late Stream<QuerySnapshot> chatMessagesStream;
  late String selected;

  Widget chatMessageList() {
    return Expanded(
      child: Container(
        color: Theme.of(context).dividerColor,
        child: StreamBuilder<QuerySnapshot>(
          stream: chatMessagesStream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    padding: EdgeInsets.only(bottom: 7),
                    reverse: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return MessageTile(
                          (snapshot.data?.docs[index].data() as Map)["message"],
                          (snapshot.data?.docs[index].data()
                                  as Map)["sendBy"] ==
                              FirebaseAuth.instance.currentUser!.uid);
                    })
                : Container();
          },
        ),
      ),
    );
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      final Map<String, dynamic> messageMap = {
        "message": messageController.text.trim(),
        "sendBy": FirebaseAuth.instance.currentUser!.uid,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addMessage(widget.chatRoomId, messageMap);
      databaseMethods.setTimeOfLastChat(
          widget.chatRoomId, DateTime.now().millisecondsSinceEpoch);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO add profile picture of user
      appBar: ChatAppBar(
        title: widget.userName,
        widgets: [],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            chatMessageList(),
            messageControllerBottom(),
          ],
        ),
      ),
    );
  }

  Widget messageControllerBottom() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Material(
        elevation: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  scrollPadding: EdgeInsets.all(18),
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 1,
                  maxLines: 6,
                  controller: messageController,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1?.color,
                      fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "Message",
                    hintStyle: TextStyle(color: inputInside),
                    fillColor: Colors.transparent,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send_rounded, color: inputInside),
                onPressed: () {
                  sendMessage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  const MessageTile(this.message, this.sendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      width: MediaQuery.of(context).size.width,
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? const EdgeInsets.only(left: 40)
            : const EdgeInsets.only(right: 40),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
            color: sendByMe ? primaryColor : backgroundColor,
            borderRadius: sendByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10))
                : const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
        child: Text(
          message,
          style: TextStyle(
            color: sendByMe ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
