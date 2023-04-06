import 'package:flutter/material.dart';

class MyBooks extends StatelessWidget {
  const MyBooks({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(68, 255, 255, 255),
          elevation: 0,
          title: const Text(
            'Sinun Kirjasi',
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
            Container(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
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
         SizedBox(height: 5),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.all(8),
                    children: List.generate(100, (index) {
                      return Center(
                        child: Text(
                          'Item $index',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        );
}