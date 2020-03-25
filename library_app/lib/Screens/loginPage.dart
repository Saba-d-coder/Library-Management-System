import 'package:flutter/material.dart';
import 'package:libraryapp/Screens/Profile.dart';
import 'package:libraryapp/Screens/listCard.dart';
import 'package:libraryapp/Services/inputFields.dart';
import 'package:libraryapp/Screens/registerPage.dart';
import 'package:libraryapp/Screens/homePage.dart';
import 'package:libraryapp/Services/Buttons.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
//        child: HomePage(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 45.0),
              InputField(placeholder: "ID"),
              SizedBox(height: 25.0),
              InputField(placeholder: "Password", boolValue: "hide"),
              SizedBox(height: 35.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Button(texts: "Login", screen: HomePage()),
                  Button(texts: "Register", screen: RegisterPage()),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
