import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  var bookDB = [
    {
      "name": "How Not to Be Wrong",
      "author": "Jordan Ellenberg",
      "publisher": "Penguin Group",
      "reviews": ["Too Good", "Very useful book", "A must read"],
      "image": "asset/images/textbooks/CPG172.jpg"
    },
    {
      "name": "Origin",
      "author": "Dan Brown",
      "publisher": "Doubleday",
      "reviews": ["Too Good", "Very useful book", "A must read"],
      "image": "asset/images/textbooks/CPG172.jpg"
    },
    {
      "name": "Inferno",
      "author": "Dan Brown",
      "publisher": "Doubleday",
      "reviews": ["Too Good", "Very useful book", "A must read"],
      "image": "asset/images/textbooks/CPG172.jpg"
    },
    {
      "name": "Database Management System",
      "author": "ABC",
      "publisher": "McGraw Hill",
      "reviews": ["Too Good", "Very useful book", "A must read"],
      "image": "asset/images/textbooks/CPG172.jpg"
    },
    {
      "name": "Engineering Physics",
      "author": "S. Mani Naidu",
      "publisher": "Pearson",
      "reviews": ["Too Good", "Very useful book", "A must read"],
      "image": "asset/images/textbooks/CPG172.jpg"
    },
  ];

  Widget bookCard(BuildContext context, var bk) {
    return Card(
      child: ListTile(
        leading: Image.asset(
          bk['image'],
          height: 100,
          // width: 100,
          fit: BoxFit.fill,
        ),
        title: Text(
          bk['name'],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15),
        ),
        subtitle: Text(
          bk['author'] + " , " + bk['publisher'],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text('Issued On: 11/06/18'),
        // dense: true,
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("History")),
        body: ListView.builder(
            itemCount: bookDB.length,
            itemBuilder: (BuildContext context, int index) {
              return bookCard(context, bookDB[index]);
            }));
  }
}
