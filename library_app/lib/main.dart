import 'package:flutter/material.dart';
import 'package:libraryapp/Screens/loginPage.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:libraryapp/constants/allConst.dart';
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
      title: 'pickabook',
      home: SplashScreenPage(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeManager.themeMode,
    );
  }
}

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => new _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  initState() {
    super.initState();
    getTheme();
  }
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 10,
      navigateAfterSeconds: new LoginPage(),
      image: Image.asset('asset/images/SplashScreenLogo.gif'),
      backgroundColor: kThemeText,
      photoSize: 70.0,
    );
  }
}