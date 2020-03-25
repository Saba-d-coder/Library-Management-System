import 'package:flutter/material.dart';
import 'package:libraryapp/constants/allConst.dart';

class Button extends StatelessWidget {
  Button({this.texts, this.screen});

  final texts;
  final screen;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: kThemeColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return screen;
          }));
        },
        child: Text(texts,
            textAlign: TextAlign.center,
            style: TextStyle(color: kThemeText, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
