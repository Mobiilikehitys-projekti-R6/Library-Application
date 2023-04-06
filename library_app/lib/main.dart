import 'package:flutter/material.dart';
import 'package:library_app/pages/books.dart';
import 'package:library_app/pages/calendar.dart';
import 'package:library_app/pages/home.dart';
import 'package:library_app/pages/profile.dart';
import 'package:library_app/pages/login_page.dart';
import 'package:library_app/pages/register_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

// FIREBASE TESTAILUA START

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: TextField(controller: controller),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                final name = controller.text;

                createUser(name: name);
              },
            ),
          ],
        ),
      );

  Future createUser({required String name}) async {
    // Ref to document
    final docUser = FirebaseFirestore.instance.collection('users').doc('my-id');

    final json = {
      'name': name,
      'age': 21,
      'birthday': DateTime(2001, 7, 28),
    };

    // Create document and write data to Firebase
    await docUser.set(json);
  }
}
// FIREBASE testailua END

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // FIREBASE TESTIN VUOKSI TÄSSÄ TÄMÄ:
      home: MainPage(),
      //  home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    MyHome(),
    MyBooks(),
    MyCalendar(),
    Myprofile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.circle, size: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle, size: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle, size: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle, size: 35),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF25BE70),
        onTap: _onItemTapped,
      ),
    );
  }
}
