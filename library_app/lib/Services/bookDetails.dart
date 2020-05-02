import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'Book.dart';

class BookList extends StatefulWidget {
  List<Book> bookDB;
  BookList(bookDB) {
    this.bookDB = bookDB;
  }
  @override
  _BookListState createState() => _BookListState(bookDB);
}

class _BookListState extends State<BookList> {
  /*var bookDB = [
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
  ];*/
  _BookListState(bookDB) {
    this.bookDB = bookDB;
  }
  @override
  void initState() {
    super.initState();
    setState(() => loading = true);
    _BookListState(bookDB);
    setState(() => loading = false);
  }
  List<Book> bookDB = List();
  var loading = false;
  /*_getAllBooks() async {
    setState(() {
      loading = true;
    });
      String url = 'http://'+ipAddress+':3000/books';
      http.Response response = await http.get(url);
      print(response.body);
      final data = jsonDecode(response.body);
    setState(() {
      for (Map i in data) {
        bookDB.add(Book.fromJson(i));
      }
      loading = false;
    });
      print(bookDB[1].publisher);
  }*/
  @override
  Widget build(BuildContext context) {
    return loading ? Center (child: CircularProgressIndicator()) : GridView.builder(
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
              bname: bookDB[index].name,
              author: bookDB[index].author,
              pub: bookDB[index].publisher);
              //review: bookDB[index]['reviews'],
              //img: bookDB[index]['image']);
          });
  }

}
class SingleBook extends StatefulWidget {
  final bname;
  final author;
  final pub;

  SingleBook({this.bname, this.author, this.pub});

  @override
  _SingleBookState createState() => _SingleBookState();
}

class _SingleBookState extends State<SingleBook> {

  bool changeColor= false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: Text(widget.bname),
        child: Material(
          color: Colors.black45,
          child: InkWell(
            onTap: () {},
            child: GridTile(
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset(
                      'asset/images/dbms.jpg',
                      height: 200.0,
//                      width: 60.0,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        title: Text(
                          widget.bname,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        subtitle: Text(
                          "By " + widget.author,
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: GestureDetector(
                          child: Icon(
                            Icons.favorite,
                            size: 28,
                            color: changeColor ? Colors.red : Colors.white,
                          ),
                          onTap: () {
                            setState(() {
                              changeColor = !changeColor;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 13.0),
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
