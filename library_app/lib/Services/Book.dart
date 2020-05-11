import 'dart:convert';

List<Book> modelBookFromJson(String str) => List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String modelBookToJson(List<Book> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Book {
  int id, noOfBooks;
  String name, author, publisher, autocompleteTerm, status, description, subject, shelfNo;
  Book({this.id, this.name, this.author, this.publisher, this.autocompleteTerm, this.subject, this.noOfBooks, this.status, this.shelfNo, this.description});
  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json['bid'],
    name: json['bname'],
    author: json['author'],
    publisher: json['publisher'],
    autocompleteTerm: json['bname']+";"+json['author']+";"+json['publisher'],
    subject: json['subject'],
    noOfBooks: json['noOfBooks'],
    status: json['status'],
    shelfNo: json['shelfNo'],
    description: json['description']
  );
  Map<String, dynamic> toJson() => {
    "id" : id,
    "name" : name,
    "author" : author,
    "publisher" : publisher,
    "autocompleteTerm" : autocompleteTerm,
    "noOfBooks" : noOfBooks,
    "status" : status,
    "shelfNo" : shelfNo,
    "decription" : description
  };
}
