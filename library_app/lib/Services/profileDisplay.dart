import 'package:flutter/material.dart';

class ProfileText extends StatefulWidget {
  ProfileText({this.label, this.texts, this.textController, this.editMode});

  final String label;
  final String texts;
  final textController;
  final bool editMode;

  @override
  _ProfileTextState createState() => _ProfileTextState();
}

class _ProfileTextState extends State<ProfileText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 15.0),
        TextField(
          controller: widget.textController,
          enabled: widget.editMode,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 15.0),
              labelText: widget.label,
              labelStyle: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
