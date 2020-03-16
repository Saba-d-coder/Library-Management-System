import 'package:flutter/material.dart';
import 'package:libraryapp/Services/inputFields.dart';
import 'package:libraryapp/Services/bookDetails.dart';
import 'package:libraryapp/Services/displayBook.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BookDB bk = new BookDB();

  final searchBar = InputField(
    placeholder: "Search for books",
    icon: Padding(
      padding: const EdgeInsetsDirectional.only(end: 10.0),
      child: GestureDetector(
          onTap: () {
            print("Tapped");
          },
          child: Icon(Icons.search)), // myIcon is a 48px-wide widget.
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library App'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              searchBar,
              BookDetail(bk: bk),
              BookDetail(bk: bk),
              BookDetail(bk: bk),
              BookDetail(bk: bk),
            ],
          ),
        ),
      ),
    );
  }
}
