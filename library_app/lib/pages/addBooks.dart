import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  File _imageFile = File('');
  String _name = '';
  String _reservationDate = '';

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }
  
Future<void> _uploadImageToFirebase() async {
  if (_imageFile == null) {
    return;
  }

  final uuid = Uuid();
  final uniqueId = uuid.v4(); // generates a random UUID

  final Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('profile-images/$uniqueId.jpg');

  final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {
        'name': _name,
      });

  final UploadTask uploadTask =
      firebaseStorageRef.putFile(_imageFile, metadata);

  final TaskSnapshot downloadUrl = (await uploadTask);
  final String url = await downloadUrl.ref.getDownloadURL();

  print("URL of the uploaded image: $url");
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF25BE70),
        title: Text('Admin Page'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              _imageFile == null
                  ? Text('No image selected.')
                  : Image.file(_imageFile),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Choose Image'),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter name',
                ),
                onChanged: (value) {
                  _name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Upload Image'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _uploadImageToFirebase();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
