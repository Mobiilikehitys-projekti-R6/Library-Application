/*import 'package:flutter/material.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _info = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Muokkaa profiilia'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _name = _nameController.text;
                      _email = _emailController.text;
                      _info = _infoController.text;
                    });
                    //Navigator.pop(context);
                  }
                },
                child: Text('Tallenna'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';

class ProfileSettings extends StatefulWidget {
  final Function updateProfile;

  const ProfileSettings({Key? key, required this.updateProfile}) : super(key: key);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _info = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Muokkaa profiilia'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
              ElevatedButton(
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
                child: Text('Tallenna'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
