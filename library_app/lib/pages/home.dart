import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/pages/addBooks.dart';
import 'package:library_app/searchBar.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<Map<String, dynamic>> bookList = [];

  void _showBookDialog(BuildContext context, dynamic bookData) {
    DateTime loanDate = DateTime.now();
    DateTime returnDate = loanDate.add(Duration(days: 30));

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.all(16),
        content: Container(
          height: 630,
          width: 400,
          child: Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(
                      bookData["image_url"] ?? "",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: bookData["image_url"] != null
                        ? Image.network(
                            bookData["image_url"],
                            fit: BoxFit.contain,
                          )
                        : Placeholder(),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 220),
                  Text(
                    bookData["name"] ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 1,
                          children: [
                            if (bookData["tags"].length >= 1)
                              Chip(
                                label: Text(bookData["tags"][0]),
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            if (bookData["tags"].length >= 2)
                              Chip(
                                label: Text(bookData["tags"][1]),
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            if (bookData["tags"].length > 2)
                              PopupMenuButton(
                                itemBuilder: (BuildContext context) {
                                  return [
                                    for (var i = 2;
                                        i < bookData["tags"].length;
                                        i++)
                                      PopupMenuItem(
                                        child: Text(bookData["tags"][i]),
                                      ),
                                  ];
                                },
                                child: Chip(
                                  label:
                                      Text("+${bookData["tags"].length - 2}"),
                                  backgroundColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 200, // set a fixed height for the container
                    child: SingleChildScrollView(
                      child: Text(
                        bookData["description"] ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final user = FirebaseAuth.instance.currentUser;
                            final userId = user?.uid;
                            db
                                .collection("books")
                                .doc(bookData["bookID"])
                                .update({
                                  "isLoaned": true,
                                  "loanedBy": FieldValue.arrayUnion([userId])
                                })
                                .then((_) =>
                                    print("Loan status updated successfully!"))
                                .catchError((error) => print(
                                    "Failed to update loan status: $error"));
                            db
                                .collection("users")
                                .doc(userId)
                                .update({
                                  "loanedBooks": FieldValue.arrayUnion([
                                    {
                                      "bookName": bookData["name"],
                                      "bookID": bookData["bookID"],
                                      "loanDate": loanDate,
                                      "returnDate": returnDate,
                                      "returned": false,
                                    }
                                  ]),
                                  "loanHist": FieldValue.arrayUnion([
                                    {
                                      "bookName": bookData["name"],
                                      "bookID": bookData["bookID"],
                                    }
                                  ])
                                })
                                .then((_) =>
                                    print("User data updated successfully!"))
                                .catchError((error) => print(
                                    "Failed to update user data: $error"));
                          },
                          child: Text(
                            'Varaa',
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
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
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
                        content:
                            Text("Tämä sivu on vain Järjestelmävalvojille!"),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MySearchBar(),
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Etsi...',
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MySearchBar(),
                          ),
                        );
                      },
                    ),
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
                child: Column(children: [
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
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: 180,
                child: GridView.count(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 1,
                  shrinkWrap: true,
                  childAspectRatio: (150 / 150),
                  children: [
                    for (var bookData in bookList)
                      GestureDetector(
                        onTap: () {
                          _showBookDialog(context, bookData);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 13),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: bookData["image_url"] != null
                                    ? Image.network(
                                        bookData["image_url"],
                                        fit: BoxFit.cover,
                                      )
                                    : Placeholder(),
                              ),
                              SizedBox(height: 10),
                              Text(
                                bookData["name"] ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF212325),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
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
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        scrollDirection: Axis.horizontal,
                        crossAxisCount: 1,
                        shrinkWrap: true,
                        childAspectRatio: (150 / 195),
                        children: [
                          for (int i = 0; i < 5; i++)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 13),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFF212325),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                    )
                                  ]),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        scrollDirection: Axis.horizontal,
                        crossAxisCount: 1,
                        shrinkWrap: true,
                        childAspectRatio: (150 / 195),
                        children: [
                          for (int i = 0; i < 5; i++)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 13),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFF212325),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                    )
                                  ]),
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
