import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                const Text('Kirjaudu sisään',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    )),
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
                    child: const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: TextField(
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
                    child: const Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: TextField(
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
                        fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                  onPressed: () {},
                  child: Column(
                    children: const [
                      Text(
                        'Eikö sinulla ole tiliä?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        'Luo sellainen painamalla tästä!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Kirjaudu sisään -nappi
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Kirjaudu',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // Unohditko salasanan -teksti
              ],
            ),
          ),
        ));
  }
}
