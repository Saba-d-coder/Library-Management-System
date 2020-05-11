import 'dart:convert';

List<Reviews> modelReviewsFromJson(String str) => List<Reviews>.from(json.decode(str).map((x) => Reviews.fromJson(x)));

String modelReviewsToJson(List<Reviews> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Reviews {
  String name ,review;
  int rating;
  Reviews({this.name, this.rating, this.review});
  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
    name: json['name'],
    rating: json['rating'],
    review: json['reviews']
  );
  Map<String, dynamic> toJson() => {
    "name" : name,
    "rating" : rating,
    "review" : review
  };
}
