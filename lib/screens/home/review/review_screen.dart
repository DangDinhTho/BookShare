import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_books/model/review.dart';
import 'package:share_books/screens/home/review/post_review.dart';
import 'package:share_books/services/authservice.dart';
import 'package:share_books/services/review_service.dart';
import 'package:share_books/widgets/avatar.dart';
import 'package:share_books/widgets/post_container.dart';

class ReviewScreen extends StatefulWidget {

  final Future<List<Review>> futureReviews;

  const ReviewScreen({Key key, this.futureReviews}) : super(key:key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState(futureReviews: futureReviews);
}

class _ReviewScreenState extends State<ReviewScreen> {

  Future<List<Review>> futureReviews;
  _ReviewScreenState({Key key, this.futureReviews}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
        actions: [
          FlatButton(
            child: Icon(Icons.rate_review, color: Colors.white,),
            onPressed: (){
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => PostReview()
                  ));
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: futureReviews,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            //print(snapshot.data[1]);
            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text("Loading...", style: TextStyle(color: Colors.blue, fontSize: 20),),
                ),
              );
            }
            else {
              return RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                    itemCount: snapshot.data.length,

                    itemBuilder: (context, index) =>
                      PostContainer(review: snapshot.data[index])

                ),
              );
            }
          }

      ),
    );
  }

  Future<Null> refresh() async {
    Completer<Null> completer = new Completer();
    setState(() {
      futureReviews = ReviewService().getAllReview();
    });
    completer.complete();
    return completer.future;
  }
}
