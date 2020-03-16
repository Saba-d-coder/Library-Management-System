import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  InputField({this.placeholder, this.icon, this.boolValue});

  final placeholder;
  final icon;
  final boolValue;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: boolValue == "hide" ? true : false,
      style: TextStyle(
        color: Colors.cyan,
      ),
      decoration: InputDecoration(
          suffixIcon: icon,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: placeholder,
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }
}
