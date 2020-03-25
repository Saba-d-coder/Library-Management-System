import 'package:flutter/material.dart';
import 'package:libraryapp/Screens/loginPage.dart';
import 'package:libraryapp/constants/allConst.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: kThemeText,
      ),
      home: LoginPage(),
    );
  }
}
