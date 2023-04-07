import 'package:flutter/material.dart';

class MyHome extends StatelessWidget {
  const MyHome({Key? key});

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
              SizedBox(
                height: 200,
                child: GridView.count(
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 1,
                  padding: EdgeInsets.only(top: 8),
                  childAspectRatio: 1.5,
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
                height: 200,
                child: GridView.count(
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 1,
                  padding: EdgeInsets.only(top: 8),
                  childAspectRatio: 1.5,
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
                height: 200,
                child: GridView.count(
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 1,
                  padding: EdgeInsets.only(top: 8),
                  childAspectRatio: 1.5,
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
          ],
          ),
        ),
      ],
    ),
  ),
);

}
