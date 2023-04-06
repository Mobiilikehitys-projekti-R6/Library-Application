import 'package:flutter/material.dart';
import 'package:library_app/pages/login_page.dart';
import 'package:profile/profile.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({Key? key}) : super(key: key);

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF25BE70),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings),
            ),
            Text(
              'Profiili',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 27,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => const LoginPage()),
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        centerTitle: true,
      ),
      
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: 170.0,
              width: 700.0,
              decoration: BoxDecoration(
                borderRadius: null,
                color: Color(0xFF25BE70),
              ),
            ),
            Center(
              child: Profile(
                imageUrl:
                "https://images.unsplash.com/photo-1598618356794-eb1720430eb4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
                name: "Erkki petteri",
                website: "oamk.com",
                designation: "Student",
                email: "1234xyz@gmail.com",
                phone_number: "1234567890",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

