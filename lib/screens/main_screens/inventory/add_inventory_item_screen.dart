import 'package:emergenshare/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddInventoryItemScreen extends StatefulWidget {
  @override
  _Submissionstate createState() => _Submissionstate();
}

String dropdownValue = 'Select category';

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
                validator: (val) {
                  return val!.isEmpty ? 'Item cannot be empty' : null;
                },
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
                  submitFunction();
                });
              },
              child: Text('Add item to my inventory'),
            )
          ],
        ),
      ),
    );
  }

  void submitFunction() {
    if (formKeyTitle.currentState!.validate() &&
        dropdownValue != 'Select category') {
      final Map<String, dynamic> userSubmissionMap = {
        "authorId": FirebaseAuth.instance.currentUser!.uid.toString(),
        "authorName": FirebaseAuth.instance.currentUser!.displayName.toString(),
        "timeStamp": DateTime.now(),
        "itemName": _itemName.text.trim(),
        "itemAmount": _itemAmount.text.trim(),
        "category": dropdownValue,
      };
      DatabaseMethods().addInventoryItem(
        userSubmissionMap,
      );
      Navigator.pop(context);
    } else if (dropdownValue == 'Select category') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select category!'),
        ),
      );
    }
  }
}

class DropdownButtonCategory extends StatefulWidget {
  const DropdownButtonCategory({super.key});

  @override
  State<DropdownButtonCategory> createState() => _DropdownButtonCategoryState();
}

class _DropdownButtonCategoryState extends State<DropdownButtonCategory> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownValue,
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

const List<String> list = <String>[
  'Select category',
  'Food',
  'Time',
  'Material',
  'Money',
];
