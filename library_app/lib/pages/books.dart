import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class MyBooks extends StatefulWidget {
  const MyBooks({Key? key}) : super(key: key);

  @override
  _MyBooksState createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> bookList = [];

  void _showBookDialog(BuildContext context, dynamic bookData) {
    DateTime loanDate = DateTime.now();
    DateTime returnDate = DateTime.now().add(Duration(days: 30));

    if (bookData.containsKey("loanDate")) {
      var loanDateTimestamp = bookData["loanDate"];
      if (loanDateTimestamp != null) {
        loanDate = loanDateTimestamp.toDate();
      }
    }

    if (bookData.containsKey("returnDate")) {
      var returnDateTimestamp = bookData["returnDate"];
      if (returnDateTimestamp != null) {
        returnDate = returnDateTimestamp.toDate();
      }
    }

    final DateFormat dateFormat = DateFormat('yyyy/MM/dd');

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
                  SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Lainattu: ${dateFormat.format(loanDate)}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Palauta: ${dateFormat.format(returnDate)} mennessä",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 17,
                                  ),
                                ),
                              ],
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
    db.collection("users").doc(user?.uid).get().then((docSnapshot) async {
      List<dynamic> loanedBooks = docSnapshot.data()?["loanedBooks"];
      List<Map<String, dynamic>> data = [];
      if (loanedBooks != null) {
        for (var bookMap in loanedBooks) {
          var bookID = bookMap["bookID"];
          var bookSnapshot = await db.collection("books").doc(bookID).get();
          if (bookSnapshot.exists) {
            var bookData = bookSnapshot.data();
            if (bookData != null) {
              data.add(bookData);
            }
          }
        }
      }
      setState(() {
        bookList = data;
      });
      print("Data retrieved!");
    }).catchError((e) => print("Error completing: $e"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(68, 255, 255, 255),
        elevation: 0,
        title: const Text(
          'Sinun Lainat',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          SizedBox(
            height: 180,
            child: GridView.count(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
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
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
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
        ],
      ),
    );
  }
}
