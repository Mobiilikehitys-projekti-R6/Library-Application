import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettings extends StatefulWidget {
  final Function updateProfile;

  ProfileSettings({Key? key, required this.updateProfile}) : super(key: key);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}
class _ProfileSettingsState extends State<ProfileSettings> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _photoURL = '';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _photoController = TextEditingController();
  late User user;
  late String userId;

  Future<void> _selectProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
       //_imageFile = File(pickedFile.path);
        widget.updateProfile(File(pickedFile.path));
      });
    }
  }



Future<void> updateUserDisplayName(String displayName) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update({'displayName': displayName});
  } catch (e) {
    print('Error updating user display name: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF25BE70),
        elevation: 0,
        title: const Text(
          'Asetukset',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _selectProfileImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _photoURL.isNotEmpty ? NetworkImage(_photoURL)
                  : null,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nimi',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nimi ei voi olla tyhjä';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF25BE70),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _name = _nameController.text;
                        _photoURL = _photoController.text;
                        /*_email = _emailController.text;
                        _info = _infoController.text;*/
                      });
                      await updateUserDisplayName(_name);
                      widget.updateProfile(_name);
                      //Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Tallenna',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

