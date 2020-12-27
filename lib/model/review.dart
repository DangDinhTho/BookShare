import 'package:flutter/cupertino.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:share_books/model/comment.dart';

class Review {
  final String id;
  final String content;
  final List<String> likes;
  final List<Comment> comments;
  final List<String> imageURLs;
  final String timeUpload;
  final String owner;
  //final Image image;

  Review(
      {
      this.id,
        this.content,
        this.likes,
        this.comments,
        this.imageURLs,
        this.timeUpload,
        this.owner
        //this.image
      });

  factory Review.fromJson(Map<String, dynamic> json) {
    List<String> _imageURLs = [];
    List<Comment> _comments = [];
    List<String> _likes = [];

    for (String imageURL in json["imageURLs"]) {
      String path = "http://10.0.2.2:3000/" + imageURL.split('\\').last;
      _imageURLs.add(path);
    }

    for(Map<String, dynamic> cmt in json["comments"]){
      _comments.add(Comment.fromJson(cmt));
    }

    for(String like in json["likes"]){
      _likes.add(like);
    }
    //
     print(_likes);
 print(json["likes"]);
    return Review(
        id: json["_id"] as String,
        content: json["content"] as String,
        likes: _likes,
        comments: _comments,
        //price: "10000",
        imageURLs: _imageURLs,
        timeUpload: json["time_up_load"],
        owner: json["owner"]
      //image: Image.asset("assets/images/book_1.jpg")
      //image: Image.network(imageURLs[0], width: 200, height: 100, fit: BoxFit.fitWidth,)
    );
  }
}


