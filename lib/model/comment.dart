import 'package:meta/meta.dart';
import 'user.dart';

class Comment {
  final User user;
  final String content;
  final String time;

  const Comment({
    @required this.user,
    @required this.content,
    @required this.time
  });
}