import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
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
import 'package:intl/intl.dart';
import 'package:libraryapp/Screens/RatingPage.dart';
import 'package:libraryapp/Services/sendMail.dart';

class HomePage extends StatefulWidget {
  String uid;
  HomePage(uid) {
    this.uid = uid;
  }
  @override
  _HomePageState createState() => _HomePageState(uid);
}

class _HomePageState extends State<HomePage> {
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
  Map<String, dynamic> issued;
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
    getTheme();
    _getProfile();
    _getAllBooks();
    _getRatings();
    activateSpeechRecognizer();
  }

  //to get user profile
  Future _getProfile() async {
    String url = 'http://'+ipAddress+':3000/users/'+uid;
    http.Response response = await http.get(url);
    print(response.body);
    profile = jsonDecode(response.body);
    print(profile['name']);
    return profile;
  }

  //to get all the books present in the db
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

  //to get the avg ratings of the books present in the db
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

  //to get the book based on the scanned barcode
  Future _getBookViaCode(code) async {
    String url = 'http://'+ipAddress+':3000/books/code/'+code;
    http.Response response = await http.get(url);
    print(response.body);
    book = jsonDecode(response.body);
    print(book['bname']);
    if(book.isEmpty) { //display msg if not scanned properly
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return message(context, 'Oops! Something went wrong, please scan the again');
        },
      );
    }
    return book['noOfBooks'];
  }

  //to update the no. of books taken by the user
  _updateNoOfBooksUser() async {
    int noOfBooks = profile['noOfBooks'] + 1;
    print(noOfBooks);
    String url = 'http://'+ipAddress+':3000/users/'+uid+'/noOfBooks/'+noOfBooks.toString();
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.put(url, headers: headers, body: null);
    if(response.statusCode == 200) {
      print("success");
    }
  }

  //to update the no. of copies available of the issued or renewed book
  _updateAvailable(bid) async {
    int available = book['noOfBooks'] - 1;
    print(available);
    String url = 'http://'+ipAddress+':3000/books/'+bid.toString()+'/noOfBooks/'+available.toString();
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.put(url, headers: headers, body: null);
    if(response.statusCode == 200) {
      print("success");
    }
  }

  //to check if the book was previously taken by the user
  Future _getIfIssued(bid) async {
    String url = 'http://'+ipAddress+':3000/issuedto/uid/'+uid+'/bid/'+bid.toString();
    http.Response response = await http.get(url);
    print(response.body);
    issued = jsonDecode(response.body);
    if(issued == null) {
      print('empty');
    }
    else {
      print(issued['bid']);
    }
    return issued;
  }

  //to add the issued book details to the db if the book is being taken for the first time
  _addIssuance(context, issuance, bid) async {
    String msg;
    print(issuance);
    String url = 'http://'+ipAddress+':3000/issuedto';
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post(url, headers: headers, body: issuance);
    if(response.statusCode == 200) {
      print("success");
      _updateNoOfBooksUser();
      _updateAvailable(bid);
      msg = 'Book has been issued successfully';
      Map<String, dynamic> issuedDetails = jsonDecode(issuance);
      String bodyText = msg + "\nUSN: " + issuedDetails['uid'] +"\nBook title: "+ book['bname'] + "\nIssued Date: "+ issuedDetails['issuedDate']+"\nDue Date: "+issuedDetails['dueDate'];
      sendMail(profile['emailID'], bodyText); //to send an email notification on successful transaction
    }
    else {
      print("Error");
      msg = 'Oops! An error has occurred';
    }
    showDialog( //to show a message alert dialog
      context: context,
      builder: (BuildContext context) {
        return message(context, msg);
      },
    );
  }

  //to update the transaction details
  _updateIssuance(context, issuance, bid) async {
    String msg;
    print(issuance);
    String url = 'http://'+ipAddress+':3000/issuedto/uid/'+uid+'/bid/'+bid.toString();
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.put(url, headers: headers, body: issuance);
    if(response.statusCode == 200) {
      print("success");
      msg = 'Book has been renewed successfully';
      Map<String, dynamic> issuedDetails = jsonDecode(issuance);
      String bodyText = msg + "\nUSN: " + issuedDetails['uid'] +"\nBook title: "+ book['bname'] + "\nIssued Date: "+ issuedDetails['issuedDate']+"\nDue Date: "+issuedDetails['dueDate'];
      sendMail(profile['emailID'], bodyText); //to send an email notification on successful transaction
    }
    else {
      print("Error");
      msg = 'Oops! An error has occurred';
    }
    showDialog( //to show a message alert dialog
      context: context,
      builder: (BuildContext context) {
        return message(context, msg);
      },
    );
    if(msg.contains('renewed')) { //to take the user review and rating of the book if it is being renewed
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return RatingPage(uid, 'asset/images/books/'+bid.toString()+'.jpg', bid, book['bname'], book['author']);
      }));
    }
  }

  //the next set of functions are written to handle speech recognition

  //to request the user to allow the app to use microphone
  void requestPermission() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);
    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
    }
  }

  //to handle speech recognition process
  void activateSpeechRecognizer() {
    requestPermission();

    _speech = new SpeechRecognition(); //create an object of speech recognition class(library)
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  //to start listening
  void start() => _speech
      .listen(locale: 'en_GB')
      .then((result) => print('Started listening => result $result'));

  //to cancel the listening process
  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  //to stop listening
  void stop() => _speech.stop().then((result) {
    setState(() => _isListening = result);
  });

  //to check if speech is available
  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  //to handle device current locale detection
  void onCurrentLocale(String locale) =>
      setState(() => print("current locale: $locale"));

  //when it starts recognizing
  void onRecognitionStarted() => setState(() => _isListening = true);

  //when it is in the process of recognition
  void onRecognitionResult(String text) {
    setState(() {
      transcription = text;
    });
  }

  //when the recognition is complete
  void onRecognitionComplete() {
    setState(() {
      _isListening = false;
	    print("text "+transcription);
      searchBar.textField.controller.text = transcription; //set the text field(search bar) with the recognized text
    });
    if(!_speechRecognitionAvailable) { //when no more speech is available, cancel and stop speech recognition
      cancel();
      stop();
    }
  }

  //to enable speech recognition on pressing the mic icon
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
        backgroundColor: kThemeText,
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
                var result = await scan(); //call barcode scanner
                print(result);
                setState(() => this.barcodeText = result); //scanned code
                if(this.barcodeText != null) { //to confirm the user's scan action
                  String returnVal = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert(context);
                    },
                  );
                  if(returnVal == 'continue') { //on confirmation to proceed
                    int nbooks = await _getBookViaCode(this.barcodeText); //to get the no. of copies of the scanned code available
                    print(nbooks);
                    Map<String, dynamic> profile = await _getProfile(); //to get user's profile
                    String msg;
                    if(nbooks > 0) { //if the scanned book is available
                      print('true');
                      Map<String, dynamic> issuedbk = await _getIfIssued(book['bid']); //to check if the user had previously taken this book
                      print(issuedbk);
                      var currDt = DateTime.now(); //to get current date
                      var formatter = DateFormat("yyyy-MM-dd"); //format it
                      String issuedDate = formatter.format(currDt); //formatted date
                      print(issuedDate);
                      String dueDate = formatter.format(currDt.add(Duration(days: 15))); //calculate due date
                      print(dueDate);

                      if(issuedbk.isEmpty && profile['noOfBooks'] < 3) { //if the scanned book wasn't taken by the user and the user is allowed to take this book currently
                        String issuance = '{"uid":"'+uid+'","bid":'+book['bid'].toString()+',"issuedDate":"'+issuedDate+'","dueDate":"'+dueDate+'","status":"issued","fine":0,"noOfRenews":0,"totNoOfTimes":1,"rating":0,"reviews":null}';
                        _addIssuance(context, issuance, book['bid']); //add transaction to db
                      }
                      else if(issuedbk.isNotEmpty && profile['noOfBooks'] < 3) { //if it was taken by the user previously and the user is allowed to take this book currently
                        if(issuedbk['status'] != 'returned' && issuedbk['noOfRenews'] < 2) { //if it has been issued or renewed previously
                          int fine = currDt.difference(DateTime.parse(issuedbk['dueDate'])).inDays; //calculate fine if any
                          print(fine);
                          if(fine < 0) {
                            fine = 0;
                            fine += issuedbk['fine']; //calculate the cumulative fine if any
                          }
                          String issuance = '{"uid":"' + uid + '","bid":' +
                              book['bid'].toString() + ',"issuedDate":"' + issuedDate +
                              '","dueDate":"' + dueDate + '","status":"renewed","fine":'+fine.toString()+',"noOfRenews":'+(issuedbk['noOfRenews']+1).toString()+',"totNoOfTimes":'+(issuedbk['totNoOfTimes']+1).toString()+'}';
                          _updateIssuance(context, issuance, book['bid']); //update the transaction details
                        }
                        else if(issuedbk['status'] == 'returned') {  //if it was returned previously
                          String issuance = '{"uid":"' + uid + '","bid":' +
                              book['bid'].toString() + ',"issuedDate":"' + issuedDate +
                              '","dueDate":"' + dueDate + '","status":"issued","fine":0,"noOfRenews":0,"totNoOfTimes":'+(issuedbk['totNoOfTimes']+1).toString()+'}';
                          _updateIssuance(context, issuance, book['bid']); //update the transaction details
                        }
                        else if(issuedbk['noOfRenews'] == 2) { //if it was already renewed twice
                          msg = 'Can not renew more than 2 times. Please return the book';
                        }
                      }
                      else if(profile['noOfBooks'] == 3){ //if the user has already taken 3 books
                        if(issuedbk.isNotEmpty) { //check if the book was previously taken
                          if (issuedbk['status'] != 'returned' && issuedbk['noOfRenews'] < 2) { //if it was issued or renewed but not reached the max limit
                            int fine = currDt.difference(DateTime.parse(issuedbk['dueDate'])).inDays; //calculate fine
                            print(fine);
                            if(fine < 0) {
                              fine = 0;
                              fine += issuedbk['fine']; //calculate cumulative fine
                            }
                            String issuance = '{"uid":"' + uid + '","bid":' + book['bid'].toString() + ',"issuedDate":"' + issuedDate + '","dueDate":"' + dueDate + '","status":"renewed","fine":' + fine.toString() + ',"noOfRenews":' + (issuedbk['noOfRenews'] + 1).toString() + ',"totNoOfTimes":' + (issuedbk['totNoOfTimes'] + 1).toString() + '}';
                            _updateIssuance(context, issuance, book['bid']); //update transaction details
                          }
                        }
                        else { //if the user has taken 3 books and this book is not one among them
                          msg = 'Max limit of books that can be taken has reached';
                        }
                      }
                      else { //if there are no copies of this book is available
                        msg = 'This book is unavailable';
                      }
                    }
                    else { //if there are no copies of this book available but the user has already taken a copy of tis book
                      Map<String, dynamic> issuedbk = await _getIfIssued(book['bid']);
                      if(issuedbk.isNotEmpty && (issuedbk['status'] != 'returned' && issuedbk['noOfRenews'] < 2)) { //max no. of renews has not reached
                        var currDt = DateTime.now();
                        var formatter = DateFormat("yyyy-MM-dd");
                        String issuedDate = formatter.format(currDt);
                        print(issuedDate);
                        String dueDate = formatter.format(currDt.add(Duration(days: 15)));
                        print(dueDate);
                        int fine = currDt.difference(DateTime.parse(issuedbk['dueDate'])).inDays;
                        print(fine);
                        if(fine < 0) {
                          fine = 0;
                          fine += issuedbk['fine'];
                        }
                        String issuance = '{"uid":"' + uid + '","bid":' +
                            book['bid'].toString() + ',"issuedDate":"' + issuedDate +
                            '","dueDate":"' + dueDate + '","status":"renewed","fine":'+fine.toString()+',"noOfRenews":'+(issuedbk['noOfRenews']+1).toString()+',"totNoOfTimes":'+(issuedbk['totNoOfTimes']+1).toString()+'}';
                        _updateIssuance(context, issuance, book['bid']);
                      }
                      else { //if max no. of renews has reached
                        msg = 'This book is unavailable';
                      }
                    }
                    if(msg != '' && msg != null) { //display message if any in an alert dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return message(context, msg);
                        },
                      );
                    }
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
                  searchBar = AutoCompleteTextField<Book>( //search bar
                    style: kTextStyle(),
                    decoration: new InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(16.0, 11.0, 16.0, 11.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        filled: true,
                        hintText: 'Search',
                        hintStyle: kTextStyle(),
                        suffixIcon: IconButton( //to clear the search bar in one click
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchBar.textField.controller.clear();
                            }),
                    ),
                    itemSubmitted: (item) {
                      setState(() {
                        searchBar.textField.controller.text = item.autocompleteTerm; //on selecting set the search bar with the autocomplete text
                        id = item.id; //get the book id of the selected book
                        print(id);
                        Navigator.push(context, MaterialPageRoute(builder: (context) { //to display selected book details
                          return Detail(uid, 'asset/images/books/'+id.toString()+'.jpg', id, ratingDB[id-1].rating);
                        }));
                      });
                    },
                    clearOnSubmit: false,
                    key: key,
                    suggestions: bookDB,
                    itemBuilder: (context, item) { //to show autocomplete text suggestions based on book db
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
                    itemSorter: (a, b) { //sorting autocomplete suggestions in alphabetical order
                      return a.autocompleteTerm.compareTo(b.autocompleteTerm);
                    },
                    itemFilter: (item, query) { //suggestion is based on the autocomplete text cntents
                      return item.autocompleteTerm
                          .toLowerCase()
                          .contains(query.toLowerCase());
                    }
                  ),
                ],
              ),
              ),
              _buildVoiceInput( //start or stop speech recognition
                onPressed: _speechRecognitionAvailable && !_isListening
                    ? () => start()
                    : () => stop(),
              ),
            ]),
              SizedBox(
                height: 10.0,
              ),

              loading ? Center (child: CircularProgressIndicator()) : BookList(uid, bookDB, ratingDB), //to display books in grid format
            ],
          ),
        )
    );
  }
}
