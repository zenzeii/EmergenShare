import 'package:emergenshare/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateRequestScreen extends StatefulWidget {
  final String title;
  final String location;
  final String description;
  final List<dynamic> items;
  final String requestId;
  final String imageUrl;

  const UpdateRequestScreen({
    super.key,
    required this.title,
    required this.location,
    required this.description,
    required this.items,
    required this.requestId,
    required this.imageUrl,
  });

  @override
  _Submissionstate createState() => _Submissionstate();
}

class _Submissionstate extends State<UpdateRequestScreen> {
  final formKeyTitle = GlobalKey<FormState>();
  final formKeyLocation = GlobalKey<FormState>();
  final formKeyItems = GlobalKey<FormState>();
  final TextEditingController _requestTitle = new TextEditingController();
  final TextEditingController _requestLocation = new TextEditingController();
  final TextEditingController _requestDesc = new TextEditingController();
  final TextEditingController _requestItem = new TextEditingController();

  late FocusNode myFocusNode;
  List<dynamic> _neededItems = [];
  List<bool> _selected = [];
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    _requestTitle.text = widget.title;
    _requestLocation.text = widget.location;
    _requestDesc.text = widget.description;
    _neededItems = widget.items;
    imageUrl = widget.imageUrl;
    setState(() {});
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
              'EDIT REQUEST',
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 -
                        MediaQuery.of(context).size.width / 8,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
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

  void updateFunction() {
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
        "requestImage": imageUrl != '' ? imageUrl : '',
      };
      DatabaseMethods().updateRequest(
        widget.requestId,
        userSubmissionMap,
      );
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void deleteFunction() {
    DatabaseMethods().deleteRequest(widget.requestId);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
