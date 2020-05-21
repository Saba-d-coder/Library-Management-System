import 'package:flutter/material.dart';
import 'package:libraryapp/constants/allConst.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;

class RatingPage extends StatefulWidget {
  String uid;
  String img;
  int bid;
  String title;
  String author;
  RatingPage(uid, img, bid, title, author) {
    this.uid = uid;
    this.img = img;
    this.bid = bid;
    this.title = title;
    this.author = author;
  }

  @override
  _RatingPageState createState() => _RatingPageState(uid, img, bid, title, author);
}

class _RatingPageState extends State<RatingPage> {
  String uid;
  String img;
  int bid;
  String title;
  String author;
  var rating = 0.0;
  TextEditingController _review;

  @override
  initState() {
    super.initState();
    _RatingPageState(uid, img, bid, title, author);
    _review = new TextEditingController();
  }

  _RatingPageState(uid, img, bid, title, author) {
    this.uid = uid;
    this.img = img;
    this.bid = bid;
    this.title = title;
    this.author = author;
  }

  //take in and update the book reviews and rating given by the user
  _updateReviews(bkreview) async {
    print(bkreview);
    String url = 'http://'+ipAddress+':3000/reviews/uid/'+uid+'/bid/'+bid.toString();
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.put(url, headers: headers, body: bkreview);
    if(response.statusCode == 200) {
      print("success");
    }
    else {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Rate this Book',
          ),
        ),
        body: SingleChildScrollView(
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
              Center(
                child: ListTile(
                  title: Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20
                    ),
                  ),
                  subtitle: Text(
                    "By " + author,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Center(
                  child: SmoothStarRating( //to enable swipe and click to select the number of stars
                    rating: rating,
                    size: 40,
                    filledIconData: Icons.star,
                    defaultIconData: Icons.star_border,
                    color: Colors.orangeAccent,
                    borderColor: Colors.orangeAccent,
                    starCount: 5,
                    allowHalfRating: false,
                    spacing: 1.0,
                    onRated: (value) {
                      print("rating value: "+value.round().toString());
                    },
                  )
              ),
              SizedBox(
                height: 7.0,
              ),
              Center(
                child: Text(
                  "Enter your review: ",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(
                height: 7.0,
              ),
              TextFormField(
                decoration: kInputDecor('',''),
                style: kTextStyle(),
                controller: _review,
              ),
              SizedBox(
                height: 7.0,
              ),
              RaisedButton(
                child: Text("Submit"),
                shape: kShape(),
                color: kThemeColor,
                textColor: kThemeText,
                onPressed: () {
                  String review = _review.text;
                  String bkreview = '{"rating":'+rating.round().toString()+',"reviews":"'+review+'"}';
                  _updateReviews(bkreview);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        )
    );
  }
}