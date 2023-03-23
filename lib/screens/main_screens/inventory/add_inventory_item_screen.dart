import 'package:emergenshare/components/colors.dart';
import 'package:emergenshare/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddInventoryItemScreen extends StatefulWidget {
  @override
  _Submissionstate createState() => _Submissionstate();
}

class _Submissionstate extends State<AddInventoryItemScreen> {
  final formKeyTitle = GlobalKey<FormState>();
  final formKeyAmount = GlobalKey<FormState>();
  final TextEditingController _itemName = new TextEditingController();
  final TextEditingController _itemAmount = new TextEditingController();

  double ratingLevel = 0;
  double difficultyLevel = 0;

  @override
  void initState() {
    super.initState();
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
              'ADD ITEM',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1?.color),
            ),
          ],
        ),
      ),
      body: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(40),
          children: [
            SizedBox(height: 20.0),
            Form(
              key: formKeyTitle,
              child: TextFormField(
                controller: _itemName,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
                decoration: const InputDecoration(hintText: "Item name"),
              ),
            ),
            SizedBox(height: 10),
            Form(
              key: formKeyAmount,
              child: TextFormField(
                controller: _itemAmount,
                keyboardType: TextInputType.number,
                maxLines: 1,
                decoration: const InputDecoration(hintText: "Item amount"),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonCategory(),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                setState(() {
                  /*
                  submitFunction(
                    widget.data['numberOfReviewers'],
                    widget.data['rating'],
                    widget.data['difficulty'],

                  );
                   */
                });
              },
              child: Text('Add item to my inventory'),
            )
          ],
        ),
      ),
    );
  }

  void submitFunction(
    int numberOfReviewers,
    double courseRating,
    double courseDifficulty,
  ) {
    if (ratingLevel == 0 || difficultyLevel == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Mindestens ein Stern und ein Hantel')));
    } else {
      final Map<String, dynamic> userSubmissionMap = {
        "authorId": FirebaseAuth.instance.currentUser!.uid.toString(),
        "authorName": FirebaseAuth.instance.currentUser!.displayName.toString(),
        "timeStamp": DateTime.now(),
        "comment": _itemName.text.trim(),
        "difficulty": difficultyLevel,
        "rating": ratingLevel,
        "votes": 0,
      };
      /*
      DatabaseMethods().postCourseReview(
        widget.data.id.toString(),
        userSubmissionMap,
        ratingLevel,
        difficultyLevel,
        courseRating,
        courseDifficulty,
        numberOfReviewers,
      );

       */
      Navigator.pop(context);
    }
  }
}

class DropdownButtonCategory extends StatefulWidget {
  const DropdownButtonCategory({super.key});

  @override
  State<DropdownButtonCategory> createState() => _DropdownButtonCategoryState();
}

class _DropdownButtonCategoryState extends State<DropdownButtonCategory> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      hint: Text('Select Category'),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

const List<String> list = <String>['Material', 'Food', 'Time', 'Money'];
