import 'package:flutter/material.dart';
import 'package:libraryapp/Services/inputFields.dart';
import 'package:libraryapp/Services/Buttons.dart';
import 'package:libraryapp/Screens/loginPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InputField(placeholder: "Name"),
            SizedBox(height: 15.0),
            InputField(placeholder: "ID"),
            SizedBox(height: 15.0),
            InputField(placeholder: "Email"),
            SizedBox(height: 15.0),
            InputField(placeholder: "Mobile Number"),
            SizedBox(height: 15.0),
            InputField(placeholder: "New Password", boolValue: "hide"),
            SizedBox(height: 15.0),
            InputField(placeholder: "Compare Password", boolValue: "hide"),
            SizedBox(height: 25.0),
            Button(texts: 'Submit', screen: LoginPage())
          ],
        ),
      ),
    );
  }
}
