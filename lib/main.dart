import 'package:emergenshare/screens/main_screens/messages/chat_list_screen.dart';
import 'package:emergenshare/screens/check_user.dart';
import 'package:emergenshare/screens/explore_screen.dart';
import 'package:emergenshare/screens/start_screens/custom_sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firebase_options.dart';
import 'screens/news_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EmergenShare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: checkUser(),
    );
  }
}

class checkUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (FirebaseAuth.instance.currentUser == null) {
              return CustomSignUpWidget();
            }
            return Tabs();
          } else {
            return CustomSignUpWidget();
          }
        },
      );
}

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedIndex = 0;
  List screen = [
    NewsListScreen(),
    ExploreScreen(),
    NewsListScreen(),
    CheckUser(screenNumber: 2),
    /*
    NewRequestScreen(),
    ProfileScree(),
    */
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'New Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'My Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedFontSize: 12,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}
