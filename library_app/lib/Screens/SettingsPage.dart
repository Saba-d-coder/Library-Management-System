import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libraryapp/Services/ThemeManager.dart';
import 'package:libraryapp/constants/allConst.dart';
import 'package:libraryapp/Screens/homePage.dart';

class SettingsPage extends StatefulWidget {
  String uid;
  SettingsPage(uid) {
    this.uid = uid;
  }
  @override
  _SettingsPageState createState() => _SettingsPageState(uid);
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode _groupValue;
  ThemeManager _themeManager;
  String uid;

  _SettingsPageState(uid) {
    this.uid = uid;
  }
  @override
  void initState() {
    super.initState();
    _themeManager = Provider.of<ThemeManager>(context, listen: false);
    _groupValue = _themeManager.themeMode;
  }

  //to update theme of the app
  void _updateTheme(ThemeMode themeMode) {
    _themeManager.themeMode = themeMode;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return HomePage(uid);
    }), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: TextStyle(color: kThemeText),),
        backgroundColor: kThemeColor,
        iconTheme: new IconThemeData(color: kThemeText),
      ),
      backgroundColor: kThemeText,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 10.0),
            child: Text("Select App Theme", style: TextStyle(fontSize: 24.0),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio(
                onChanged: (val) => setState(() {
                  _groupValue = val;
                  _updateTheme(val);
                }),
                value: ThemeMode.light,
                groupValue: _groupValue,
              ),
              GestureDetector(
                onTap: () => setState(() {
                  var val = ThemeMode.light;
                  _groupValue = val;
                  _updateTheme(val);
                }),
                child: Text(
                  "Light",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio(
                onChanged: (val) => setState(() {
                  _groupValue = val;
                  _updateTheme(val);
                }),
                value: ThemeMode.dark,
                groupValue: _groupValue,
              ),
              GestureDetector(
                onTap: () => setState(() {
                  var val = ThemeMode.dark;
                  _groupValue = val;
                  _updateTheme(val);
                }),
                child: Text(
                  "Dark",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}