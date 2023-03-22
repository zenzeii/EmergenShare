import 'package:emergenshare/screens/start_screens/custom_sign_in_screen.dart';
import 'package:emergenshare/screens/start_screens/custom_sign_up_screen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Register'),
                Tab(text: 'Login'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  CustomSignUpWidget(),
                  CustomSignInWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
