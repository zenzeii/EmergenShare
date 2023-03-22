import 'package:emergenshare/screens/start_screens/custom_sign_in_screen.dart';
import 'package:emergenshare/screens/start_screens/custom_sign_up_screen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            SizedBox(height: 50),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "TUBADVISOR",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    "Bewertungsportal für Module\n an der TU Berlin\n",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Image.asset(
                        'lib/components/assets/images/illustration/item_backpack.png',
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                      Image.asset(
                        'lib/components/assets/images/illustration/item_graduation.png',
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                      Spacer(),
                    ],
                  ),
                  /*
                  SizedBox(height: 20),
                  Text(
                    "\nHilf anderen bei der Modulauswahl und bekomme Eindrücke über TUB Module.",
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),

                   */
                ],
              ),
            ),
            Spacer(),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 0.0, color: Colors.transparent),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomSignUpWidget()),
                );
              },
              child: const Text(
                'Register',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomSignInWidget()),
                );
              },
              child: const Text(
                'Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
