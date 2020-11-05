import 'package:flutter/material.dart';
import 'package:share_books/widgets/avatar.dart';
import 'package:share_books/widgets/comment_list.dart';

class PostContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Avatar(),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name", style: TextStyle(fontWeight: FontWeight.bold),),
                    Text("10 min ago")
                  ],
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              alignment: AlignmentDirectional.topStart,
                child: Text("Status")
            ),
            Container(
              //width: 500,
              child: Image(
                image: NetworkImage('https://inustration.vn/wp-content/uploads/2020/02/truoc_khi_nghi_viec_hay_doc_22_quyen_sach_nay6.jpg'),
              )
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up, color: Colors.grey,)
                      ),

                      SizedBox(width: 5.0,),
                      Text("125")
                    ],
                  ),
                ),
                SizedBox(width: 150,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.mode_comment, color: Colors.green,),
                        onPressed: (){
                          Navigator.push(context, new MaterialPageRoute(
                              builder: (context) => CommentList(postContainer: this,))
                          );
                        },
                      ),

                      SizedBox(width: 5.0,),
                      Text("12")
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


