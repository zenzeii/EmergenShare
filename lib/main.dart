import 'package:emergenshare/screens/main_screens/inventory/inventory_list_screen.dart';
import 'package:emergenshare/screens/main_screens/messages/chat_list_screen.dart';
import 'package:emergenshare/screens/explore_screen.dart';
import 'package:emergenshare/screens/main_screens/requests/request_list_screen.dart';
import 'package:emergenshare/screens/start_screens/custom_start_screen.dart';
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
        primarySwatch: Colors.red,
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
              return StartScreen();
            }
            return Tabs();
          } else {
            return StartScreen();
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
    RequestListScreen(),
    InventoryListScreen(),
    ChatListScreen(),
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
            icon: Icon(Icons.live_help_rounded),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Give',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black26,
        onTap: _onItemTapped,
      ),
    );
  }
}
