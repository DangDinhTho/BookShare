import 'package:flutter/material.dart';
import 'package:share_books/constrain.dart';
import 'package:share_books/screens/home/market_screen.dart';
import 'package:share_books/screens/home/notifical/notification_screen.dart';
import 'package:share_books/screens/home/profile/profile_screen.dart';
import 'package:share_books/screens/home/review/review_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            MarketScreen(),
            ReviewScreen(),
            NotificationScreen(),
            ProfileScreen()

          ],

        ),

        bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          //backgroundColor: Constrain().appColor,
          selectedItemColor: Constrain().selectedColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              title: Text("Market")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.camera),
                title: Text("Review")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                title: Text("Notifications")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                title: Text("Account")
            )
          ],

          onTap: (index){
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}





