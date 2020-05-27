import 'package:flutter/material.dart';
import 'package:libraryapp/Services/Book.dart';
import 'package:libraryapp/Services/Ratings.dart';
import 'package:http/http.dart' as http;
import 'package:libraryapp/constants/allConst.dart';
import 'dart:convert';
import 'package:libraryapp/Screens/displayBkDetail.dart';
import 'package:libraryapp/Services/Issued.dart';

class History extends StatefulWidget {
  List<Book> bookDB = List();
  List<Ratings> ratingDB = List();
  String uid;

  History(bookDB, uid, ratingDB) {
    this.bookDB = bookDB;
    this.uid = uid;
    this.ratingDB = ratingDB;
  }
  @override
  _HistoryState createState() => _HistoryState(bookDB, uid, ratingDB);
}

class _HistoryState extends State<History> {
  List<Book> bookDB = List();
  List<Ratings> ratingDB = List();
  List<Issued> issuedDB = List();
  String uid;
  bool loading;
  bool flag;

  _HistoryState(bookDB, uid, ratingDB) {
    this.bookDB = bookDB;
    this.uid = uid;
    this.ratingDB = ratingDB;
  }

  @override
  initState() {
    super.initState();
    getTheme();
    _HistoryState(bookDB, uid, ratingDB);
    _getHistory();
  }

  //to get user's history of library transactions
  _getHistory() async {
    setState(() {
      loading = true;
      flag = false;
    });
    String url = 'http://'+ipAddress+':3000/issuedto/'+uid;
    http.Response response = await http.get(url);
    print(response.body);
    if(response.body == '{}') {
      print('empty');
      setState(() {
        loading = false;
        flag = true;
      });
    }
    else {
      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data) {
          issuedDB.add(Issued.fromJson(i));
        }
        loading = false;
      });
      print(issuedDB[0].id);
    }
  }

  Widget bookCard(BuildContext context, var bk) {
    String text = "Rating: "+ratingDB[bk.id - 1].rating.toString()+"/5\nStatus: "+bk.status+"\nTotal no. of times taken: " + bk.totNoOfTimes.toString()+"\nLast Issued On:\n"+ bk.issuedDate.substring(0,10);
    if(bk.status != 'returned') { //display due date and fine if the book has not been returned
      text += '\nDue Date: '+bk.dueDate.substring(0,10)+'\nFine Amount: Rs.'+bk.fine.toString();
    }
    return Card(
        child: Material(
          color: kBookCardColor,
            child: InkWell(
            onTap: () { //display book details on tap
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return Detail(uid, 'asset/images/books/'+(bk.id).toString()+'.jpg', bk.id, ratingDB[bk.id - 1].rating);
              }));
            },
            child: ListTile(
              leading: Image.asset(
                'asset/images/books/'+(bk.id).toString()+'.jpg',
                height: 100,
                // width: 100,
                fit: BoxFit.fill,
              ),
              title: Text(
                bookDB[bk.id - 1].name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15),
              ),
              subtitle: Text(
                text,
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
              ),
              isThreeLine: true,
            )
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("History", style: TextStyle(color: kThemeText),),
          backgroundColor: kThemeColor,
          iconTheme: new IconThemeData(color: kThemeText),
        ),
        backgroundColor: kThemeText,
        body: loading ? Center(child: CircularProgressIndicator()) : flag ? Center( //display history as list items
        child: Text(
        'Nothing to show!',
        style: TextStyle(
            fontSize: 17,
            color: kdefaultTextColor
        ))) : ListView.builder(
            itemCount: issuedDB.length,
            itemBuilder: (BuildContext context, int index) {
              return bookCard(context, issuedDB[index]);
            }));
  }
}
