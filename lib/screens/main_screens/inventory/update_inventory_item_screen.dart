import 'package:emergenshare/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateInventoryItemScreen extends StatefulWidget {
  final String itemName;
  final String itemImageUrl;
  final String itemImageName;
  final String inventoryId;

  const UpdateInventoryItemScreen({
    super.key,
    required this.itemName,
    required this.itemImageUrl,
    required this.itemImageName,
    required this.inventoryId,
  });

  @override
  _Submissionstate createState() => _Submissionstate();
}

String dropdownValue = 'Select category';

class _Submissionstate extends State<UpdateInventoryItemScreen> {
  final formKeyTitle = GlobalKey<FormState>();
  final TextEditingController _itemName = new TextEditingController();

  late String imageUrl;
  String newImageUrl = '';
  late String imageName;
  String newImageName = '';

  @override
  void initState() {
    super.initState();
    _itemName.text = widget.itemName;
    imageUrl = widget.itemImageUrl;
    imageName = widget.itemImageName;
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
              'UPDATE ITEM',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1?.color),
            ),
          ],
        ),
      ),
      body: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(40),
                children: [
                  InkWell(
                    onTap: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.camera);
                      if (file == null) return;
                      String uniqueFileName =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('images');
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);
                      setState(() {});
                      try {
                        await referenceImageToUpload.putFile(File(file!.path));
                        newImageUrl =
                            await referenceImageToUpload.getDownloadURL();
                      } catch (error) {}
                      setState(() {});
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width - 80,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          image: DecorationImage(
                            image: NetworkImage(
                                newImageUrl != '' ? newImageUrl : imageUrl),
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
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
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
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  right: 40, left: 40, top: 10, bottom: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 -
                        MediaQuery.of(context).size.width / 8,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                          deleteFunction();
                        });
                      },
                      child: Text('Delete request'),
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
                        setState(() {
                          updateFunction();
                        });
                      },
                      child: Text('Update request'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateFunction() async {
    if (formKeyTitle.currentState!.validate()) {
      final Map<String, dynamic> userSubmissionMap = {
        "authorId": FirebaseAuth.instance.currentUser!.uid.toString(),
        "authorName": FirebaseAuth.instance.currentUser!.displayName.toString(),
        "timeStamp": DateTime.now().millisecondsSinceEpoch,
        "itemName": _itemName.text.trim(),
        "itemImageUrl": newImageUrl != '' ? newImageUrl : imageUrl,
        "itemImageName": newImageName != '' ? newImageName : imageName,
      };
      DatabaseMethods().updateInventoryItem(
        widget.inventoryId,
        userSubmissionMap,
      );
      if (newImageName != '') {
        await FirebaseStorage.instance
            .ref()
            .child('images/${imageName}.jpg')
            .delete();
      }
      Navigator.pop(context);
    }
  }

  Future<void> deleteFunction() async {
    DatabaseMethods().deleteInventoryItem(widget.inventoryId);
    if (newImageName != '') {
      await FirebaseStorage.instance
          .ref()
          .child('images/${imageName}.jpg')
          .delete();
    }
  }
}
