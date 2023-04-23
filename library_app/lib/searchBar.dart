import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class MySearchBar extends StatefulWidget {
  const MySearchBar({Key? key}) : super(key: key);

  @override
  _MySearchBarState createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  String searchQuery = '';
  List<String> searchResults = [];

  void handleSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchQuery = '';
        searchResults = [];
      });
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('name', isGreaterThanOrEqualTo: query)
        .get();

    setState(() {
      searchQuery = query;
      searchResults =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF25BE70),
        title: TextField(
          onChanged: handleSearch,
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: searchQuery.isNotEmpty
          ? ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                final bookName = searchResults[index];
                return ListTile(
                  title: Text(bookName),
                  onTap: () async {
                    final snapshot = await FirebaseFirestore.instance
                        .collection('books')
                        .where('name', isEqualTo: bookName)
                        .get();
                    if (snapshot.docs.isNotEmpty) {
                      final bookData = snapshot.docs[0].data();
                      _showBookDialog(context, bookData);
                    }
                  },
                );
              },
            )
          : Container(),
    );
  }
}
