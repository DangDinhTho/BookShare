import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class Book {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final String author;
  final String publisher;
  final String year;
  final String category;
  final String timeUpload;
  final double score;
  final List<String> imageURLs;
  final List<String> imageNames;
  final String owner;
  final String address;
  final bool active;
  //final Image image;

  Book(
      {this.id,
      this.title,
      this.subtitle,
      this.price,
      this.owner,
      this.publisher,
      this.year,
      this.category,
      this.author,
      this.imageURLs,
      this.imageNames,
        this.timeUpload,
        this.score,
        this.address,
        this.active
      //this.image
      });

  factory Book.fromJson(Map<String, dynamic> json) {
    List<String> _imageURLs = [];
    for (String imageURL in json["imageURLs"]) {
      String path = "http://10.0.2.2:3000/" + imageURL.split('\\').last;
      _imageURLs.add(path);
    }
    List<String> times = json["time_up_load"].toString().split('T')[0].split('-');
    int _score = json["score"].toInt();
    String dateString = json["time_up_load"].toString();
    DateTime notificationDate = DateTime.parse(dateString);
    //DateFormat("dd-MM-yyyy h:mma").parse("09-10-2020 08:29AM");
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);
    _score = _score - difference.inDays < 0 ? 0 : _score - difference.inDays;
    print(" he $_score");
    return Book(
        id: json["_id"] as String,
        title: json["title"] as String,
        subtitle: json["subtitle"] as String,
        price: json["price"].toString(),
        //price: "10000",
        author: json["author"] as String,
        publisher: json["publisher"] as String,
        year: json["year"] as String,
        category: json["category"] as String,
        owner: json["owner"] as String,
        imageURLs: _imageURLs,
        score: _score.toDouble(),
        timeUpload: json["time_up_load"].toString(),
        address: json["address"] as String,
        active: json["active"] as bool
        //image: Image.asset("assets/images/book_1.jpg")
      //image: Image.network(imageURLs[0], width: 200, height: 100, fit: BoxFit.fitWidth,)
        );
  }

}

