import 'package:flutter/material.dart';
import 'package:share_books/widgets/avatar.dart';
import 'package:share_books/widgets/post_container.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reviews"),
      ),
      body: ListView(
        children: [

          Card(
            elevation: 0,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Avatar(),
                      SizedBox(width: 10,),
                      Text("Your Review")
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          ),

          PostContainer(),
          PostContainer(),
          PostContainer()
        ],
      ),
    );
  }
}
