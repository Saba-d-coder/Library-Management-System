import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  final bname;
  final author;
  final pub;
  final review;
  Detail({this.bname,this.author,this.pub,this.review});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool changeColor= false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
//               Image.asset(
//                 'asset/images/dbms.jpg',
//                 height: 200.0,
// //                      width: 60.0,
//                 fit: BoxFit.fill,
//               ),
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
          ),
          Padding(padding:EdgeInsets.only(left: 13.0),
            child: Text("reviews goes here"),
          ),
        ],
      ),
    );

  }
}
