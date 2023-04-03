import 'package:emergenshare/components/my_card_list_widget.dart';
import 'package:emergenshare/screens/main_screens/messages/search_users_screen.dart';
import 'package:emergenshare/screens/main_screens/requests/update_request_screen.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyCard extends StatefulWidget {
  final MyCardData data;

  MyCard({required this.data});

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return MyCardDetailsScreen(
                  data: widget.data, animation: _createAnimation());
            },
          ),
        );
      },
      child: Container(
        height: 120.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 1.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              child: Container(
                width: 120.0,
                height: 120.0,
                child: Image.network(
                  widget.data.imageUrl,
                  width: 120.0,
                  height: 120.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.data.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createAnimation() {
    return CurvedAnimation(
      parent: ModalRoute.of(context)!.animation!,
      curve: Curves.easeInOut,
    );
  }
}

class MyCardDetailsScreen extends StatefulWidget {
  final MyCardData data;
  final Animation<double> animation;

  MyCardDetailsScreen({required this.data, required this.animation});

  @override
  _MyCardDetailsScreenState createState() => _MyCardDetailsScreenState();
}

class _MyCardDetailsScreenState extends State<MyCardDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 1.5,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    widget.data.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        widget.data.title,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            size: 16,
                          ),
                          Text(
                            ' ' + widget.data.location,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      ExpandableText(
                        widget.data.description,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 16.0,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        expandText: 'show more',
                        collapseText: 'show less',
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'We need:',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Wrap(children: [
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: widget.data.items.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('• '),
                                                Flexible(
                                                    child: Text(widget
                                                        .data.items[index])),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ]),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'Posted by',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                        widget.data.authorName,
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
                                            .format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                widget.data.timeStamp,
                                              ),
                                            )
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
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            child: widget.data.authorId ==
                    FirebaseAuth.instance.currentUser!.uid.toString()
                ? Container(
                    width: MediaQuery.of(context).size.width / 2 -
                        MediaQuery.of(context).size.width / 8,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateRequestScreen(
                              title: widget.data.title,
                              location: widget.data.location,
                              description: widget.data.description,
                              items: widget.data.items,
                              requestId: widget.data.requestId,
                              imageUrl: widget.data.imageUrl,
                            ),
                          ),
                        );
                      },
                      child: Text('Edit request'),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2 -
                            MediaQuery.of(context).size.width / 8,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Call'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 -
                            MediaQuery.of(context).size.width / 8,
                        child: ElevatedButton(
                          onPressed: () {
                            SearchUsersScreen()
                                .createChatRoomAndStartConversation(
                                    widget.data.authorId,
                                    widget.data.authorName,
                                    context);
                          },
                          child: Text('Message'),
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
