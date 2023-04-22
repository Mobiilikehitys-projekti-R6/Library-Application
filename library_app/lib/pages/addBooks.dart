import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  late File? _imageFile = null;
  String _name = '';
  String _description = '';
  List<String> tags = [];

  final List<String> tagOptions = [
    'Kaunokirjallisuus',
    'Romaanit',
    'Lastenkirjallisuus',
    'Käännökset',
    'Englanninkielinen kirjallisuus',
    'Suomenkielinen kirjallisuus',
    'Kuvakirjat',
    'Kertomukset',
    'Elokuvat',
    'Nuortenkirjallisuus',
    'Sarjakuvat',
    'Jännityskirjallisuus',
    'Skönlitteratur',
    'Rikoskirjallisuus',
    'Muistelmat',
    'Psykologiset romaanit',
    'Äänikirjat',
    'Fiktio',
    'Oppaat (teokset)',
    'Lukemisesteisten äänikirjat',
    'Romaner',
    'Fantasiakirjallisuus',
    'Viihdekirjallisuus',
    'Runot',
    'Huumori',
    'Rakkausromaanit',
    'Historialliset romaanit',
    'Rock',
    'Matkaoppaat',
    'Elämäkerrat'
  ];

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

    final Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('book-images/$_name/$uniqueId.jpg');

    final metadata =
        SettableMetadata(contentType: 'image/jpeg', customMetadata: {
      'name': _name,
    });

    final UploadTask uploadTask =
        firebaseStorageRef.putFile(_imageFile!, metadata);

    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();

    print("URL of the uploaded image: $url");

    await FirebaseFirestore.instance.collection('books').doc(uniqueId).set({
      'name': _name,
      'bookID': uniqueId,
      'description': _description,
      'image_url': url,
      'isLoaned': false,
      'tags': tags,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF25BE70),
        title: Text('Ylläpitäjänsivu'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              _imageFile == null
                  ? Text('Ei valittua kuvaa')
                  : Image.file(
                      _imageFile!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                child: Text(
                  'Valitse kuva',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25BE70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Kirjan nimi',
                ),
                onChanged: (value) {
                  _name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nimikenttä ei voi olla tyhjä';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Kuvaus',
                ),
                onChanged: (value) {
                  _description = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kuvauskenttä ei voi olla tyhjä';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              Text('Tags:', style: TextStyle(fontSize: 16.0)),
              Column(
                children: tagOptions
                    .map((tag) => CheckboxListTile(
                          title: Text(tag),
                          value: tags.contains(tag),
                          onChanged: (checked) {
                            setState(() {
                              if (checked!) {
                                tags.add(tag);
                              } else {
                                tags.remove(tag);
                              }
                            });
                          },
                        ))
                    .toList(),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _uploadImageToFirebase();
                  }
                },
                child: Text(
                  'Luo kirja',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25BE70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
