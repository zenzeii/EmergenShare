import 'package:emergenshare/components/my_card.dart';
import 'package:flutter/material.dart';

class MyCardListWidget extends StatelessWidget {
  final List<MyCardData> cardDataList;

  const MyCardListWidget({Key? key, required this.cardDataList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cardDataList.length,
      itemBuilder: (BuildContext context, int index) {
        return MyCard(data: cardDataList[index]);
      },
    );
  }
}

class MyCardData {
  final String imageUrl;
  final String title;
  final String location;
  final String description;
  final List items;
  final String authorId;
  final String authorName;
  final int timeStamp;

  const MyCardData({
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.items,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.timeStamp,
  });
}
