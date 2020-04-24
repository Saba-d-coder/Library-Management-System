import 'package:flutter/material.dart';
import 'package:libraryapp/Screens/Profile.dart';
import 'package:libraryapp/Screens/listCard.dart';
import 'package:libraryapp/Services/inputFields.dart';
import 'package:libraryapp/Screens/registerPage.dart';
import 'package:libraryapp/Screens/homePage.dart';
import 'package:libraryapp/Services/Buttons.dart';
import 'package:libraryapp/constants/allConst.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController _uid;
  TextEditingController _password;
  initState() {
    _uid = new TextEditingController();
    _password = new TextEditingController();
    super.initState();
  }

  _checkUser(String uid, String password) async {
    String url = 'http://'+ipAddress+':3000/users/'+uid;
    http.Response response = await http.get(url);
    if(response.statusCode == 200) {
      print(response.body);
      if(response.body.contains(password)) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage(uid);
        }));
        print('found');
      }
      else {
        _uid.clear();
        _password.clear();
        print('invalid credentials');
      }
    }
    else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
//        child: HomePage(),
        child: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 45.0),
                //InputField(placeholder: "UID"),
                TextFormField(
                  decoration: kInputDecor('UID*',"1MS11AB000"),
                  style: kTextStyle(),
                  controller: _uid,
                  // ignore: missing_return
                  validator: uidValidator,
                ),
                SizedBox(height: 25.0),
                //InputField(placeholder: "Password", boolValue: "hide"),
                TextFormField(
                  decoration: kInputDecor('Password*', "********"),
                  style: kTextStyle(),
                  controller: _password,
                  obscureText: true,
                  validator: pwdValidator,
                ),
                SizedBox(height: 35.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                        child: Text("Login"),
                        shape: kShape(),
                        color: kThemeColor,
                        textColor: kThemeText,
                        onPressed: () {
                          if(_loginFormKey.currentState.validate()) {
                            String uid = _uid.text.toUpperCase();
                            String password = _password.text;
                            print(uid+" "+ password);
                            _checkUser(uid, password);
                          }
                        }
                    ),
                    RaisedButton(
                        child: Text("Register"),
                        shape: kShape(),
                        color: kThemeColor,
                        textColor: kThemeText,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return RegisterPage();
                        }));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
