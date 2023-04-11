import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettings extends StatefulWidget {
  final Function updateProfile;
  final Function updateProfilePicture;

  const ProfileSettings({Key? key, required this.updateProfile, required this.updateProfilePicture}) : super(key: key);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _info = '';
  File? _imageFile;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _infoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _name;
    _emailController.text = _email;
    _infoController.text = _info;
  }

  Future<void> _selectProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
       //_imageFile = File(pickedFile.path);
        widget.updateProfilePicture(File(pickedFile.path));
      });
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
                onTap: _selectProfileImage, // call _selectProfileImage method when tapped
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null ? FileImage(_imageFile!) 
                  : AssetImage('') as ImageProvider<Object>?,
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
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Sähköposti',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sähköposti ei voi olla tyhjä';
                  }
                  if (!value.contains('@')) {
                    return 'Sähköpostiosoite ei ole kelvollinen';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _infoController,
                decoration: InputDecoration(
                  labelText: 'Info',
                ),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Info ei voi olla tyhjä';
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _name = _nameController.text;
                        _email = _emailController.text;
                        _info = _infoController.text;
                      });
                      widget.updateProfile(_name, _email, _info);
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

