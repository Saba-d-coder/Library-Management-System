import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:libraryapp/Services/inputFields.dart';
import 'package:libraryapp/Services/bookDetails.dart';
import 'package:libraryapp/Screens/sideMenu.dart';
import 'package:libraryapp/constants/allConst.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:libraryapp/Services/Book.dart';
import 'package:libraryapp/Services/Ratings.dart';
import 'package:libraryapp/Screens/displayBkDetail.dart';
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
  List<Ratings> ratingDB = List();
  Map<String, dynamic> profile;
  Map<String, dynamic> book;
  var loading = false;

  GlobalKey<AutoCompleteTextFieldState<Book>> key = new GlobalKey();

  AutoCompleteTextField searchBar;

  TextEditingController controller = new TextEditingController();

  String uid;

  _HomePageState(uid) {
    this.uid = uid;
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
    _getAllBooks();
    _getRatings();
    activateSpeechRecognizer();
  }

  _getProfile() async {
    String url = 'http://'+ipAddress+':3000/users/'+uid;
    http.Response response = await http.get(url);
    print(response.body);
    profile = jsonDecode(response.body);
    print(profile['name']);
  }

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

  _getRatings() async {
    String url = 'http://'+ipAddress+':3000/ratings';
    http.Response response = await http.get(url);
    final data = jsonDecode(response.body);
    setState(() {
      for (Map i in data) {
        ratingDB.add(Ratings.fromJson(i));
      }
    });
    print(ratingDB[1].rating);
  }

  _getBookViaCode(code) async {
    String url = 'http://'+ipAddress+':3000/books/code/'+code;
    http.Response response = await http.get(url);
    print(response.body);
    book = jsonDecode(response.body);
    print(book['bname']);
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
    });
  }

  void onRecognitionComplete() {
    setState(() {
      _isListening = false;
	    print("text "+transcription);
      searchBar.textField.controller.text = transcription;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideMenu(profile: profile, bookDB: bookDB, ratingDB: ratingDB),
        appBar: AppBar(
          title: Text(
            'App',
            style: TextStyle(color: kThemeText),
          ),
          backgroundColor: kThemeColor,
          iconTheme: new IconThemeData(color: kThemeText),
          actions: <Widget>[
            new MaterialButton(
              onPressed: () async {
                var result = await scan();
                print(result);
                setState(() => this.barcodeText = result);
                if(this.barcodeText != null) {
                  String returnVal = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert(context);
                    },
                  );
                  if(returnVal == 'continue') {
                    _getBookViaCode(this.barcodeText);
                  }
                }
              },
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Detail(uid, 'asset/images/books/'+id.toString()+'.jpg', id, ratingDB[id-1].rating);
                        }));
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

              loading ? Center (child: CircularProgressIndicator()) : BookList(uid, bookDB, ratingDB),
            ],
          ),
        )
    );
  }
}
