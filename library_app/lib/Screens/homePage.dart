import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:libraryapp/Services/inputFields.dart';
import 'package:libraryapp/Services/bookDetails.dart';
import 'package:libraryapp/Screens/sideMenu.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:libraryapp/constants/allConst.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:libraryapp/Services/Book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  String uid;
  HomePage(uid) {
    this.uid = uid;
  }
  @override
  _HomePageState createState() => _HomePageState(uid);
}

class _HomePageState extends State<HomePage> {
//  BookDB bk = new BookDB();
  String barcodeText = "";
  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String transcription = '';
  int id;

  List<Book> bookDB = List();
  Map<String, dynamic> profile;
  var loading = false;

  GlobalKey<AutoCompleteTextFieldState<Book>> key = new GlobalKey();

  AutoCompleteTextField searchBar;

  TextEditingController controller = new TextEditingController();

  String uid;

  _HomePageState(uid) {
    this.uid = uid;
  }


  /*final searchBar = InputField(
    placeholder: "Search for books",
    icon: Padding(
      padding: const EdgeInsetsDirectional.only(end: 10.0),
      child: GestureDetector(
        onTap: () {
          print("Tapped");
        },
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.mic),
            ),
            IconButton(
                icon: Icon(Icons.search)
            ),
          ]
        )
      ),
    ),
  );*/

  @override
  void initState() {
    super.initState();
    _getProfile();
    _getAllBooks();
    activateSpeechRecognizer();
  }

  _getProfile() async {
    String url = 'http://'+ipAddress+':3000/users/'+uid;
    http.Response response = await http.get(url);
    print(response.body);
    profile = jsonDecode(response.body);
    print(profile['name']);
  }

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

  void requestPermission() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);
    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
    }
  }

  void activateSpeechRecognizer() {
    requestPermission();

    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  void start() => _speech
      .listen(locale: 'en_GB')
      .then((result) => print('Started listening => result $result'));

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speech.stop().then((result) {
    setState(() => _isListening = result);
  });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) =>
      setState(() => print("current locale: $locale"));

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) {
    setState(() {
      transcription = text;
      print("te"+text+" "+transcription);
      searchBar.textField.controller.text = transcription;
    });
  }

  void onRecognitionComplete() {
    setState(() {
      _isListening = false;
    });
    if(!_speechRecognitionAvailable) {
      cancel();
      stop();
    }
  }

  Widget _buildVoiceInput({VoidCallback onPressed}) =>
      new Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            icon: Icon(Icons.mic),
            onPressed: onPressed,
          )
      );

  _getAllBooks() async {
    setState(() {
      loading = true;
    });
    String url = 'http://'+ipAddress+':3000/books';
    http.Response response = await http.get(url);
    print(response.body);
    final data = jsonDecode(response.body);
    setState(() {
      for (Map i in data) {
        bookDB.add(Book.fromJson(i));
      }
      loading = false;
    });
    print(bookDB[1].publisher);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideMenu(profile),
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
            new Row(children: <Widget>[
              Expanded(
              child: new Column(children: <Widget>[
                searchBar = AutoCompleteTextField<Book>(
                  style: TextStyle(color: Colors.cyan),
                  decoration: new InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16.0, 11.0, 16.0, 11.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      filled: true,
                      hintText: 'Search',
                      hintStyle: kTextStyle()),
                  itemSubmitted: (item) {
                    setState(() {
                      searchBar.textField.controller.text = item.autocompleteTerm;
                      id = item.id;
                      print(id);
                    });
                  },
                  clearOnSubmit: false,
                  key: key,
                  suggestions: bookDB,
                  itemBuilder: (context, item) {
                    return Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              item.autocompleteTerm,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.0,
                              ),

                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemSorter: (a, b) {
                    return a.autocompleteTerm.compareTo(b.autocompleteTerm);
                  },
                  itemFilter: (item, query) {
                    return item.autocompleteTerm
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  }
              ),
              ],
              ),
              ),
              _buildVoiceInput(
                onPressed: _speechRecognitionAvailable && !_isListening
                    ? () => start()
                    : () => stop(),
              ),
            ]),
              SizedBox(
                height: 10.0,
              ),

              BookList(bookDB),
            ],
          ),
        ));
  }
}
