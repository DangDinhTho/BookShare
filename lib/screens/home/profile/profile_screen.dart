import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_books/widgets/avatar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dang Dinh Tho"),
        actions: [
          IconButton(
            icon: Icon(Icons.forum),
          )
        ],
      ),

      body: ListView(
        padding: EdgeInsets.only(top: 5.0),
        children: [

          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 20),
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.green,
                  child: Image.network("https://www.pngkit.com/png/detail/392-3923111_row-of-books-png-ancona-life-desktop-organizer.png"),
                ),
              ),
              Avatar(radius: 50, hasBorder: true,)
            ],
          ),

          ListTile(
            leading: Icon(Icons.phone_iphone, color: Colors.redAccent,size: 35,),
            title: Text("Phone", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),),
            subtitle: Text("0338572822"),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                print("Edit");
              },
            ),
          ),

          Divider(thickness: 1,),

          ListTile(
            leading: Icon(Icons.home, color: Colors.green,size: 35,),
            title: Text("Address", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),),
            subtitle: Text("31 Phung Khoang"),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                print("Edit");
              },
            ),
          ),

          Divider(thickness: 1,),

          ListTile(
            leading: Icon(Icons.library_books, color: Colors.cyan,size: 35,),
            title: Text("Library", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),),
            subtitle: Text("31 books"),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: (){
                print("Edit");
              },
            ),
          ),

          Divider(thickness: 1,),
        ],
      )
    );
  }
}
