import 'package:flutter/material.dart';
import 'package:share_books/screens/home/home.dart';
import 'package:share_books/screens/login_screen.dart';
import 'package:share_books/screens/sign_up_screen.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}


