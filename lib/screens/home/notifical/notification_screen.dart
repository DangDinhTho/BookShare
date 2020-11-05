import 'package:flutter/material.dart';
import 'package:share_books/widgets/notification_item.dart';

class NotificationScreen extends StatefulWidget {

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),

      body: Column(
        children: [


          Expanded(
            child: ListView(   // danh sách người like
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 15, bottom: 8),
                  child: Text("Earlier", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                NotificationItem(content: "đã nhắc đến bạn trong một bình luận", icon: Icons.comment, circleColor: Colors.green,),
                NotificationItem(content: "đã nhắc đến bạn trong một bình luận", icon: Icons.comment, circleColor: Colors.green,),

              ],
            ),
          )
        ],
      ),
    );
  }
}
