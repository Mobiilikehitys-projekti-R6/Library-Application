import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String email="email";
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
            child: Column(children: [
          const SizedBox(height: 50),

          // Hello!
          const Text(
            'Nollaa salasana',
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
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Sähköposti',
                  ),
                    onChanged: (value) {
                      setState(() {
                        email = value.trim();               
                });
  }),
              ),
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            child: Text(
              'Lähetä pyyntö',
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
                onPressed: () {
                  auth.sendPasswordResetEmail(email: email);
                  Navigator.of(context).pop();
                },
          ),
        ])),
      ),
    );
  }
}