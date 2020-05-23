import 'package:flutter/material.dart';
import 'package:libraryapp/constants/allConst.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:libraryapp/Services/Reviews.dart';
import 'package:libraryapp/Services/Book.dart';
import 'package:libraryapp/Services/bookDetails.dart';
import 'package:libraryapp/Services/Ratings.dart';
import 'package:intl/intl.dart';
import 'package:libraryapp/Screens/RatingPage.dart';
import 'package:libraryapp/Services/sendMail.dart';

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
  Map<String, dynamic> issued;

  _DetailState(uid, img, bid, rating) {
    this.uid = uid;
    this.img = img;
    this.bid = bid;
    this.rating = rating;
  }

  @override
  void initState() {
    super.initState();
    getTheme();
    _DetailState(uid, img, bid, rating);
    _getBookDetails();
    _getReviews();
    _getRatings();
    _getProfile();
    _getRecommendations();
  }

  //get book details based on book id
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

  //get reviews of that book
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

  //get book ratings
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

  //get similar books based on subject and description using book id
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

  //get user profile
  Future _getProfile() async {
    String url = 'http://'+ipAddress+':3000/users/'+uid;
    http.Response response = await http.get(url);
    print(response.body);
    profile = jsonDecode(response.body);
    print(profile['name']);
    String list = profile['wishlist'] != null ? profile['wishlist'].trim() : profile['wishlist']; //to get user's wishlist

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
    if(wishlist.contains(bid)) { //if this book is part of the wishlist then turn the heart to red
      changeColor = true;
    }
    return profile;
  }

  //update user's wishlist
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

  //get book details via scanned code
  Future _getBookViaCode(code) async {
    String url = 'http://'+ipAddress+':3000/books/code/'+code;
    http.Response response = await http.get(url);
    print(response.body);
    book = jsonDecode(response.body);
    print(book['bname']);
    if(book.isEmpty) { //display msg if not scanned properly
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return message(context, 'Oops! Something went wrong, please scan the again');
        },
      );
    }
    return book['noOfBooks'];
  }

  //update no. of books user has taken
  _updateNoOfBooksUser() async {
    int noOfBooks = profile['noOfBooks'] + 1;
    print(noOfBooks);
    String url = 'http://'+ipAddress+':3000/users/'+uid+'/noOfBooks/'+noOfBooks.toString();
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.put(url, headers: headers, body: null);
    if(response.statusCode == 200) {
      print("success");
    }
  }

  //update no. of copies of that book are available
  _updateAvailable(bid) async {
    int available = book['noOfBooks'] - 1;
    print(available);
    String url = 'http://'+ipAddress+':3000/books/'+bid.toString()+'/noOfBooks/'+available.toString();
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.put(url, headers: headers, body: null);
    if(response.statusCode == 200) {
      print("success");
    }
  }

  //to check if it was preciously taken
  Future _getIfIssued(bid) async {
    String url = 'http://'+ipAddress+':3000/issuedto/uid/'+uid+'/bid/'+bid.toString();
    http.Response response = await http.get(url);
    print(response.body);
    issued = jsonDecode(response.body);
    if(issued == null) {
      print('empty');
    }
    else {
      print(issued['bid']);
    }
    return issued;
  }

  //add transaction details
  _addIssuance(context, issuance, bid) async {
    String msg;
    print(issuance);
    String url = 'http://'+ipAddress+':3000/issuedto';
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post(url, headers: headers, body: issuance);
    if(response.statusCode == 200) {
      print("success");
      _updateNoOfBooksUser();
      _updateAvailable(bid);
      msg = 'Book has been issued successfully';
      Map<String, dynamic> issuedDetails = jsonDecode(issuance);
      String bodyText = msg + "\nUSN: " + issuedDetails['uid'] +"\nBook title: "+ book['bname'] + "\nIssued Date: "+ issuedDetails['issuedDate']+"\nDue Date: "+issuedDetails['dueDate'];
      sendMail(profile['emailID'], bodyText); //send email notification
    }
    else {
      print("Error");
      msg = 'Oops! An error has occurred';
    }
    showDialog( //show msg
      context: context,
      builder: (BuildContext context) {
        return message(context, msg);
      },
    );
  }

  //update transaction details
  _updateIssuance(context, issuance, bid) async {
    String msg;
    print(issuance);
    String url = 'http://'+ipAddress+':3000/issuedto/uid/'+uid+'/bid/'+bid.toString();
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.put(url, headers: headers, body: issuance);
    if(response.statusCode == 200) {
      print("success");
      msg = 'Book has been renewed successfully';
      Map<String, dynamic> issuedDetails = jsonDecode(issuance);
      String bodyText = msg + "\nUSN: " + issuedDetails['uid'] +"\nBook title: "+ book['bname'] + "\nIssued Date: "+ issuedDetails['issuedDate']+"\nDue Date: "+issuedDetails['dueDate'];
      sendMail(profile['emailID'], bodyText); //send email notification
    }
    else {
      print("Error");
      msg = 'Oops! An error has occurred';
    }
    String val = await showDialog( //to show a message alert dialog
      context: context,
      builder: (BuildContext context) {
        return message(context, msg);
      },
    );
    if(val == 'OK') {
      if (msg.contains(
          'renewed')) { //to take the user review and rating of the book if it is being renewed
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) {
          return RatingPage(
              uid, 'asset/images/books/' + bid.toString() + '.jpg', bid,
              book['bname'], book['author']);
        }));
      }
    }
  }

  //display reviews as a list
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
      backgroundColor: kThemeText,
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
              var result = await scan(); //barcode scanner
              print(result);
              setState(() => this.barcodeText = result);

              //refer home page code for line by line explanation of the following lines of code
              if(this.barcodeText != null) {
                String returnVal = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert(context);
                  },
                );
                if(returnVal == 'continue') {
                  int nbooks = await _getBookViaCode(this.barcodeText);
                  print(nbooks);
                  Map<String, dynamic> profile = await _getProfile();
                  String msg;
                  if(nbooks > 0) {
                    print('true');
                    Map<String, dynamic> issuedbk = await _getIfIssued(book['bid']);
                    print(issuedbk);
                    var currDt = DateTime.now();
                    var formatter = DateFormat("yyyy-MM-dd");
                    String issuedDate = formatter.format(currDt);
                    print(issuedDate);
                    String dueDate = formatter.format(currDt.add(Duration(days: 15)));
                    print(dueDate);

                    if(issuedbk.isEmpty && profile['noOfBooks'] < 3) {
                      String issuance = '{"uid":"'+uid+'","bid":'+book['bid'].toString()+',"issuedDate":"'+issuedDate+'","dueDate":"'+dueDate+'","status":"issued","fine":0,"noOfRenews":0,"totNoOfTimes":1,"rating":0,"reviews":null}';
                      _addIssuance(context, issuance, book['bid']);
                    }
                    else if(issuedbk.isNotEmpty && profile['noOfBooks'] < 3) {
                      if(issuedbk['status'] != 'returned' && issuedbk['noOfRenews'] < 2) {
                        int fine = currDt.difference(DateTime.parse(issuedbk['dueDate'])).inDays;
                        print(fine);
                        if(fine < 0) {
                          fine = 0;
                          fine += issuedbk['fine'];
                        }
                        String issuance = '{"uid":"' + uid + '","bid":' +
                            book['bid'].toString() + ',"issuedDate":"' + issuedDate +
                            '","dueDate":"' + dueDate + '","status":"renewed","fine":'+fine.toString()+',"noOfRenews":'+(issuedbk['noOfRenews']+1).toString()+',"totNoOfTimes":'+(issuedbk['totNoOfTimes']+1).toString()+'}';
                        _updateIssuance(context, issuance, book['bid']);
                      }
                      else if(issuedbk['status'] == 'returned') {
                        String issuance = '{"uid":"' + uid + '","bid":' +
                            book['bid'].toString() + ',"issuedDate":"' + issuedDate +
                            '","dueDate":"' + dueDate + '","status":"issued","fine":0,"noOfRenews":0,"totNoOfTimes":'+(issuedbk['totNoOfTimes']+1).toString()+'}';
                        _updateIssuance(context, issuance, book['bid']);
                      }
                      else if(issuedbk['noOfRenews'] == 2) {
                        msg = 'Can not renew more than 2 times. Please return the book';
                      }
                    }
                    else if(profile['noOfBooks'] == 3){
                      if(issuedbk.isNotEmpty) {
                        if (issuedbk['status'] != 'returned' && issuedbk['noOfRenews'] < 2) {
                          int fine = currDt.difference(DateTime.parse(issuedbk['dueDate'])).inDays;
                          print(fine);
                          if(fine < 0) {
                            fine = 0;
                            fine += issuedbk['fine'];
                          }
                          String issuance = '{"uid":"' + uid + '","bid":' + book['bid'].toString() + ',"issuedDate":"' + issuedDate + '","dueDate":"' + dueDate + '","status":"renewed","fine":' + fine.toString() + ',"noOfRenews":' + (issuedbk['noOfRenews'] + 1).toString() + ',"totNoOfTimes":' + (issuedbk['totNoOfTimes'] + 1).toString() + '}';
                          _updateIssuance(context, issuance, book['bid']);
                        }
                      }
                      else {
                        msg = 'Max limit of books that can be taken has reached';
                      }
                    }
                    else {
                      msg = 'Max no. of renewals for this book ha reached, please retuen the book';
                    }
                  }
                  else {
                    Map<String, dynamic> issuedbk = await _getIfIssued(book['bid']);
                    if(issuedbk.isNotEmpty && (issuedbk['status'] != 'returned' && issuedbk['noOfRenews'] < 2)) {
                      var currDt = DateTime.now();
                      var formatter = DateFormat("yyyy-MM-dd");
                      String issuedDate = formatter.format(currDt);
                      print(issuedDate);
                      String dueDate = formatter.format(currDt.add(Duration(days: 15)));
                      print(dueDate);
                      int fine = currDt.difference(DateTime.parse(issuedbk['dueDate'])).inDays;
                      print(fine);
                      if(fine < 0) {
                        fine = 0;
                        fine += issuedbk['fine'];
                      }
                      String issuance = '{"uid":"' + uid + '","bid":' +
                          book['bid'].toString() + ',"issuedDate":"' + issuedDate +
                          '","dueDate":"' + dueDate + '","status":"renewed","fine":'+fine.toString()+',"noOfRenews":'+(issuedbk['noOfRenews']+1).toString()+',"totNoOfTimes":'+(issuedbk['totNoOfTimes']+1).toString()+'}';
                      _updateIssuance(context, issuance, book['bid']);
                    }
                    else if(issuedbk.isNotEmpty && (issuedbk['status'] != 'returned' && issuedbk['noOfRenews'] == 2)) {
                      msg = 'Max no. of renewals for this book ha reached, please retuen the book';
                    }
                    else {
                      msg = 'This book is unavailable';
                    }
                  }
                  if(msg != '' && msg != null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return message(context, msg);
                      },
                    );
                  }
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
      body: loading ? Center (child: CircularProgressIndicator()) : SingleChildScrollView( //to display book details
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
                trailing: GestureDetector( //to add or remove from wishlist
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
                children: myWidget(rating), //to display rating using stars
              ),
            ),
            SizedBox(
              height: 7.0,
            ),
            Card(
              child: Material(
                color: kBookCardColor,
                child: Text(
                  "Published By: " + bookDetails['publisher'] + "\nSubject: " + bookDetails['subject'] + "\nNo. of books Available: " + bookDetails['noOfBooks'].toString() + "\nShelf No.:" + bookDetails['shelfNo'],
                  style: TextStyle(
                    fontSize: 17,
                    color: kbkDetailsColor,
                  ),
                ),
              )
            ),
            Card(
                child: Material(
                  color: kBookCardColor,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Description:\n" + bookDetails['description'],
                        maxLines: descTextShowFlag ? 50 : 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: kbkDetailsColor
                        ),
                      ),
                      InkWell(
                        onTap: (){ //to show full or minimal description of book
                          setState(() {
                            descTextShowFlag = !descTextShowFlag;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            descTextShowFlag ? Text("Show Less",style: TextStyle(color: Colors.blue),) :  Text("Show More",style: TextStyle(color: Colors.blue))
                          ],
                        ),
                      ),
                    ],
                  ),
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
                  ListView.separated( //display reviews in the form of list
                    itemCount: reviewsDB.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    separatorBuilder: (context, index) =>
                      Divider(height: 1.0, color: kSeparatorColor),
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
                    child: ListView.builder( //display similar books as horizontal list
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