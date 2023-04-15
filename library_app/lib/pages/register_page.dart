import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_app/pages/login_page.dart';
import 'package:library_app/pages/verify_email_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> addUserDetails(String email) async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'email': email,
      });
    } catch (e) {
      print('Tapahtui virhe. Yritä hetken päästä uudelleen.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              // Hello!
              const Text('Luo Tili',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(height: 70),
              // email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Sähköposti',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Salasana',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // confirm password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Vahvista salasana',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Column(
                  children: const [
                    Text(
                      'Joko sinulla on sellainen?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      'Takaisin kirjautumiseen',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF25BE70)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // register button
              ElevatedButton(
                onPressed: () async {
                  final String email = _emailController.text.trim();
                  final String password = _passwordController.text.trim();
                  final String confirmPassword = _confirmPasswordController.text.trim();
                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Salasanat eivät täsmää'),
                      ),
                    );
                    return;
                  }
                  try {
                    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,                     
                    );
                    await addUserDetails(email);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const VerifyEmailPage(),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Salasana on liian heikko'),
                        ),
                      );
                    } else if (e.code == 'email-already-in-use') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sähköposti on jo käytössä'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tapahtui virhe. Yritä uudelleen.'),
                      ),
                    );
                  }
                },
                child: const Text('Luo Tili'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25BE70),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
