import 'package:flutter/material.dart';

Color kThemeColor = Colors.cyanAccent;
Color kThemeText = Colors.black;

String ipAddress = ""; //add the ip address of your host machine

InputDecoration kInputDecor(label, hint) {
  return InputDecoration(
      labelText: label,
      hintText: hint,
      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
  );
}

InputDecoration kInputDecorProfile(label) {
  return InputDecoration(
      contentPadding: EdgeInsets.only(left: 15.0),
      labelText:  label,
      labelStyle: TextStyle(color: Colors.grey)
  );
}
TextStyle kTextStyle() {
  return TextStyle(
      color: Colors.cyan
  );
}

ShapeBorder kShape() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0),
  );
}

String uidValidator(String value) {
  Pattern pattern =
      r'^1MS[0-9][0-9][A-Z][A-Z][0-9][0-9][0-9]$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value.toUpperCase())) {
    return 'UID format is invalid';
  } else {
    return null;
  }
}

String pwdValidator(String value) {
  if (value.length < 8) {
    return 'Password must be longer than 8 characters';
  } else {
    return null;
  }
}

String emailValidator(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Email format is invalid';
  } else {
    return null;
  }
}