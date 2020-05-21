import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:libraryapp/Screens/displayBkDetail.dart';
import 'package:libraryapp/constants/allConst.dart';
import 'Book.dart';
import 'Ratings.dart';

class BookList extends StatefulWidget {
  String uid;
  List<Book> bookDB;
  List<Ratings> ratingDB;
  BookList(uid, bookDB, ratingDB) {
    this.uid = uid;
    this.bookDB = bookDB;
    this.ratingDB = ratingDB;
  }
  @override
  _BookListState createState() => _BookListState(uid, bookDB, ratingDB);
}

class _BookListState extends State<BookList> {
  _BookListState(uid, bookDB, ratingDB) {
    this.uid = uid;
    this.bookDB = bookDB;
    this.ratingDB = ratingDB;
  }
  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    _BookListState(uid, bookDB, ratingDB);
    setState(() {
      loading = false;
    });
  }

  List<Book> bookDB = List();
  List<Ratings> ratingDB = List();
  bool loading;
  String uid;

  @override
  Widget build(BuildContext context) { //to display the books in grid format (2 books/row)
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
              uid: this.uid,
              id: bookDB[index].id,
              bname: bookDB[index].name,
              author: bookDB[index].author,
              pub: bookDB[index].publisher,
              rating: ratingDB[index].rating,
              img: 'asset/images/books/'+(bookDB[index].id).toString()+'.jpg');
          });
  }
}

//to display details of every book
class SingleBook extends StatelessWidget {
  SingleBook({this.uid, this.id ,this.bname, this.author, this.pub, this.rating, this.review, this.img});

  final uid;
  final id;
  final bname;
  final author;
  final pub;
  final rating;
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
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Detail(uid, img, id, rating);
              }));
            },
            child: GridTile(
              child: Container(
                padding: const EdgeInsets.all(9.0),
                width: 200,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset(
                      img,
                      height: 200.0,
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
                        children: myWidget(rating)
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
