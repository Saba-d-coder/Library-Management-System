import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libraryapp/constants/allConst.dart';
import 'package:libraryapp/Services/Book.dart';
import 'package:libraryapp/Screens/displayBkDetail.dart';
import 'package:libraryapp/Services/Ratings.dart';
import 'dart:convert';

class Wishlist extends StatefulWidget {
  List<Book> bookDB = List();
  List<Ratings> ratingDB = List();
  String uid;

  Wishlist(bookDB, uid, ratingDB) {
    this.bookDB = bookDB;
    this.uid = uid;
    this.ratingDB = ratingDB;
  }
  @override
  _WishlistState createState() => _WishlistState(bookDB, uid, ratingDB);
}

class _WishlistState extends State<Wishlist> {
  bool loading = false;
  String wishlist;
  String uid;
  List<Book> bookDB = List();
  List<int> wlist = List();
  List<Ratings> ratingDB = List();
  Map<String, dynamic> profile;

  _WishlistState(bookDB, uid, ratingDB) {
    this.bookDB = bookDB;
    this.uid = uid;
    this.ratingDB = ratingDB;
  }

  @override
  initState() {
    super.initState();
    _WishlistState(bookDB, uid, ratingDB);
    _getProfile();
  }

  _getProfile() async {
    setState(() => this.loading = true);
    String url = 'http://'+ipAddress+':3000/users/'+uid;
    http.Response response = await http.get(url);
    print(response.body);
    profile = jsonDecode(response.body);
    print(profile['name']);
    this.wishlist = profile['wishlist'] != null ? profile['wishlist'].trim() : profile['wishlist'];
    print(this.wishlist);
    if(this.wishlist == null || this.wishlist.length == 0) {
      print('empty');
    }
    else if(this.wishlist.length > 1) {
      this.wlist.addAll(this.wishlist.split(',')
          .map((data) => int.parse(data))
          .toList());
    }
    else if(this.wishlist.length == 1){
      this.wlist.add(int.parse(profile['wishlist']));
    }
    setState(() => this.loading = false);
  }

  _updateWishList() async {
    print('w: '+ wlist.join(','));
    String list = wlist.length == 0 ? ' ' : wlist.join(',');
    String url = 'http://'+ipAddress+':3000/users/'+uid+'/wishlist/'+list;
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.put(url, headers: headers, body: null);
    if(response.statusCode == 200) {
      print("success");
    }
  }

  Widget bookCard(BuildContext context, var bk) {
    return Card(
      child: Material(
        color: Colors.black45,
        child: InkWell(
          onTap: () {
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
              bk.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
            subtitle: Text(
              bk.author + " , " + bk.publisher,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  wlist.remove(bk.id);
                  _updateWishList();
                  showToast('Removed from your wishlist');
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Your Wishlist")),
        body: loading ? Center(child: CircularProgressIndicator()) : this.wlist.length == 0 ? Center(
            child: Text(
                'Nothing to show!',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white70
                ))) : ListView.builder(
            itemCount: this.wlist.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(bookDB[this.wlist[index]-1].id.toString()),
                direction: DismissDirection.startToEnd,
                child: bookCard(context, bookDB[this.wlist[index]-1]),
                onDismissed: (direction) {
                  setState(() {
                    this.wlist.remove(bookDB[this.wlist[index]-1].id);
                    _updateWishList();
                    showToast('Removed from your wishlist');
                  });
                },
              );
            }));
  }
}
