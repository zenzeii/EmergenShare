import 'package:emergenshare/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AddInventoryItemScreen extends StatefulWidget {
  @override
  _Submissionstate createState() => _Submissionstate();
}

String dropdownValue = 'Select category';

class _Submissionstate extends State<AddInventoryItemScreen> {
  final formKeyTitle = GlobalKey<FormState>();
  final TextEditingController _itemName = new TextEditingController();

  String imageUrl = '';
  String imageName = '';

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
            InkWell(
              onTap: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? file =
                    await imagePicker.pickImage(source: ImageSource.camera);
                if (file == null) return;
                String uniqueFileName =
                    DateTime.now().millisecondsSinceEpoch.toString();
                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages = referenceRoot.child('images');
                Reference referenceImageToUpload =
                    referenceDirImages.child(uniqueFileName);
                setState(() {});
                try {
                  await referenceImageToUpload.putFile(File(file!.path));
                  setState(() async {
                    imageUrl = await referenceImageToUpload.getDownloadURL();
                    imageName = uniqueFileName;
                  });
                } catch (error) {}
                setState(() {});
              },
              child: Container(
                height: MediaQuery.of(context).size.width - 80,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                      opacity: 0.25,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                    Text(
                      'Select Image',
                      style: TextStyle(color: Colors.black.withOpacity(0.5)),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
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
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
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
    if (formKeyTitle.currentState!.validate()) {
      final Map<String, dynamic> userSubmissionMap = {
        "authorId": FirebaseAuth.instance.currentUser!.uid.toString(),
        "authorName": FirebaseAuth.instance.currentUser!.displayName.toString(),
        "timeStamp": DateTime.now().millisecondsSinceEpoch,
        "itemName": _itemName.text.trim(),
        "itemImageUrl": imageUrl,
        "itemImageName": imageName,
      };
      DatabaseMethods().addInventoryItem(
        userSubmissionMap,
      );
      Navigator.pop(context);
    }
  }
}
