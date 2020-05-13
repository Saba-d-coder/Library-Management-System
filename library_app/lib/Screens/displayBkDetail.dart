import 'package:flutter/material.dart';
import 'package:libraryapp/constants/allConst.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:libraryapp/Services/Reviews.dart';
import 'package:libraryapp/Services/Book.dart';
import 'package:libraryapp/Services/bookDetails.dart';
import 'package:libraryapp/Services/Ratings.dart';

class Detail extends StatefulWidget {
  String uid;
  String img;
  int bid;
  int rating;
  Detail(uid, img, bid, rating) {
    this.uid = uid;
    this.img = img;
    this.bid = bid;
    this.rating = rating;
  }

  @override
  _DetailState createState() => _DetailState(uid, img, bid, rating);
}

class _DetailState extends State<Detail> {
  bool changeColor= false;
  bool descTextShowFlag = false;

  String uid;
  String img;
  int bid;
  int rating;
  bool loading;
  String barcodeText;
  Map<String, dynamic> bookDetails;
  Map<String, dynamic> book;
  List<Reviews> reviewsDB = List();
  List<Book> recList = List();
  List<Ratings> ratingDB = List();
  List<int> wishlist = List();
  Map<String, dynamic> profile;

  _DetailState(uid, img, bid, rating) {
    this.uid = uid;
    this.img = img;
    this.bid = bid;
    this.rating = rating;
  }

  @override
  void initState() {
    super.initState();
    _DetailState(uid, img, bid, rating);
    _getBookDetails();
    _getReviews();
    _getRatings();
    _getProfile();
    _getRecommendations();
  }

  _getBookDetails() async {
    setState(() {
      loading = true;
    });
    print(bid.toString()+'  '+rating.toString() );
    String url = 'http://'+ipAddress+':3000/books/'+bid.toString();
    http.Response response = await http.get(url);
    print(response.body);
    bookDetails = jsonDecode(response.body);
    print(bookDetails['bname']);
  }

  _getReviews() async {
    String url = 'http://'+ipAddress+':3000/reviews/'+bid.toString();
    http.Response response = await http.get(url);
    print(response.body);
    final data = jsonDecode(response.body);
    setState(() {
      for (Map i in data) {
        reviewsDB.add(Reviews.fromJson(i));
      }
    });
    print(reviewsDB[1].name);
  }

  _getRatings() async {
    String url = 'http://'+ipAddress+':3000/ratings';
    http.Response response = await http.get(url);
    final data = jsonDecode(response.body);
    setState(() {
      for (Map i in data) {
        ratingDB.add(Ratings.fromJson(i));
      }
    });
    print(ratingDB[1].rating);
  }

  _getRecommendations() async {
    String url = 'http://'+ipAddress+':3000/books/rec/'+bid.toString();
    http.Response response = await http.get(url);
    print(response.body);
    final data = jsonDecode(response.body);
    setState(() {
      for (Map i in data) {
        recList.add(Book.fromJson(i));
      }
      loading = false;
    });
    print(recList[1].id);
  }

  _getProfile() async {
    String url = 'http://'+ipAddress+':3000/users/'+uid;
    http.Response response = await http.get(url);
    print(response.body);
    profile = jsonDecode(response.body);
    print(profile['name']);
    String list = profile['wishlist'] != null ? profile['wishlist'].trim() : profile['wishlist'];

    if(list == null || list.length == 0) {
      print('empty');
    }
    else if(list.length > 1) {
      wishlist = list.split(',')
          .map((data) => int.parse(data))
          .toList();
    }
    else if(list.length == 1){
      wishlist.add(int.parse(profile['wishlist']));
    }
    if(wishlist.contains(bid)) {
      changeColor = true;
    }
  }

  _getBookViaCode(code) async {
    String url = 'http://'+ipAddress+':3000/books/code/'+code;
    http.Response response = await http.get(url);
    print(response.body);
    book = jsonDecode(response.body);
    print(book['bname']);
  }

