import 'package:meta/meta.dart';

class User {
  final String name;
  final String imageUrl;
  final List<String> library;
  final List<String> post;
  final List<String> saved;
  final String phoneNumber;
  final String address;

  const User(
      {@required this.name,
      @required this.imageUrl,
      @required this.library,
      @required this.post,
      @required this.phoneNumber,
      @required this.address,
      this.saved
      });

  factory User.fromJson(Map<String, dynamic> json) {
    List<String> _library = [];
    for (String book in json["library"]) {
      _library.add(book);
    }
    List<String> _post = [];
    for (String p in json["posts"]) {
      _post.add(p);
    }

    List<String> _saved = [];
    for (String p in json["saveBooks"]) {
      _saved.add(p);
    }

    String path = "http://10.0.2.2:3000/" + json["avtURL"].toString().split('\\').last;

    return User(
      name: json["name"] as String,
      imageUrl: path,
      phoneNumber: json["phone_number"] as String,
      address: json["address"].toString(),
      library: _library,
      post: _post,
      saved: _saved
    );
  }
}
