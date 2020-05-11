import 'package:flutter/material.dart';
import 'package:libraryapp/Screens/homePage.dart';
import 'package:libraryapp/constants/allConst.dart';
import 'package:http/http.dart' as http;

class ProfileDetails extends StatefulWidget {
  Map<String, dynamic> profile;
  ProfileDetails(profile) {
    this.profile = profile;
  }

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState(profile);
}

class _ProfileDetailsState extends State<ProfileDetails> {
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  TextEditingController _uid;
  TextEditingController _name;
  TextEditingController _emailID;
  TextEditingController _phoneNo;
  TextEditingController _password;
  @override
  void initState() {
    _uid = new TextEditingController();
    _name = new TextEditingController();
    _emailID = new TextEditingController();
    _phoneNo = new TextEditingController();
    _password = new TextEditingController();
    _uid.text = profile['uid'];
    _name.text = profile['name'];
    _emailID.text = profile['emailID'];
    _phoneNo.text = profile['phoneNo'];
    _password.text = profile['password'];
    super.initState();
  }

  bool enableEdit = false;
  Map<String, dynamic> profile;
  _ProfileDetailsState(profile) {
    this.profile = profile;
  }

  _updateProfile(updatedProfile) async {
    String url = 'http://'+ipAddress+':3000/users/'+profile['uid'];
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.put(url, headers: headers, body: updatedProfile);
    if(response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomePage(profile['uid']);
      }));
      print("success");
    }
    else {
      _name.clear();
      _emailID.clear();
      _phoneNo.clear();
      _password.clear();
      print("failed");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                enableEdit = true;
              });
            },
          ),
        ],
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 50.0),
        child: Form(
          key: _profileFormKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 15.0),
              TextFormField(
                controller: _uid,
                enabled: false,
                decoration: kInputDecorProfile('UID'),
                validator: emailValidator,
              ),
              SizedBox(height: 15.0),
              SizedBox(height: 15.0),
              TextFormField(
                decoration: kInputDecorProfile('Name'),
                controller: _name,
                enabled: enableEdit,
                // ignore: missing_return
                validator: (value) {
                  if (value.length < 3) {
                    return "Please enter a valid first name.";
                  }
                }
              ),
              SizedBox(height: 15.0),
              TextFormField(
                controller: _emailID,
                enabled: enableEdit,
                decoration: kInputDecorProfile('EmailID'),
                validator: emailValidator,
              ),
              SizedBox(height: 15.0),
              TextFormField(
                controller: _phoneNo,
                enabled: enableEdit,
                decoration: kInputDecorProfile('Phone No'),
                // ignore: missing_return
                validator: (value) {
                  if(value.length != 10) {
                    return "Please enter valid mobile number";
                  }
                },
              ),
              SizedBox(height: 15.0),
              TextFormField(
                controller: _password,
                enabled: enableEdit,
                obscureText: enableEdit ? false : true,
                decoration: kInputDecorProfile('Password'),
                validator: pwdValidator,
              ),
              SizedBox(height: 30.0),
              RaisedButton(
                child: Text("Submit"),
                shape: kShape(),
                color: kThemeColor,
                textColor: kThemeText,
                onPressed: () {
                  String updatedProfile = '{"name":"'+_name.text.toUpperCase()+'","emailID":"'+_emailID.text+'","phoneNo":"'+_phoneNo.text+'","password":"'+_password.text+'"}';
                  _updateProfile(updatedProfile);
                },
              ),
            ],/*Button(texts: "Submit", screen: HomePage(profile['uid']))*/
          ),
        ),
      ),
    );
  }
}
