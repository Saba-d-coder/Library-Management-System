import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

class BookList extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  var bookDB = [
    {
      "name": "How Not to Be Wrong",
      "author": "Jordan Ellenberg",
      "publisher": "Penguin Group",
      "reviews": ["Too Good", "Very useful book", "A must read"],
      "image": "asset/images/wrong.jpg"
    },
    {
      "name": "Origin",
      "author": "Dan Brown",
      "publisher": "Doubleday",
      "reviews": ["Too Good", "Very useful book", "A must read"],
      "image": "asset/images/origin.jpg"
    },
    {
      "name": "Inferno",
      "author": "Dan Brown",
      "publisher": "Doubleday",
      "reviews": ["Too Good", "Very useful book", "A must read"],
      "image": "asset/images/inferno.jpeg"
    },
    {
      "name": "Database Management System",
      "author": "ABC",
      "publisher": "McGraw Hill",
      "reviews": ["Too Good", "Very useful book", "A must read"],
      "image": "asset/images/dbms.jpg"
    },
    {
      "name": "Engineering Physics",
      "author": "S. Mani Naidu",
      "publisher": "Pearson",
      "reviews": ["Too Good", "Very useful book", "A must read"],
      "image": "asset/images/physics.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: bookDB.length,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.56,
        ),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return SingleBook(
              bname: bookDB[index]['name'],
              author: bookDB[index]['author'],
              pub: bookDB[index]['publisher'],
              review: bookDB[index]['reviews'],
              img: bookDB[index]['image']);
        });
  }
}

class SingleBook extends StatelessWidget {
  SingleBook({this.bname, this.author, this.pub, this.review, this.img});

  final bname;
  final author;
  final pub;
  final review;
  final img;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: Text(bname),
        child: Material(
          color: Colors.black45,
          child: InkWell(
            onTap: () {},
            child: GridTile(
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: Column(
//                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset(
                      img,
                      height: 200.0,
//                      width: 60.0,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Text(
                      bname,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      author + ", " + pub,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            size: 18.0,
                            color: Colors.orangeAccent,
                          ),
                          Icon(
                            Icons.star,
                            size: 18.0,
                            color: Colors.orangeAccent,
                          ),
                          Icon(
                            Icons.star,
                            size: 18.0,
                            color: Colors.orangeAccent,
                          ),
                          Icon(
                            Icons.star,
                            size: 18.0,
                            color: Colors.orangeAccent,
                          ),
                          Icon(
                            Icons.star,
                            size: 18.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Text('20')
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
