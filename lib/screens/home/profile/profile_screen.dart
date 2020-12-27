import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_books/model/current_user.dart';
import 'package:share_books/model/user.dart';
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
    _showReviewAvatar(context);
  }

  openCamera(BuildContext context) async {
    var image = await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      fileImage = image;
      //fileImages.add(File(image.path));
    });
    Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user.name),
          actions: [
            FlatButton(
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
                Positioned(
                    bottom: 0,
                    child: FlatButton(
                      child: Text("Edit"),
                      onPressed: () {
                        _showChoiseDialog(context);
                      },
                    ))
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
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  print("Edit");
                },
              ),
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
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  print("Edit");
                },
              ),
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
                "Tủ sách",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              subtitle: user.library == null
                  ? Text("0 cuốn sách")
                  : Text(user.library.length.toString() + " cuốn sách"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => MarketScreen(
                              futureBooks:
                                  AuthService().getBooksOfPoster(user.name), showBottomButton: true,
                            )));
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
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => MarketScreen(
                          futureBooks:
                          AuthService().getBooksSaved(user.name), showBottomButton: true,
                        )));
              },
            ),
            Divider(
              thickness: 1,
            ),
          ],
        ));
  }
}
