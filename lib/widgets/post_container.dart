import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_books/model/current_user.dart';
import 'package:share_books/model/review.dart';
import 'package:share_books/services/authservice.dart';
import 'package:share_books/services/review_service.dart';
import 'package:share_books/services/time_ago.dart';
import 'package:share_books/widgets/avatar.dart';
import 'package:share_books/widgets/comment_list.dart';

class PostContainer extends StatefulWidget {
  final Review review;
  final int maxLineContent;
  final bool canViewMore;
  const PostContainer({Key key, this.review, this.maxLineContent = 3, this.canViewMore = true}) : super(key:key);
  @override
  _PostContainerState createState() => _PostContainerState(review: review, maxLineContent: maxLineContent, canViewMore: canViewMore);
}

class _PostContainerState extends State<PostContainer> {
  Review review;
  bool _liked = false;
  int maxLineContent;
  bool canViewMore;
  _PostContainerState({Key key, this.review, this.maxLineContent, this.canViewMore}) : super();

  @override
  Widget build(BuildContext context) {
    //print(review.imageURLs);

    if(review.likes == null)
      _liked = false;
    else
      for(var liker in review.likes){
        if(liker == Current.user.name){
          _liked = true;
          break;
        }
      }

    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                FutureBuilder(
                    future: AuthService().getUser(review.owner),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Avatar();
                      } else {
                        //print(snapshot.data);
                        return Row(
                          children: [
                            Avatar(
                              radius: 20.0,
                              imageUrl: snapshot.data.imageUrl,
                              circleColor: Colors.blue,
                            ),
                          ],
                        );
                      }
                    }),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.owner, style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 2,),
                    Text(TimeAgo.timeAgoSinceDate(review.timeUpload),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        overflow: TextOverflow.ellipsis),
                  ],
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              alignment: AlignmentDirectional.topStart,
                child: Text(review.content, maxLines: maxLineContent, overflow: TextOverflow.ellipsis, softWrap: false,)
            ),
            Container(
              //width: 500,
              child: review.imageURLs[0] != "http://10.0.2.2:3000/" ?  Image(
                image: NetworkImage(review.imageURLs[0],), width: 400, height: 350, fit: BoxFit.fitWidth,
              ) : SizedBox()
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: _liked ? Icon(Icons.thumb_up, color: Colors.blue) : Icon(Icons.thumb_up, color: Colors.grey),
                        onPressed: (){

                          if(_liked){
                            ReviewService().unlike(review).then((val){
                              if(val.data["success"]){
                                print("unLiked");
                                setState(() {
                                  _liked = false;
                                  review.likes.remove(Current.user.name);
                                });
                              }
                            });
                          }
                          else{
                            ReviewService().like(review).then((val){
                              if(val.data["success"]){
                                print("liked");
                                setState(() {
                                  _liked = true;
                                  review.likes.add(Current.user.name);
                                });
                              }
                            });
                          }

                        },
                      ),

                      SizedBox(width: 5.0,),
                      review.likes == null ? Text("0") : Text(review.likes.length.toString())
                    ],
                  ),
                ),
                SizedBox(width: 150,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.mode_comment, color: Colors.green,),

                      SizedBox(width: 15.0,),
                      review.comments == null ? Text("0") : Text(review.comments.length.toString())
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
          onPressed: (){
          if(canViewMore)
            Navigator.push(context, new MaterialPageRoute(
                builder: (context) => CommentList(postContainer: PostContainer(review: review, maxLineContent: 100, canViewMore: false,),))
            );
          },
      ),
    );
  }
}


