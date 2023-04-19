import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:library_app/pages/addBooks.dart';


Future<List<List<Map<String, dynamic>>>> getDataFromFolders() async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ListResult result = await storage.ref().child('book-images').listAll();

  final List<List<Map<String, dynamic>>> dataArrays = [];

  for (final Reference ref in result.items) {
    final String folderName = ref.name;
    final List<Map<String, dynamic>> dataArray = [];

final QuerySnapshot querySnapshot = (await FirebaseFirestore.instance
    .collection('books')
    .doc(folderName)
    .get()) as QuerySnapshot<Object?>;

    querySnapshot.docs.forEach((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      dataArray.add(data);
    });

    dataArrays.add(dataArray);
  }

  return dataArrays;
}

class MyHome extends StatelessWidget {
  MyHome({Key? key});
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
            'Kuumat uutuudet',
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
FutureBuilder<List<List<Map<String, dynamic>>>>(
  future: getDataFromFolders(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    final dataArrays = snapshot.data!;

    return SizedBox(
      height: 150,
      child: GridView.count(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        scrollDirection: Axis.horizontal,
        crossAxisCount: 1,
        shrinkWrap: true,
        childAspectRatio: (150 / 195),
        children: [
          for (final dataArray in dataArrays)
            for (int i = 0; i < dataArray.length; i++)
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      dataArray[i]['image_url'],
                      height: 120,
                    ),
                    SizedBox(height: 5),
                    /*Text(
                      dataArray[i]['id'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),*/
                  ],
                ),
              ),
        ],
      ),
    );
  },
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
              height: 150,
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
              height: 150,
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

