import 'package:emergenshare/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddRequestScreen extends StatefulWidget {
  @override
  _Submissionstate createState() => _Submissionstate();
}

class _Submissionstate extends State<AddRequestScreen> {
  final formKeyTitle = GlobalKey<FormState>();
  final formKeyLocation = GlobalKey<FormState>();
  final formKeyDesc = GlobalKey<FormState>();
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
              'REQUEST HELP',
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
                decoration: const InputDecoration(hintText: "Title"),
                validator: (val) {
                  return val!.isEmpty ? 'Item cannot be empty' : null;
                },
              ),
            ),
            SizedBox(height: 10),
            Form(
              key: formKeyLocation,
              child: TextFormField(
                controller: _itemName,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
                decoration: const InputDecoration(hintText: "Location"),
              ),
            ),
            SizedBox(height: 10),
            Form(
              key: formKeyDesc,
              child: TextFormField(
                controller: _itemAmount,
                keyboardType: TextInputType.number,
                maxLines: 8,
                decoration: const InputDecoration(hintText: "Description"),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonCategory(),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                setState(() {
                  submitFunction();
                });
              },
              child: Text('Request help'),
            )
          ],
        ),
      ),
    );
  }

  void submitFunction() {
    if (formKeyTitle.currentState!.validate()) {
      final Map<String, dynamic> userSubmissionMap = {
        "authorId": FirebaseAuth.instance.currentUser!.uid.toString(),
        "authorName": FirebaseAuth.instance.currentUser!.displayName.toString(),
        "timeStamp": DateTime.now(),
        "itemName": _itemName.text.trim(),
        "itemAmount": difficultyLevel,
        "category": ratingLevel,
      };
      DatabaseMethods().addInventoryItem(
        userSubmissionMap,
      );
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

const List<String> list = <String>['Food', 'Time', 'Material', 'Money'];
