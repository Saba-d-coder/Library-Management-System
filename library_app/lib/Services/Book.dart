import 'dart:convert';

List<Book> modelBookFromJson(String str) => List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String modelBookToJson(List<Book> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Book {
  int id;
  String name, author, publisher, autocompleteTerm; //,review, image;

  /*Book(String n, String auth, String pub, String rev, String img) {
    name = n;
    author = auth;
    publisher = pub;
    review = rev;
    image = img;
  }*/
  Book({this.id, this.name, this.author, this.publisher, this.autocompleteTerm});
  factory Book.fromJson(Map<String, dynamic> json) => Book(
      id: json['bid'],
      name: json['bname'],
      author: json['author'],
      publisher: json['publisher'],
      autocompleteTerm: json['bname']+";"+json['author']+";"+json['publisher']
    );
  Map<String, dynamic> toJson() => {
    "id" : id,
    "name" : name,
    "author" : author,
    "publisher" : publisher,
    "autocompleteTerm" : autocompleteTerm
  };
}
