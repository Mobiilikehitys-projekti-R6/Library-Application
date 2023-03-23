import 'package:flutter/material.dart';
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
        body: Center(
          child: Profile(
            imageUrl: "https://images.unsplash.com/photo-1598618356794-eb1720430eb4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
            name: "Erkki petteri",
            website: "oamk.com",
            designation: "Student",
            email: "1234xyz@gmail.com",
            phone_number: "1234567890",
          ),
        ));
  }
}