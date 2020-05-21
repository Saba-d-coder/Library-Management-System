import 'dart:convert';

//json to list of objects
List<Issued> modelIssuedFromJson(String str) => List<Issued>.from(json.decode(str).map((x) => Issued.fromJson(x)));

//list of objects to json
String modelIssuedToJson(List<Issued> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//to extract transaction(issue, renew etc) details from json
class Issued {
  int id, noOfBooks, noOfRenews, totNoOfTimes, fine;
  String uid, issuedDate, dueDate, status;
  Issued({this.uid, this.id, this.issuedDate, this.dueDate, this.fine, this.status, this.noOfRenews, this.totNoOfTimes});
  factory Issued.fromJson(Map<String, dynamic> json) => Issued(
      uid: json['uid'],
      id: json['bid'],
      issuedDate: json['issuedDate'],
      dueDate: json['dueDate'],
      fine: json['fine'],
      status: json['status'],
      noOfRenews: json['noOfRenews'],
      totNoOfTimes: json['totNoOfTimes'],
  );
  Map<String, dynamic> toJson() => {
    "uid" : uid,
    "id" : id,
    "issuedDate" : issuedDate,
    "dueDate" : dueDate,
    "fine" : fine,
    "status" : status,
    "noOfRenews" : noOfRenews,
    "totNoOfTimes" : totNoOfTimes
  };
}
