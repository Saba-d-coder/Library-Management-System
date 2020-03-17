import 'package:flutter/material.dart';
import 'package:libraryapp/Screens/homePage.dart';
import 'package:libraryapp/Services/Buttons.dart';
import 'package:libraryapp/Services/profileDisplay.dart';

class ProfileDetails extends StatefulWidget {
  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  bool enableEdit = false;

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
        child: Column(
          children: <Widget>[
            ProfileText(
              label: 'Name',
              textController: new TextEditingController(text: 'KSK'),
              editMode: enableEdit,
            ),
            ProfileText(
              label: 'Email',
              textController: new TextEditingController(text: 'abc@mail.com'),
              editMode: enableEdit,
            ),
            ProfileText(
              label: 'USN',
              textController: new TextEditingController(text: '1MS17IS000'),
              editMode: enableEdit,
            ),
            ProfileText(
              label: 'Mobile Number',
              textController: new TextEditingController(text: '1234567890'),
              editMode: enableEdit,
            ),
            SizedBox(height: 30.0),
            Button(texts: "Submit", screen: HomePage())
          ],
        ),
      ),
    );
  }
}
