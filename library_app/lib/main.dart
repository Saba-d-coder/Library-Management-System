import 'package:flutter/material.dart';
import 'package:libraryapp/Screens/loginPage.dart';
import 'package:libraryapp/constants/allConst.dart';
import 'package:provider/provider.dart';
import 'package:libraryapp/Services/ThemeManager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeManager>(
      create: (context) => ThemeManager(),
      child: MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return MaterialApp(
      title: 'Library App',
      home: LoginPage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeManager.themeMode,
    );
  }
}