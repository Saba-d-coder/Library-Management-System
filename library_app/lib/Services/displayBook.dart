import 'package:flutter/material.dart';
import 'package:libraryapp/Services/bookDetails.dart';

class BookDetail extends StatelessWidget {
  BookDetail({
    @required this.bk,
  });

  final BookDB bk;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 13.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            bk.getBookDetails(),
            Image(
                image: AssetImage(bk.getImage()),
                height: 100.0,
                fit: BoxFit.contain)
          ],
        ),
      ],
    );
  }
}
