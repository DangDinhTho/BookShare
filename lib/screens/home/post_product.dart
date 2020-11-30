import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_books/screens/home/product.dart';
import 'package:share_books/services/authservice.dart';

class PostProduct extends StatefulWidget {
  @override
  _PostProductState createState() => _PostProductState();
}

class _PostProductState extends State<PostProduct> {
  PickedFile fileImage;

  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController author = new TextEditingController();
  TextEditingController publisher = new TextEditingController();
  TextEditingController category = new TextEditingController();

  openGallery(BuildContext context) async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      fileImage = image;
    });
    Navigator.of(context).pop();
  }

  openCamera(BuildContext context) async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      fileImage = image;
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
                        Icon(Icons.photo_library, color: Colors.blue,),
                        SizedBox(width: 20,),
                        Text("Gallery"),

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
                        Icon(Icons.camera_alt, color: Colors.blue,),
                        SizedBox(width: 20,),
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
      return Image.asset(
        fileImage.path,
        width: 200,
        height: 200,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Book'),
        centerTitle: true,
        // actions: [
        //   FlatButton(
        //     child: Text('POST', style: TextStyle(color: Colors.white),),
        //   )
        // ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          Container(
            //height: 200,
            // decoration: BoxDecoration(
            //     // image: DecorationImage(
            //     //   image: Image.asset('name'),
            //     //   fit: BoxFit.cover,
            //     // ),
            //     border: Border.all(color: Colors.grey),
            //     borderRadius: BorderRadius.circular(10)),
            child: Stack(alignment: Alignment.center, children: [
              imageProduct(),
              FlatButton(
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, size: 30, color: Colors.grey,),
                      Text('Image', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),

                onPressed: (){
                  _showChoiseDialog(context);
                },
              ),
            ]),
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: title,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.only(left: 10),
                  //icon: Icon(Icons.account_circle),
                  //hintText: 'Title',
                  labelText: 'Title',
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  hintStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: description,
                style: TextStyle(color: Colors.blue),
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                  hintStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: price,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.only(left: 10),
                  //icon: Icon(Icons.account_circle),
                  //hintText: 'Title',
                  labelText: 'Price',
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  hintStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: author,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.only(left: 10),
                  //icon: Icon(Icons.account_circle),
                  //hintText: 'Title',
                  labelText: 'Author',
                  labelStyle:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  hintStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: publisher,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.only(left: 10),
                  //icon: Icon(Icons.account_circle),
                  //hintText: 'Title',
                  labelText: 'Publisher',
                  labelStyle:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  hintStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
              ),
              TextField(
                controller:  category,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.only(left: 10),
                  //icon: Icon(Icons.account_circle),
                  //hintText: 'Title',
                  labelText: 'Category',
                  labelStyle:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  hintStyle: TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: FlatButton(
          child: Text('UPLOAD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          onPressed: (){
            if(title.value.text != ''){
              Product book = new Product(
                  title: title.value.text,
                  description: description.value.text,
                  price2: price.value.text,
                  author: author.value.text,
                category: category.value.text,
                publisher: publisher.value.text
              );

              AuthService().uploadBook(book).then((val){
                if(val.data['success']){
                  Navigator.pop(context);
                }
                else{
                  print(val.data['msg']);
                }

              });

            }
          },
        ),
      ),
    );
  }
}
