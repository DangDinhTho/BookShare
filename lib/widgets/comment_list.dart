//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:share_books/model/comment.dart';
import 'package:share_books/model/current_user.dart';
import 'package:share_books/model/review.dart';
import 'package:share_books/model/user.dart';
import 'package:share_books/services/review_service.dart';
import 'package:share_books/widgets/post_container.dart';

import 'comment_item.dart';

class CommentList extends StatefulWidget {
  final PostContainer postContainer;
  final Review review;
  const CommentList({Key key, @required this.postContainer, @required this.review}) : super(key: key);

  @override
  _CommentListState createState() => _CommentListState(postContainer: postContainer);
}

class _CommentListState extends State<CommentList> {
  TextEditingController commentContent = new TextEditingController();
  bool _invalid = false;
  PostContainer postContainer;
  _CommentListState({Key key, this.postContainer}) : super();

  List<CommentItem> comments = new List();




  @override
  Widget build(BuildContext context) {
    // return Card(
    //   margin: EdgeInsets.only(top: 200),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular((10)),
    //         topRight: Radius.circular(10)
    //     ),),
    //   child: Column(
    //     children: [
    //       Divider(
    //         color: Colors.grey,
    //       ),
    //       Container(
    //         height: 20,
    //         margin: EdgeInsets.only(top: 0),
    //         alignment: Alignment.centerLeft,
    //         child: FlatButton(
    //           //padding: EdgeInsets.only(top: 0),
    //           child: Text("Comments", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
    //         ),
    //       ),
    //       Expanded(
    //         child: ListView(
    //           padding: EdgeInsets.only(top: 0),
    //           children: [
    //             CommentItem(
    //               comment: new Comment(
    //                   user: new User(
    //                       name: 'Hello',
    //                       imageUrl:
    //                       'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80'),
    //                   content: 'Hay vcl',
    //                   time: '5 min ago'),
    //             ),
    //             CommentItem(
    //               comment: new Comment(
    //                   user: new User(
    //                       name: 'Hello',
    //                       imageUrl:
    //                       'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80'),
    //                   content:
    //                   'Cat dau moi a, viet cho dai ra thoi, xuong dong ho bo cai',
    //                   time: '15 min ago'),
    //             ),
    //             CommentItem(
    //               comment: new Comment(
    //                   user: new User(
    //                       name: 'Hello',
    //                       imageUrl:
    //                       'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80'),
    //                   content:
    //                   'I like that, I very like that, like that very much, vcl van chua xuong dong a',
    //                   time: '1 hour ago'),
    //             ),
    //
    //             CommentItem(
    //               comment: new Comment(
    //                   user: new User(
    //                       name: 'Hello',
    //                       imageUrl:
    //                       'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80'),
    //                   content:
    //                   'I like that, I very like that, like that very much, vcl van chua xuong dong a',
    //                   time: '1 hour ago'),
    //             ),
    //
    //             CommentItem(
    //               comment: new Comment(
    //                   user: new User(
    //                       name: 'Hello',
    //                       imageUrl:
    //                       'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80'),
    //                   content:
    //                   'I like that, I very like that, like that very much, vcl van chua xuong dong a',
    //                   time: '1 hour ago'),
    //             ),
    //
    //             CommentItem(
    //               comment: new Comment(
    //                   user: new User(
    //                       name: 'Hello',
    //                       imageUrl:
    //                       'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80'),
    //                   content:
    //                   'I like that, I very like that, like that very much, vcl van chua xuong dong a',
    //                   time: '1 hour ago'),
    //             )
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );

    for(Comment cmt in postContainer.review.comments){
      comments.add(CommentItem(comment: cmt));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          widget.postContainer,
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: TextField(
                    controller: commentContent,
                    maxLines: null,
                    onChanged: (val) {
                      if (val == '' || val == null) {
                        setState(() {
                          _invalid = false;
                        });
                      } else
                        setState(() {
                          _invalid = true;
                        });
                    },
                    decoration: InputDecoration(
                      hintText: 'Viết bình luận...',
                      hintStyle:
                          TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                _invalid
                    ? IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                  onPressed: (){
                    ReviewService().comment(postContainer.review, commentContent.value.text).then((val){
                      if(val.data["success"]){
                        //print(val.data["post"]);
                        // setState(() {
                           postContainer.review.comments.add(new Comment(user: Current.user, content: commentContent.value.text, time: DateTime.now().toString(), username: Current.user.name));
                        // });
                         // super.initState();
                           Navigator.pop(context);
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (context) => CommentList(postContainer: PostContainer(review: postContainer.review,),))
                        );


                      }
                    });
                  },
                      )
                    : SizedBox()
              ],
            ),
          ),


          Container(
            color: Colors.white,
            child: Column(
              children: comments,
            ),
          )
          // CommentItem(
          //   comment: new Comment(
          //       user: new User(
          //           name: 'Hello',
          //           imageUrl:
          //               'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80'),
          //       content: 'Hay vcl',
          //       time: '5 min ago'),
          // ),
          // CommentItem(
          //   comment: new Comment(
          //       user: new User(
          //           name: 'Hello',
          //           imageUrl:
          //               'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80'),
          //       content:
          //           'Cat dau moi a, viet cho dai ra thoi, xuong dong ho bo cai',
          //       time: '15 min ago'),
          // ),
          // CommentItem(
          //   comment: new Comment(
          //       user: new User(
          //           name: 'Hello',
          //           imageUrl:
          //               'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80'),
          //       content:
          //           'I like that, I very like that, like that very much, vcl van chua xuong dong a',
          //       time: '1 hour ago'),
          // ),
          // CommentItem(
          //   comment: new Comment(
          //       user: new User(
          //           name: 'Hello',
          //           imageUrl:
          //               'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80'),
          //       content:
          //           'I like that, I very like that, like that very much, vcl van chua xuong dong a',
          //       time: '1 hour ago'),
          // ),
          // CommentItem(
          //   comment: new Comment(
          //       user: new User(
          //           name: 'Hello',
          //           imageUrl:
          //               'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80'),
          //       content:
          //           'I like that, I very like that, like that very much, vcl van chua xuong dong a',
          //       time: '1 hour ago'),
          // ),
          // CommentItem(
          //   comment: new Comment(
          //       user: new User(
          //           name: 'Hello',
          //           imageUrl:
          //               'https://images.unsplash.com/photo-1578133671540-edad0b3d689e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80'),
          //       content:
          //           'I like that, I very like that, like that very much, vcl van chua xuong dong a',
          //       time: '1 hour ago'),
          // )
        ],
      ),
    );
  }
}
