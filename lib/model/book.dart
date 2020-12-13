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
  final DateTime timeUpload;
  final double score;
  final List<String> imageURLs;
  final List<String> imageNames;
  final String owner;
  final String address;
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
        this.address
      //this.image
      });

  factory Book.fromJson(Map<String, dynamic> json) {
    List<String> _imageURLs = [];
    for (String imageURL in json["imageURLs"]) {
      String path = "http://10.0.2.2:3000/uploads/" + imageURL.split('\\').last;
      _imageURLs.add(path);
    }
    List<String> times = json["time_up_load"].toString().split('T')[0].split('-');
    //DateTime _timeUpload = new DateTime(int.parse(times[0]), int.parse(times[1]), int.parse(times[2]));
    DateTime _timeUpload = DateTime.parse(json["time_up_load"].toString());

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
        score: json["score"].toDouble(),
        timeUpload: _timeUpload,
        address: json["address"] as String
        //image: Image.asset("assets/images/book_1.jpg")
      //image: Image.network(imageURLs[0], width: 200, height: 100, fit: BoxFit.fitWidth,)
        );
  }

}

