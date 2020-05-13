import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:fluttertoast/fluttertoast.dart';

Color kThemeColor = Colors.cyanAccent;
Color kThemeText = Colors.black;

String ipAddress = "35.225.115.85"; //add the ip address of your host machine

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

List<Widget> myWidget(int count) {
  return List.generate(count+1, (i) => (i < count) ? Icon(
    Icons.star,
    size: 18.0,
    color: Colors.orangeAccent,
  ) : Text("/5")
  ).toList();
}

Future scan() async {
  try {
    String barcode = await BarcodeScanner.scan();
    print(barcode);
    return barcode;
  } on PlatformException catch (e) {
    if (e.code == BarcodeScanner.CameraAccessDenied) {
      print('The user did not grant the camera permission!');
    } else {
      print('Unknown error: $e');
    }
  } on FormatException {
    print('null (User returned using the "back"-button before scanning anything. Result)');
  } catch (e) {
    print('Unknown error: $e');
  }
}

Widget cancelButton(context) {
  return FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context, 'cancel');
    },
  );
}

Widget continueButton(context) {
  return FlatButton(
    child: Text("Continue"),
    onPressed: () {
      Navigator.pop(context, 'continue');
    },
  );
}

// set up the AlertDialog
AlertDialog alert(context) {
  return AlertDialog(
    title: Text("Alert"),
    content: Text("Would you like to proceed with the transaction?"),
    actions: [
      cancelButton(context),
      continueButton(context),
    ],
  );
}

showToast(text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.white,
    textColor: Colors.black,
    timeInSecForIosWeb: 1,
  );
}