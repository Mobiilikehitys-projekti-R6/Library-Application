import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:library_app/pages/addBooks.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<Map<String, dynamic>> bookList = [];

  @override
  void initState() {
    super.initState();
    getDataOnce_getAllDocumentsInACollection();
  }

  void getDataOnce_getAllDocumentsInACollection() {
    db.collection("books").get().then(
          (querySnapshot) {
            print("Data retrieved!");
            List<Map<String, dynamic>> data = [];
            for (var docSnapshot in querySnapshot.docs) {
              data.add(docSnapshot.data());
            }
            setState(() {
              bookList = data;
            });
          },
          onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(68, 255, 255, 255),
        elevation: 0,
        title: const Text(
          'Aloitussivu',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            color: Color(0xFF25BE70),
            onPressed: () async {
              final snapshot = await FirebaseFirestore.instance
                  .collection("users")
                  .where("isAdmin", isEqualTo: true)
                  .get();
              if (snapshot.docs.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPage(),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Tapahtui virhe!"),
                      content: Text(
                          "Tämä sivu on vain Järjestelmävalvojille!"),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
body: SingleChildScrollView(
  child: Column(
    children: [
      SizedBox(      
        height: 100,
      ),
      Container(       
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Etsi...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(40.0),
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Uutuudet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
                ),),
               ]         
              ),
            ),
          SizedBox(
            height: 180,
            child: GridView.count(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              scrollDirection: Axis.horizontal,
              crossAxisCount: 1,
              shrinkWrap: true,
              childAspectRatio: (150 / 195),
              children: [
                for (var bookData in bookList)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF212325),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 8,
                        )
                      ]
                    ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  bookData["name"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                ),
                  ),
              ],
            ),
          ),
      Container(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Näitä luetaan juuri nyt',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            SizedBox(
            height: 180,
              child: GridView.count(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                scrollDirection: Axis.horizontal,
                crossAxisCount: 1,
                shrinkWrap: true,
                childAspectRatio: (150 / 195),
                children: [
                  for (int i = 0; i < 5; i++)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF212325),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 8,
                          )
                        ]
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Koska luit xyz',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
            height: 180,
              child: GridView.count(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                scrollDirection: Axis.horizontal,
                crossAxisCount: 1,
                shrinkWrap: true,
                childAspectRatio: (150 / 195),
                children: [
                  for (int i = 0; i < 5; i++)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFF212325),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 8,
                          )
                        ]
                      ),
                    ),
                ],
              ),
            ),
            ],
          ),
        ),
      ],
    ),
  ),
);

}

