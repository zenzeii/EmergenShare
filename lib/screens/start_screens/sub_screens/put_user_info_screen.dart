import 'dart:io';
import 'package:emergenshare/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PutUserInfoWidget extends StatefulWidget {
  @override
  _PutUserInfoWidgetForm createState() => _PutUserInfoWidgetForm();
}

class _PutUserInfoWidgetForm extends State<PutUserInfoWidget> {
  bool isLoading = false;
  bool isEmailInvalid = false;
  bool isEmailTaken = false;
  bool isNameTaken = false;
  final formKey = GlobalKey<FormState>();
  String newImageUrl = "";

  final nameCtrl = TextEditingController();
  final majorCtrl = TextEditingController();
  final studySinceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 50),
                Row(
                  children: [
                    Text('Profil',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Spacer()
                  ],
                ),
                SizedBox(height: 20),
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
                        referenceRoot.child('images/profile');
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
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: Container(
                      height: MediaQuery.of(context).size.width - 80,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          image: DecorationImage(
                            image: NetworkImage(newImageUrl != ''
                                ? newImageUrl
                                : 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
                            fit: BoxFit.cover,
                            opacity: 0.25,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: nameCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(hintText: 'Name'),
                  validator: (val) {
                    return val!.length > 30 ? 'too long' : null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    updateProfileFunction(nameCtrl, context);
                  },
                  child: isLoading
                      ? Transform.scale(
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          scale: 0.5,
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Skip',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updateProfileFunction(
      TextEditingController nameCtrl, BuildContext context) async {
    final Map<String, dynamic> userInfoMap = {
      "bio": nameCtrl.text,
    };

    DatabaseMethods().updateUserInfo(
        FirebaseAuth.instance.currentUser!.uid.toString(), userInfoMap);
    Navigator.pop(context);
  }
}
