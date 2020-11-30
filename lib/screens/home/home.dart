import 'package:flutter/material.dart';
import 'package:share_books/constrain.dart';
import 'package:share_books/model/user.dart';
import 'package:share_books/screens/home/market_screen.dart';
import 'package:share_books/screens/home/notifical/notification_screen.dart';
import 'package:share_books/screens/home/profile/profile_screen.dart';
import 'package:share_books/screens/home/review/review_screen.dart';
import 'package:share_books/screens/login_screen.dart';
import 'package:share_books/services/authservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isLoaded = false;
  User user; // = new User(name: 'Loading...', imageUrl: null, phoneNumber: 'Loading...', address: 'Loading...');

  SharedPreferences sharedPreferences;
  String token;



  checkLoginStatus() async {
    if(isLoaded) return;
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null)
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (Route<dynamic> route) => false);
    else {
      await AuthService().getInfor(sharedPreferences.getString('token')).then((val) {
        user =  new User(name: val.data['user']['name'].toString(), imageUrl: val.data['user']['address'], phoneNumber: val.data['user']['phone_number'], address: val.data['user']['address']);
        //print(user.name);
        isLoaded = true;
        setState(() {
          isLoaded = true;
        });
      });
    }
  }


  @override
  void initState(){
    checkLoginStatus();
    super.initState();

  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return !isLoaded?
    Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.signal_wifi_off, size: 40, color: Colors.grey,),
            SizedBox(height: 10,),
            Text('No Connection!', style: TextStyle(color: Colors.grey),),
            SizedBox(height: 10,),
            FlatButton(
              color: Colors.grey,
              child: Text('Try again', style: TextStyle(color: Colors.black45)),
              onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Home()), (Route<dynamic> route) => false);
              },
            )
          ],
        ),
      ),
    ) : DefaultTabController(
      length: 2,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            MarketScreen(),
            ReviewScreen(),
            NotificationScreen(),
            ProfileScreen(user: user,)

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
              icon: Icon(Icons.store),
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
                title: Text("Account"),
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





