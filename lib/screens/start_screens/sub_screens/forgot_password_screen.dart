import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergenshare/screens/start_screens/custom_sign_in_screen.dart';
import 'package:emergenshare/services/auth.dart';
import 'package:flutter/material.dart';

import '../../../services/database.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = false;
  bool isEmailInDB = true;

  AuthMethods authMethods = new AuthMethods();
  final formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  late QuerySnapshot snapshotUserInfo;
  TextEditingController emailTextEditingController =
      new TextEditingController();

  Future<void> sendResetPasswordEmail() async {
    final valid =
        await databaseMethods.isEmailValid(emailTextEditingController.text);
    if (!valid) {
      setState(() {
        isEmailInDB = false;
      });
    } else {
      setState(() {
        isEmailInDB = true;
      });
    }
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      databaseMethods
          .getUserByUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
      });

      authMethods
          .resetPass(
        emailTextEditingController.text,
      )
          .then((val) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CustomSignInWidget()),
          (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(40.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50),
                    Row(
                      children: [
                        const Text(
                          "Reset Password",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 20),
                    Form(
                        key: formKey,
                        child: Column(children: [
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? isEmailInDB
                                      ? 'There is no account with this Email'
                                      : null
                                  : 'Please provide a valid email address';
                            },
                            controller: emailTextEditingController,
                            decoration: InputDecoration(hintText: 'Email'),
                            onChanged: (value) {},
                          ),
                        ])),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 0.0, color: Colors.transparent),
                      ),
                      onPressed: () {
                        sendResetPasswordEmail();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Send',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/images/login_bottom.png",
              width: size.width * 0.4,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
