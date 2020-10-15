
import 'package:flutter/material.dart';
import 'package:share_books/constrain.dart';
import 'package:share_books/screens/home/body.dart';

import 'bottom_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Constrain().appColor,
        elevation: 0,
        title: Text('Share Books'),
        actions: [
          IconButton(
             icon: Icon(Icons.search, size: 30),
           ),

          IconButton(
            icon: Icon(Icons.shopping_cart, size: 30,),
          ),

          SizedBox(width: 15,)
        ],
      ),

      body: HomeBody(),

      bottomNavigationBar: BottomBar()
    );
  }
}




