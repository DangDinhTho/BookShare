import 'package:meta/meta.dart';
import 'user.dart';

class Comment {
  final User user;
  final String username;
  final String content;
  final String time;

  const Comment({
    @required this.user,
    @required this.content,
    @required this.time,
    @required this.username
  });

  factory Comment.fromJson(Map<String, dynamic> json) {

    return Comment(
        username: json["owner"] as String,
        content: json["content"] as String,
        time: json["time_comment"] as String,
    );
  }

}