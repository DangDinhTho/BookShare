import 'package:flutter/material.dart';
import 'package:share_books/constrain.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _selectindex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectindex,
      backgroundColor: Constrain().appColor,

      selectedItemColor: Constrain().selectedColor,

      items: [

        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          title: Text('Books'),
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.thumbs_up_down),
          title: Text('Reviews'),
        ),

        // BottomNavigationBarItem(
        //   icon: Icon(Icons.notifications),
        //   title: Text('Notifi'),
        // ),

        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          title: Text('Account'),
        )


      ],
      onTap: (index){
        setState(() {
          _selectindex = index;
        });
      },

    );
  }
}