  _updateWishList() async {
    print(wishlist.join(','));
    String list = wishlist.length == 0 ? ' ' : wishlist.join(',');
    String url = 'http://'+ipAddress+':3000/users/'+uid+'/wishlist/'+list;
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.put(url, headers: headers, body: null);
    if(response.statusCode == 200) {
      print("success");
    }
  }

  ListTile myListTile(int i) {
    return ListTile(
      title: Text(
        reviewsDB[i].name,
        style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 11,
        ),
      ),
      subtitle: Text(
        reviewsDB[i].review,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      trailing: Text(
        (reviewsDB[i].rating).toString()+'/5',
        style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 11,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
        'App',
        style: TextStyle(color: kThemeText),
        ),
        backgroundColor: kThemeColor,
        iconTheme: new IconThemeData(color: kThemeText),
        actions: <Widget>[
          new MaterialButton(
            onPressed: () async {
              var result = await scan();
              print(result);
              setState(() => this.barcodeText = result);
              if(this.barcodeText != null) {
                String returnVal = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert(context);
                  },
                );
                if(returnVal == 'continue') {
                  _getBookViaCode(this.barcodeText);
                }
              }
            },
            child: Icon(
              const IconData(0xe900, fontFamily: 'ic_scanner'),
              color: kThemeText,
            ),
          ),
        ],
      ),
      body: loading ? Center (child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              img,
              height: 200.0,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(
              height: 7.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListTile(
                title: Text(
                  bookDetails['bname'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20
                  ),
                ),
                subtitle: Text(
                  "By " + bookDetails['author'],
                  style: TextStyle(fontSize: 16),
                ),
                trailing: GestureDetector(
                  child: Icon(
                    Icons.favorite,
                    size: 28,
                    color: changeColor ? Colors.red : Colors.grey,
                  ),
                  onTap: () {
                    setState(() {
                      changeColor = !changeColor;
                      if(changeColor == true) {
                        this.wishlist.add(bookDetails['bid']);
                        _updateWishList();
                        showToast('Added to your wishlist');
                      } else { print(this.wishlist.join(','));
                        if(this.wishlist.contains(bookDetails['bid'])) {
                          this.wishlist.remove(bookDetails['bid']);
                          _updateWishList();
                          showToast('Removed from your wishlist');
                        }
                      }
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 13.0),
              child: Row(
                children: myWidget(rating),
              ),
            ),
            SizedBox(
              height: 7.0,
            ),
            Card(
              color: Colors.black45,
              child: Text(
                "Published By: " + bookDetails['publisher'] + "\nSubject: " + bookDetails['subject'] + "\nNo. of books Available: " + bookDetails['noOfBooks'].toString() + "\nShelf No.:" + bookDetails['shelfNo'],
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[50],
                ),
              )
            ),
            Card(
                color: Colors.black45,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Description:\n" + bookDetails['description'],
                      maxLines: descTextShowFlag ? 50 : 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[50]
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setState(() {
                          descTextShowFlag = !descTextShowFlag;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          descTextShowFlag ? Text("Show Less",style: TextStyle(color: Colors.blue[200]),) :  Text("Show More",style: TextStyle(color: Colors.blue[200]))
                        ],
                      ),
                    ),
                  ],
                ),
            ),
            Padding(
              padding:EdgeInsets.only(left: 13.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Reviews",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  ListView.separated(
                    itemCount: reviewsDB.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    separatorBuilder: (context, index) =>
                      Divider(height: 1.0, color: Colors.grey),
                    itemBuilder: (context, index) {
                      return myListTile(index);
                    }
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Similar Books',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  Container(
                    height: 320,
                    child: ListView.builder(
                      itemCount: recList.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SingleBook(
                            id: recList[index].id,
                            bname: recList[index].name,
                            author: recList[index].author,
                            pub: recList[index].publisher,
                            rating: ratingDB[recList[index].id-1].rating,
                            img: 'asset/images/books/'+(recList[index].id).toString()+'.jpg'
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}