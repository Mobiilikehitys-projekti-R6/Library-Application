import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_app/pages/login_page.dart';
import 'package:library_app/pages/profileSet.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({Key? key}) : super(key: key);

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  String _name = '';
  String _email = '';
  String _info = '';
  File? _image;

  void _updateProfile(String name, String email, String info) {
    setState(() {
      _name = name;
      _email = email;
      _info = info;
    });
  }
void _updateProfilePicture(File image) {
  setState(() {
    _image = image;
  });
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
                        ProfileSettings(updateProfile: _updateProfile, updateProfilePicture: _updateProfilePicture),
                  ),
                );
              },
              icon: Icon(Icons.settings),
            ),
            Text(
              'Profiili',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
            IconButton(
              onPressed: () {
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
            InkWell(
              //onTap: _pickImage,
              child: CircleAvatar(
              backgroundImage: _image != null
                ? FileImage(_image!)
                : AssetImage('') as ImageProvider<Object>?,
              radius: 70,
              ),
            ),
            SizedBox(height: 10),
            Text(
              _name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              _email,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _info,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
