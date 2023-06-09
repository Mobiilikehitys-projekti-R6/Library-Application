import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_app/pages/register_page.dart';
import 'package:library_app/pages/verify_email_page.dart';
import '../main.dart';
import 'package:library_app/pages/reset.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signInWithEmailAndPassword() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final user = userCredential.user;

      // Check if user document exists in Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .get();

      if (!userDoc.exists) {
        // Create new user document if it doesn't exist
        final userData = {
          'email': user?.email,
          'uid': _auth.currentUser?.uid,
          'createdAt': FieldValue.serverTimestamp(),
        };
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .set(userData);
      }
      if (user!.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MyStatefulWidget(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => VerifyEmailPage(),
          ),
        );
      }
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
            child: Column(children: [
          SizedBox(height: 50),

          // Hello!
          Text(
            'Kirjaudu sisään',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),

          SizedBox(height: 70),

          // email textfield
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
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

          SizedBox(height: 20),

          // password textfield
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
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

          SizedBox(height: 25),

          // Eikö sinulla ole tiliä? Luo tili painamalla tästä! -teksti nappi.
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
              textStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPage(),
                ),
              );
            },
            child: Column(
              children: [
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

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: _isLoading ? null : _signInWithEmailAndPassword,
            child: Text(
              'Kirjaudu',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  child: Text(
                    'Unohtuiko salasana?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25BE70),
                    ),
                  ),
                  onPressed: () async {
                    if (mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ResetScreen()),
                      );
                    }
                  }),
            ],
          ),
        ])),
      ),
    );
  }
}
