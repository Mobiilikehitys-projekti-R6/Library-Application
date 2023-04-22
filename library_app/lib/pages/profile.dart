import 'dart:io';

import 'package:flutter/material.dart';
import 'package:library_app/pages/login_page.dart';
import 'package:library_app/pages/profileSet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String _name = '';
  String _email = '';
  String _info = '';

  void _updateProfile() {
    User? user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          _name = doc['displayName'];
          _email = doc['email'];
          _info = doc['address'];
        });
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    _updateProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF25BE70),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfileSettings(updateProfile: _updateProfile),
                  ),
                );
              },
              icon: Icon(Icons.settings),
            ),
            Text(
              'Käyttäjätiedot',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              "Terve, $_name",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Sähköposti: $_email",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Osoite: $_info",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
