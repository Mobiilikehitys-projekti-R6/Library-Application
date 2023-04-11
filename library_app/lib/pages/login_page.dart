import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_app/pages/home.dart';
import 'package:library_app/pages/register_page.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MyStatefulWidget(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Autentikoinnissa tapahtui virhe';
      if (e.code == 'user-not-found') {
        errorMessage = 'Sähköposti tai salasana on väärä';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Sähköposti tai salasana on väärä';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();
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
            const Text(
              'Kirjaudu sisään',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),

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
                  padding: EdgeInsets.only(left: 15.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
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
                  padding: EdgeInsets.only(left: 15.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Salasana',
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Eikö sinulla ole tiliä? Luo tili painamalla tästä! -teksti nappi.
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ),
                );
              },
              child: Column(
                children: const [
                  Text(
                    'Eikö sinulla ole tiliä?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Luo sellainen painamalla tästä!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25BE70),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isLoading ? null : _signInWithEmailAndPassword,
              child: Text(
                'Kirjaudu sisään',
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