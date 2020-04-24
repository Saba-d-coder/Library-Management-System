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
  @override
  void initState() {
    _name = new TextEditingController();
    _uid = new TextEditingController();
    _emailID = new TextEditingController();
    _phoneNo = new TextEditingController();
    _password = new TextEditingController();
    _cmpPass = new TextEditingController();
    super.initState();
  }

  _registerUser(String userDetails) async {
    String url = 'http://'+ipAddress+':3000/users';
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post(url, headers: headers, body: userDetails);
    if(response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
      print("success");
    }
    else {
      _uid.clear();
      _name.clear();
      _emailID.clear();
      _phoneNo.clear();
      _password.clear();
      _cmpPass.clear();
      print("failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 50.0),
        child: Form(
          key: _registerFormKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /*InputField(fieldName: "name",placeholder: "Name"),
                SizedBox(height: 15.0),
                InputField(fieldName: "uid", placeholder: "ID"),
                SizedBox(height: 15.0),
                InputField(fieldName: "emailID",placeholder: "Email"),
                SizedBox(height: 15.0),
                InputField(fieldName: "phoneNo", placeholder: "Mobile Number"),
                SizedBox(height: 15.0),
                InputField(fieldName: "password", placeholder: "New Password", boolValue: "hide"),
                SizedBox(height: 15.0),
                InputField(fieldName:"cmpPass", placeholder: "Compare Password", boolValue: "hide"),*/
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
