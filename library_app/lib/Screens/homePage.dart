import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:libraryapp/Services/inputFields.dart';
import 'package:libraryapp/Services/bookDetails.dart';
import 'package:libraryapp/Screens/sideMenu.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:libraryapp/constants/allConst.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//  BookDB bk = new BookDB();
  String barcodeText = "";

  final searchBar = InputField(
    placeholder: "Search for books",
    icon: Padding(
      padding: const EdgeInsetsDirectional.only(end: 10.0),
      child: GestureDetector(
        onTap: () {
          print("Tapped");
        },
        child: Icon(Icons.search),
      ),
    ),
  );

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcodeText = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcodeText = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcodeText = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcodeText =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcodeText = 'Unknown error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideMenu(),
        appBar: AppBar(
          title: Text(
            'App',
            style: TextStyle(color: kThemeText),
          ),
          backgroundColor: kThemeColor,
          iconTheme: new IconThemeData(color: kThemeText),
          actions: <Widget>[
            new MaterialButton(
              onPressed: scan,
              child: Icon(
                const IconData(0xe900, fontFamily: 'ic_scanner'),
                color: kThemeText,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              searchBar,
              SizedBox(
                height: 10.0,
              ),
              BookList()
            ],
          ),
        ));
  }
}
