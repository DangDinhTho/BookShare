import 'package:meta/meta.dart';

class User {
  final String name;
  final String imageUrl;
  final String phoneNumber;
  final String address;

  const User({
    @required this.name,
    @required this.imageUrl,
    @required this.phoneNumber,
    @required this.address
  });
}
