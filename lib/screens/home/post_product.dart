import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_books/model/book.dart';
import 'package:share_books/screens/home/detail.dart';
import 'package:share_books/screens/home/product.dart';
import 'package:share_books/services/authservice.dart';
import 'package:share_books/services/cut_price.dart';

class PostProduct extends StatefulWidget {
  @override
  _PostProductState createState() => _PostProductState();
}

class _PostProductState extends State<PostProduct> {
  PickedFile fileImage;
  String dropdownValue = 'One';

  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController author = new TextEditingController();
  TextEditingController publisher = new TextEditingController();
  TextEditingController category = new TextEditingController();
  TextEditingController year = new TextEditingController();

  openGallery(BuildContext context) async {
    var image = await new ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      fileImage = image;
    });
    Navigator.of(context).pop();
  }

  openCamera(BuildContext context) async {
    var image = await new ImagePicker().getImage(source: ImageSource.camera);
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
      return new Image.asset(
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
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  CutPrice()
                ],
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
                controller:  year,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.only(left: 10),
                  //icon: Icon(Icons.account_circle),
                  //hintText: 'Title',
                  labelText: 'Publishing year',
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

                DropdownButton<String>(
    value: dropdownValue,
    icon: Icon(Icons.arrow_downward),
    iconSize: 24,
    elevation: 16,
    style: TextStyle(color: Colors.deepPurple),
    underline: Container(
    height: 2,
    color: Colors.deepPurpleAccent,
    ),
    onChanged: (String newValue) {
    setState(() {
    dropdownValue = newValue;
    });
    },
    items: <String>['One', 'Two', 'Free', 'Four']
        .map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),
    )
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: FlatButton(
          child: Text('UPLOAD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          onPressed: (){
            if(title.value.text != ''){
              Book book = new Book(
                  title: title.value.text,
                  subtitle: description.value.text,
                  price: price.value.text.replaceAll(",", ""),
                  author: author.value.text,
                category: category.value.text,
                publisher: publisher.value.text,
                year: year.value.text,
                imageNames: [fileImage.path.split('/').last],
                imageURLs: [fileImage.path],
                  //imageName: fileImage.path.split('/').last
                //imageName: 'Test'
              );

              AuthService().uploadBook(book).then((val){
                if(val.data["success"]){
                  //print(val.data["newBook"]);
                  Navigator.pop(context);
                  Book newBook = Book.fromJson(val.data["newBook"]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Detail(book: newBook, canChat: false,)),
                  );
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
