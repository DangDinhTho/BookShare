
import 'package:flutter/material.dart';
import 'package:share_books/widgets/avatar.dart';

class NotificationItem extends StatelessWidget {
  //final User user;
  final String title;
  final String content;
  final bool seen;
  final IconData icon;
  final Color circleColor;

  const NotificationItem({
    Key key,
    @required
    this.content,
    this.seen = false,
    this.icon,
    this.circleColor,
    this.title = "",
  }) : super(key : key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: seen ? Colors.white: Colors.blue[50],
      //width: MediaQuery.of(context).size.width * 0.75,
      padding: EdgeInsets.only(top: 5, bottom: 5, right: 5),
      //height: 35,
      child: Row(
        children: [
          FlatButton(
            child: Row(
              children: [
                Avatar(
                  radius: 30.0,
                  //imageUrl: user.imageUrl,
                  icon: icon,
                  circleColor: circleColor,
                ),
                SizedBox(width: 15,),
                Container(
                  width: 210,
                  child: Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(text: title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            TextSpan(text: " " + content, style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black))
                          ]

                      )),
                )
              ],
            ),
          ),
          //SizedBox(width: 0,),

          Container(
            child: IconButton(
                icon: Icon(Icons.more_horiz, color: Colors.black,
                )
            ),
          )
        ],
      ),
    );
  }
}
