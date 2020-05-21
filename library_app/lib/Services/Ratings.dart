import 'dart:convert';

//json to list of objects
List<Ratings> modelRatingsFromJson(String str) => List<Ratings>.from(json.decode(str).map((x) => Ratings.fromJson(x)));

//list of objects to json
String modelRatingsToJson(List<Ratings> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

//to extract book ratings from json
class Ratings {
  int id;
  int rating;
  Ratings({this.id, this.rating});
  factory Ratings.fromJson(Map<String, dynamic> json) => Ratings(
    id: json['bid'],
    rating: json['rating']
  );
  Map<String, dynamic> toJson() => {
    "id" : id,
    "rating" : rating
  };
}
