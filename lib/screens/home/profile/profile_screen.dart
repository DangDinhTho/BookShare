import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_books/model/current_user.dart';
import 'package:share_books/model/user.dart';
import 'package:share_books/screens/home/home.dart';
import 'package:share_books/screens/home/profile_books.dart';
import 'package:share_books/screens/home/review/review_screen.dart';
import 'package:share_books/screens/login_screen.dart';
import 'package:share_books/services/authservice.dart';
import 'package:share_books/services/review_service.dart';
import 'package:share_books/widgets/avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../market_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({Key key, @required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(user: user);
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user;
  int indexSelected = 0;
  _ProfileScreenState({Key key, this.user}) : super();

  logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('token', null);
    sharedPreferences.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  PickedFile fileImage;
  final _picker = ImagePicker();

  openGallery(BuildContext context) async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      fileImage = image;
      //fileImages.add(File(image.path));
    });

    Navigator.of(context).pop();
    if(fileImage != null)
    _showReviewAvatar(context);
  }

  openCamera(BuildContext context) async {
    var image = await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      fileImage = image;
      //fileImages.add(File(image.path));
    });
    Navigator.of(context).pop();
    if(fileImage != null)
    _showReviewAvatar(context);
  }

  Future<void> _showChoiseDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Make a choice!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.photo_library,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Thư viện"),
                      ],
                    ),
                    onTap: () {
                      openGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  GestureDetector(
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Camera"),
                      ],
                    ),
                    onTap: () {
                      openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showReviewAvatar(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'Cập nhật ảnh đại diện',
              style: TextStyle(color: Colors.blue),
            )),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Image.file(File(fileImage.path),
                      width: 200, height: 200, fit: BoxFit.fitWidth),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    //margin: EdgeInsets.all(10),

                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        "TẢI LÊN",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        AuthService()
                            .uploadAvt(fileImage.path)
                            .then((val) {
                          if (val.data["success"]) {
                            //var jsonData = json.decode(val.data["user"]);
                            Current.user = User.fromJson(val.data["user"]);
                            Navigator.pop(context);
                            setState(() {
                              user = Current.user;
                            });
                          }
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget title(){
    String tit;
    switch(indexSelected){
      case 0: tit = user.name;
      break;
      case 1: tit = "Kho sách của " + user.name;
      break;
      case 2: tit = "Sách đã lưu của " + user.name;
      break;
    }
    return Text(tit);
  }

  Future<Null> refresh() async {
    Completer<Null> completer = new Completer();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await AuthService().getInfor(sharedPreferences.getString('token')).then((val) {
      //var jsonData = json.decode(val.data);
      if(val.data["success"]){
        user = User.fromJson(val.data["user"]);
        Current.user = user;
        print("complete");
        completer.complete();
        setState(() {

        });
      }

    });


    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: title(),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: (){
              setState(() {
                indexSelected = 0;
              });
            },
          ),
          actions: [
            user.name == Current.user.name ? FlatButton(
              child: Row(
                children: [
                  Text("Đăng xuất", style: TextStyle(color: Colors.white),),
                  SizedBox(width: 2,),
                  Icon((Icons.exit_to_app), color: Colors.white,)
                ],
              ),
              onPressed: () {
                logout();
              },
            ) : SizedBox()
          ],
        ),
        body: IndexedStack(
          index: indexSelected,
          children: [
            defaultProfile(),
            ProfileBooks(futureBooks: AuthService().getBooksOfPoster(user.name), type: 1, username: user.name,),
            ProfileBooks(futureBooks: AuthService().getBooksSaved(user.name), type: 2, username: user.name,)
          ],
    )


        );
  }

  Widget defaultProfile(){
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
        padding: EdgeInsets.only(top: 5.0),
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding:
                const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 20),
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.green,
                  child: Image.network(
                      "http://10.0.2.2:3000/uploads/cover.jpeg"),
                ),
              ),
              Avatar(
                imageUrl: user.imageUrl,
                radius: 50,
                hasBorder: true,
              ),
              user.name == Current.user.name ? Positioned(
                  bottom: 0,
                  child: FlatButton(
                    child: Text("Edit"),
                    onPressed: () {
                      _showChoiseDialog(context);
                    },
                  )) : SizedBox()
            ],
          ),
          ListTile(
            leading: Icon(
              Icons.phone_iphone,
              color: Colors.redAccent,
              size: 35,
            ),
            title: Text(
              "Phone",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            subtitle: Text(user.phoneNumber),
            trailing: user.name == Current.user.name ? IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                print("Edit");
              },
            ) : SizedBox(),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.green,
              size: 35,
            ),
            title: Text(
              "Address",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            subtitle: Text(user.address),
            trailing: user.name == Current.user.name ? IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                print("Edit");
              },
            ) : SizedBox(),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.library_books,
              color: Colors.cyan,
              size: 35,
            ),
            title: Text(
              "Kho sách",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            subtitle: user.library == null
                ? Text("0 cuốn sách")
                : Text(user.library.length.toString() + " cuốn sách"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {

           setState(() {
             indexSelected = 1;
           });
              // Navigator.push(
              //     context,
              //     new MaterialPageRoute(
              //         builder: (BuildContext context) =>
              //             ProfileBooks(futureBooks: AuthService().getBooksOfPoster(user.name))
              //       //Home(indexSelected: 0,)
              //
              //     )
              // );
            },
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.rate_review,
              color: Colors.orange,
              size: 35,
            ),
            title: Text(
              "Bài review",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            subtitle: user.post == null
                ? Text("0 bài review")
                : Text(user.post.length.toString() + " bài review"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => ReviewScreen(
                        futureReviews:
                        ReviewService().getReviewOwner(user.name),
                      )));
            },
          ),

          Divider(
            thickness: 1,
          ),
          ListTile(
            leading: Icon(
              Icons.save_alt,
              color: Colors.lightBlue,
              size: 35,
            ),
            title: Text(
              "Sách đã lưu",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            subtitle: user.post == null
                ? Text("Chưa lưu cuốn sách nào")
                : Text(user.saved.length.toString() + " sách đã lưu"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              setState(() {
                indexSelected = 2;
              });
              // Navigator.push(
              //     context,
              //     new MaterialPageRoute(
              //         builder: (BuildContext context) => MarketScreen(
              //           futureBooks:
              //           AuthService().getBooksSaved(user.name),
              //         )));
            },
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
