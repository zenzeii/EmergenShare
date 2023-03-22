import 'package:emergenshare/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class PutUserInfoWidget extends StatelessWidget {
  const PutUserInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PutUserInfoWidgetForm(),
    );
  }
}

class PutUserInfoWidgetForm extends StatelessWidget {
  PutUserInfoWidgetForm({Key? key}) : super(key: key);

  bool isLoading = false;
  bool isEmailInvalid = false;
  bool isEmailTaken = false;
  bool isNameTaken = false;
  final formKey = GlobalKey<FormState>();
  String profilePicLink = "";

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
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: GFAvatar(
                      shape: GFAvatarShape.square,
                      radius: ((MediaQuery.of(context).size.width) / 2) - 40,
                      backgroundColor: Colors.black12,
                      backgroundImage: const NetworkImage(
                          "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png"),
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
                TextFormField(
                  controller: majorCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      hintText: 'Studiengang  (z.B. Informatik B.Sc.)'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: studySinceCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Studienbeginn (z.B. WS 2022)',
                  ),
                ),
                SizedBox(height: 20),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 0.0, color: Colors.transparent),
                  ),
                  onPressed: () async {
                    updateProfileFunction(
                        nameCtrl, majorCtrl, studySinceCtrl, formKey, context);
                  },
                  child: isLoading
                      ? Transform.scale(
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                          scale: 0.5,
                        )
                      : const Text(
                          'Speichern',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: Colors.transparent),
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Überspringen',
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
      TextEditingController nameCtrl,
      TextEditingController majorCtrl,
      TextEditingController studySinceCtrl,
      GlobalKey<FormState> formKey,
      BuildContext context) async {
    final Map<String, dynamic> userInfoMap = {
      "bio": nameCtrl.text,
      "major": majorCtrl.text,
      "studySince": studySinceCtrl.text,
    };

    if (formKey.currentState!.validate()) {
      DatabaseMethods().updateUserInfo(
          FirebaseAuth.instance.currentUser!.uid.toString(), userInfoMap);
      Navigator.pop(context);
    }
  }
}
