import 'package:emergenshare/screens/start_screens/sub_screens/put_user_info_screen.dart';
import 'package:emergenshare/services/database.dart';
import 'package:emergenshare/services/helperfunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/colors.dart';

class CustomSignUpWidget extends StatelessWidget {
  const CustomSignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomEmailSignUpForm(),
    );
  }
}

class CustomEmailSignUpForm extends StatelessWidget {
  CustomEmailSignUpForm({Key? key}) : super(key: key);

  bool isLoading = false;
  bool isEmailInvalid = false;
  bool isEmailTaken = false;
  bool isNameTaken = false;
  final formKey = GlobalKey<FormState>();

  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AuthFlowBuilder<EmailFlowController>(
      listener: (oldState, state, controller) {
        if (state is SignedIn) {
          Navigator.pop(context);
        } else if (state is AuthFailed) {
          controller.setEmailAndPassword(emailCtrl.text, passwordCtrl.text);
        }
      },
      builder: (context, state, controller, _) {
        if (state is AwaitingEmailAndPassword || state is AuthFailed) {
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
                          Text('Register',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Spacer()
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: emailCtrl,
                        decoration: InputDecoration(hintText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? isEmailInvalid
                                  ? 'Email is invalid'
                                  : isEmailTaken == true
                                      ? 'Email is already in use'
                                      : null
                              : 'Email is invalid';
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: usernameCtrl,
                        decoration: InputDecoration(hintText: 'Username'),
                        validator: (val) {
                          return val!.isEmpty || val.length < 2
                              ? 'Username is too short'
                              : val.toString().contains(" ")
                                  ? 'Username cannot contain spaces'
                                  : isNameTaken
                                      ? 'Username is taken'
                                      : val.length > 30
                                          ? 'Username is too long'
                                          : null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: passwordCtrl,
                        decoration: InputDecoration(
                          hintText: 'Password',
                        ),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (val) {
                          return val!.length > 5
                              ? null
                              : 'Password is too short';
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          SignUpFunction(controller, context);
                        },
                        child: isLoading
                            ? Transform.scale(
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                scale: 0.5,
                              )
                            : const Text(
                                'Register',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'By clicking "Register", you agree with our ',
                                style:
                                    TextStyle(color: inputInside, fontSize: 10),
                              ),
                              //TODO change Terms and Condition link if ready
                              TextSpan(
                                text: 'Terms and Condition',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 10),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(
                                        'https://docs.google.com/document/d/1mjRgjGbKqeh1lyV7QBzcweS1zKMoROrQ4xVUUK-ta-4/edit');
                                  },
                              ),
                              const TextSpan(
                                text: '.',
                                style:
                                    TextStyle(color: inputInside, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      state is AuthFailed
                          ? Text(
                              state.exception
                                  .toString()
                                  .split("] ")
                                  .last
                                  .split(" or ")
                                  .first,
                              style: TextStyle(color: Colors.red),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is SigningIn) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SigningUp) {
          controller.setEmailAndPassword(emailCtrl.text, passwordCtrl.text);
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  SignUpFunction(EmailFlowController controller, BuildContext context) async {
    final Map<String, dynamic> userInfoMap = {
      "username": usernameCtrl.text.toLowerCase(),
      "email": emailCtrl.text,
      "bio": "",
      "pic": "",
    };
    final valid = await DatabaseMethods()
        .isUsernameValid(usernameCtrl.text.toLowerCase());
    if (!valid) {
      isNameTaken = true;
    } else {
      isNameTaken = false;
    }

    if (formKey.currentState!.validate()) {
      try {
        UserCredential result =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          password: passwordCtrl.text,
          email: emailCtrl.text,
        );
        DatabaseMethods()
            .uploadUserInfo(result.user!.uid.toString(), userInfoMap);
        controller.setEmailAndPassword(emailCtrl.text, passwordCtrl.text);
        HelperFunctions.updateUserNameSharedPreference(usernameCtrl.text);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PutUserInfoWidget()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == "FirebaseAuthException" ||
            e.code == "email-already-in-use") {
          isEmailTaken = true;
          formKey.currentState!.validate();
          isEmailTaken = false;
        }
        if (e.code == "invalid-email") {
          isEmailInvalid = true;
          formKey.currentState!.validate();
          isEmailInvalid = false;
        }
      }
    }
  }
}
