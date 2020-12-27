import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_books/model/current_user.dart';
import 'package:share_books/services/review_service.dart';
import 'package:share_books/widgets/avatar.dart';

class PostReview extends StatefulWidget {
  @override
  _PostReviewState createState() => _PostReviewState();
}

class _PostReviewState extends State<PostReview> {
  PickedFile fileImage;
  bool _invalid = false;
  final _picker = ImagePicker();
  TextEditingController content = new TextEditingController();
  openGallery(BuildContext context) async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      fileImage = image;
      _invalid = true;
      //fileImages.add(File(image.path));
    });

    Navigator.of(context).pop();
  }

  openCamera(BuildContext context) async {
    var image = await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      fileImage = image;
      _invalid = true;
      //fileImages.add(File(image.path));
    });
    Navigator.of(context).pop();
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

  Widget imageProduct() {
    if (fileImage == null) {
      return Text('');
    } else
      return new Image.file(
        File(fileImage.path),
        //width: 300,
        //height: 300,
        fit: BoxFit.fitWidth,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Viết bài review"),
        actions: [
          FlatButton(
            child: Text("ĐĂNG", style: TextStyle(color: !_invalid? Colors.white30:Colors.white, fontSize: 15),),
            onPressed: () {
              if(fileImage == null){
                ReviewService()
                    .upReviewNoImage(content.value.text)
                    .then((val) {
                  if (val.data["success"]) {
                    Navigator.pop(context);
                  }
                  else{
                    print(val.data["msg"]);
                  }
                });
              }
              else
              ReviewService()
                  .upReview(content.value.text, fileImage.path)
                  .then((val) {
                if (val.data["success"]) {
                  Navigator.pop(context);
                }
                else{
                  print(val.data["msg"]);
                }
              });
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Row(
            children: [
              Avatar(imageUrl: Current.user.imageUrl,),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Current.user.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text("Đang hoạt động", style: TextStyle(fontSize: 12))
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: content,
                  maxLines: null,
                  onChanged: (val) {
                    if (val == '' || val == null) {
                      setState(() {
                        _invalid = false;
                      });
                    }
                    else setState(() {
                      _invalid = true;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Bạn muốn chia sẻ điều gì?',
                    hintStyle:
                        TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
                    border: InputBorder.none,
                  ),
                ),
                Container(
                  child: Stack(
                    children: [
                      imageProduct(),
                      Positioned(
                        top: 1,
                        right: 1,
                        child: IconButton(
                          icon: Icon(Icons.cancel, color: Colors.white, size: 30,),
                          onPressed: (){
                            setState(() {
                              fileImage = null;
                              if(content.value.text == '' || content.value.text == null){
                                _invalid = false;
                              }
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: FlatButton(
          child: Text(
            "THÊM ẢNH",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            _showChoiseDialog(context);
          },
        ),
      ),
    );
  }
}
