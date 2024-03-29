import 'package:flutter/material.dart';
import 'package:libraryapp/Screens/loginPage.dart';
import 'package:libraryapp/constants/allConst.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController _name;
  TextEditingController _uid;
  TextEditingController _emailID;
  TextEditingController _phoneNo;
  TextEditingController _password;
  TextEditingController _cmpPass;
  bool visible = false;
  String text = '';

  @override
  void initState() {
    getTheme();
    _name = new TextEditingController();
    _uid = new TextEditingController();
    _emailID = new TextEditingController();
    _phoneNo = new TextEditingController();
    _password = new TextEditingController();
    _cmpPass = new TextEditingController();
    super.initState();
  }

  //to check if entered uid already exists
  Future<bool> _checkIfExists(uid) async {
    print(uid);
    String url = 'http://'+ipAddress+':3000/users/'+uid;
    http.Response response = await http.get(url);
    if(response.statusCode == 200) {
      print('res '+response.body);
      if(response.body.contains(uid)) {
        print('true');
        return true;
      }
    }
    return false;
  }

  //to register a new user by taking in required details
  _registerUser(String userDetails) async {
    bool check = await _checkIfExists(_uid.text.toUpperCase());
    if(!check) {
      String url = 'http://' + ipAddress + ':3000/users';
      Map<String, String> headers = {"Content-type": "application/json"};
      http.Response response = await http.post(
          url, headers: headers, body: userDetails);
      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LoginPage();
        }));
        print("success");
      }
    }
    else {
      _uid.clear();
      _name.clear();
      _emailID.clear();
      _phoneNo.clear();
      _password.clear();
      _cmpPass.clear();
      print("failed");
      setState(() {
        visible = true;
        text = 'User ID already exists';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kThemeColor,
        iconTheme: new IconThemeData(color: kThemeText),
      ),
      backgroundColor: kThemeText,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 50.0),
        child: Form(
          key: _registerFormKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Visibility( // displayed if the user does not enter valid details
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 12, color: Colors.red),
                    textAlign: TextAlign.left,
                  ),
                  visible: visible,
                ),
                SizedBox(height: 7.0),
                TextFormField(
                  decoration: kInputDecor('UID*', "1MS11AB000"),
                  style: kTextStyle(),
                  controller: _uid,
                  // ignore: missing_return
                  validator: uidValidator,
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  decoration: kInputDecor('Name*', "John"),
                  style: kTextStyle(),
                  controller: _name,
                  // ignore: missing_return
                  validator: (value) {
                    if (value.length < 3) {
                      return "Please enter a valid first name.";
                    }
                  },
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  decoration: kInputDecor('Email*', "john.doe@gmail.com"),
                  style: kTextStyle(),
                  controller: _emailID,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  decoration: kInputDecor('Mobile Number*', "Mobile Number"),
                  style: kTextStyle(),
                  controller: _phoneNo,
                  keyboardType: TextInputType.phone,
                  // ignore: missing_return
                  validator: (value) {
                    if(value.length != 10) {
                      return "Please enter valid mobile number";
                    }
                  },
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  decoration: kInputDecor('Password*', "********"),
                  style: kTextStyle(),
                  controller: _password,
                  obscureText: true,
                  validator: pwdValidator,
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  decoration: kInputDecor('Confirm Password*', "********"),
                  style: kTextStyle(),
                  controller: _cmpPass,
                  obscureText: true,
                  validator: pwdValidator,
                ),
                SizedBox(height: 25.0),
                RaisedButton(
                  child: Text("Register"),
                    shape: kShape(),
                    color: kThemeColor,
                    textColor: kThemeText,
                  onPressed: () {
                    if(_registerFormKey.currentState.validate()) {
                      if (_password.text == _cmpPass.text) {
                        String userDetails = '{"uid":"'+_uid.text.toUpperCase()+'","name":"'+_name.text.toUpperCase()+'","emailID":"'+_emailID.text+'","phoneNo":"'+_phoneNo.text+'","password":"'+_password.text+'","noOfBooks":0}';
                        _registerUser(userDetails);
                      } else {
                        _password.clear();
                        _cmpPass.clear();
                        print("failed");
                        setState(() {
                          visible = true;
                          text = 'Passwords do not match';
                        });
                      }
                    }
                  }
                )
            ],
          ),
        ),
      ),
    );
  }
}
