import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/pages/profile.dart';

class ProfileSettings extends StatefulWidget {
  final Function updateProfile;

  const ProfileSettings({Key? key, required this.updateProfile})
      : super(key: key);

  @override
  ProfileSettingsState createState() => ProfileSettingsState();
}

class ProfileSettingsState extends State<ProfileSettings> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _info = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();

  late User user;
  late String userId;

  void _getData() {
    User? user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          _name = doc['displayName'];
          _info = doc['address'];
          _nameController.text = _name;
          _infoController.text = _info;
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
    _getData();
  }

  Future<void> updateUserDisplayName(String displayName, String address) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'displayName': displayName, 'address': address});
    } catch (e) {
      print('Error updating user display name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF25BE70),
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Käyttäjänimi',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nimi ei voi olla tyhjä';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _infoController,
                decoration: const InputDecoration(
                  labelText: 'Osoite',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Osoite ei voi olla tyhjä';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF25BE70),
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
                        _info = _infoController.text;
                      });
                      await updateUserDisplayName(_name, _info);
                    }
                    if (mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const MyProfile()),
                      );
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
