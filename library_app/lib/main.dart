import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/pages/books.dart';
import 'package:library_app/pages/calendar.dart';
import 'package:library_app/pages/home.dart';
import 'package:library_app/pages/profile.dart';
import 'package:library_app/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return MyStatefulWidget();
          } else {
            return LoginPage();
          }
        },
      ),
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
