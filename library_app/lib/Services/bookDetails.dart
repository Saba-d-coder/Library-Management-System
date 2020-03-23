import 'package:flutter/material.dart';
import 'package:libraryapp/Services/Book.dart';

//TODO 1: change to list of different books in database
class BookDB {
  int _index = 0;

  List<Book> _bookDatabase = [
    Book('Database Management System', 'ABC', 'McGraw Hill',
        "It's a good one. Very useful", "asset/images/dbms.jpg"),
    Book('Database Management System', 'ABC', 'McGraw Hill',
        "It's a good one. Very useful", "asset/images/dbms.jpg"),
    Book('Database Management System', 'ABC', 'McGraw Hill',
        "It's a good one. Very useful", "asset/images/dbms.jpg"),
  ];

  void nextBook() {
    if (_index < _bookDatabase.length - 1) {
      _index++;
    }
  }

  Widget getBookDetails() {
    return Column(
      children: <Widget>[
        Text(_bookDatabase[_index].name +
            "\n" +
            _bookDatabase[_index].author +
            ", " +
            _bookDatabase[_index].publisher),
        Text("Review: " + _bookDatabase[_index].review),
      ],
    );
  }

  String getImage() {
    return _bookDatabase[_index].image;
  }
}
