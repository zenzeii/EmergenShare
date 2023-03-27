import 'package:emergenshare/components/colors.dart';
import 'package:emergenshare/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'sub_screens/forgot_password_screen.dart';

class CustomSignInWidget extends StatelessWidget {
  const CustomSignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomEmailSignInForm(),
    );
  }
}

class CustomEmailSignInForm extends StatelessWidget {
  CustomEmailSignInForm({Key? key}) : super(key: key);

  bool isLoading = false;
  bool isEmailInDB = true;
  bool isPasswordCorrect = true;
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
                          Text('Login',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Spacer(),
                          InkWell(
                            child: Text('Forgot Password?',
                                style: const TextStyle(
                                    color: primaryColor, fontSize: 12)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()),
                              );
                            },
                          )
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
                                  .hasMatch(val!.trim())
                              ? isEmailInDB
                                  ? "Account does not exist"
                                  : null
                              : 'Email is invalid';
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: passwordCtrl,
                        decoration: InputDecoration(hintText: 'Password'),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            bool validEmail = await DatabaseMethods()
                                .isEmailValid(emailCtrl.text.trim());
                            if (!validEmail) {
                              isEmailInDB = false;
                            } else {
                              isEmailInDB = true;
                            }
                            if (formKey.currentState!.validate()) {
                              controller.setEmailAndPassword(
                                  emailCtrl.text.trim(), passwordCtrl.text);
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      state is AuthFailed
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Please check if your email and password is correct and make sure you have internet connection.",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 11,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is SigningIn) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
