import 'package:emergenshare/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AddRequestScreen extends StatefulWidget {
  @override
  _Submissionstate createState() => _Submissionstate();
}

class _Submissionstate extends State<AddRequestScreen> {
  final formKeyTitle = GlobalKey<FormState>();
  final formKeyLocation = GlobalKey<FormState>();
  final formKeyItems = GlobalKey<FormState>();
  final TextEditingController _requestTitle = new TextEditingController();
  final TextEditingController _requestLocation = new TextEditingController();
  final TextEditingController _requestDesc = new TextEditingController();
  final TextEditingController _requestItem = new TextEditingController();

  late FocusNode myFocusNode;
  List<String> _neededItems = [];
  List<bool> _selected = [];
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  Widget buildChips() {
    final List<Widget> chips = [];
    for (int i = 0; i < _neededItems.length; i++) {
      final InputChip actionChip = InputChip(
        label: Text(_neededItems[i]),
        onDeleted: () {
          _neededItems.removeAt(i);
          _selected.removeAt(i);
          setState(() {
            _neededItems = _neededItems;
            _selected = _selected;
          });
        },
      );
      chips.add(actionChip);
    }

    return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          Wrap(
            children: chips,
          ),
        ]);
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
        body: Column(
          children: [
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(40),
                children: [
                  InkWell(
                    onTap: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.gallery);
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
                        setState(() async {
                          imageUrl =
                              await referenceImageToUpload.getDownloadURL();
                        });
                      } catch (error) {}
                      setState(() {});
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
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
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Form(
                    key: formKeyTitle,
                    child: TextFormField(
                      controller: _requestTitle,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 1,
                      decoration: const InputDecoration(hintText: "Title"),
                      validator: (val) {
                        return val!.isEmpty
                            ? 'Please enter a title'
                            : val.length > 55
                                ? 'Title is too long'
                                : null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Form(
                    key: formKeyLocation,
                    child: TextFormField(
                      controller: _requestLocation,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 1,
                      decoration: const InputDecoration(hintText: "Location"),
                      validator: (val) {
                        return val!.isEmpty ? 'Please enter a location' : null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _requestDesc,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    decoration: const InputDecoration(hintText: "Description"),
                  ),
                  SizedBox(height: 10),
                  Form(
                    key: formKeyItems,
                    child: TextFormField(
                      controller: _requestItem,
                      textCapitalization: TextCapitalization.sentences,
                      focusNode: myFocusNode,
                      maxLines: 1,
                      validator: (val) {
                        return _neededItems!.isEmpty
                            ? 'Please add at least 1 item'
                            : null;
                      },
                      decoration: InputDecoration(
                        hintText: "Add needed items",
                        suffixIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _requestItem.clear();
                              },
                              icon: _requestItem.text == ""
                                  ? Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                    ),
                            ),
                            IconButton(
                              onPressed: () {
                                myFocusNode.requestFocus();
                                addKeyword(_requestItem.text);
                              },
                              icon: _requestItem.text == ""
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                            ),
                          ],
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        myFocusNode.requestFocus();
                        addKeyword(value);
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: buildChips(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  right: 40, left: 40, top: 10, bottom: 10),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    submitFunction();
                  });
                },
                child: Text('Request help'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void addKeyword(String value) {
    if (_requestItem.text.isNotEmpty) {
      _neededItems.add(_requestItem.text);
      _selected.add(true);
      _requestItem.clear();
      setState(() {
        _neededItems = _neededItems;
        _selected = _selected;
      });
    }
  }

  void submitFunction() {
    if (formKeyTitle.currentState!.validate() &&
        formKeyLocation.currentState!.validate() &&
        formKeyItems.currentState!.validate()) {
      final Map<String, dynamic> userSubmissionMap = {
        "authorId": FirebaseAuth.instance.currentUser!.uid.toString(),
        "authorName": FirebaseAuth.instance.currentUser!.displayName.toString(),
        "timeStamp": DateTime.now().millisecondsSinceEpoch,
        "requestTitle": _requestTitle.text.trim(),
        "requestLocation": _requestLocation.text.trim(),
        "requestDescription": _requestDesc.text.trim(),
        "requestItems": _neededItems,
        "requestImage": imageUrl,
      };
      DatabaseMethods().addRequest(
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
