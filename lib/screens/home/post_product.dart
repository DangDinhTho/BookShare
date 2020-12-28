import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
//import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:share_books/model/book.dart';
import 'package:share_books/screens/home/detail.dart';
import 'package:share_books/screens/home/product.dart';
import 'package:share_books/screens/home/profile/profile_screen.dart';
import 'package:share_books/services/authservice.dart';
import 'package:share_books/services/cut_price.dart';

class PostProduct extends StatefulWidget {
  @override
  _PostProductState createState() => _PostProductState();
}

class _PostProductState extends State<PostProduct> {
  final money = NumberFormat("#,##0", "en_US");
  PickedFile fileImage;
  List<File> fileImages = new List<File>();
  int indexInput = 0;
  var _category = [
    "Tiểu thuyết",
    "Truyện tranh",
    "Sách giáo khoa - Giáo trình",
    "Sách khoa học"
  ];
  final _picker = ImagePicker();
  String dropdownValue;
  bool prime = false;
  double _currentSliderValue = 1, cost = 10000;
  bool pay = false;

  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController author = new TextEditingController();
  TextEditingController publisher = new TextEditingController();
  //TextEditingController category = new TextEditingController();
  TextEditingController year = new TextEditingController();

  openGallery(BuildContext context) async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      fileImage = image;
      //fileImages.add(File(image.path));
    });

    Navigator.of(context).pop();
  }

  openCamera(BuildContext context) async {
    var image = await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      fileImage = image;
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

  Future<void> _showPayDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Xác nhận thanh toán: ${money.format(double.parse(cost.toString())) + " VND"}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),)),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Container(
                    height: 35,
                    width: 120,
                    decoration: BoxDecoration(
                        color: pay ? Colors.white : Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                    ),
                    //padding: EdgeInsets.all(10),

                    child: FlatButton(
                      padding: EdgeInsets.all(2),
                      child: Text("HUỶ", style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: 35,
                    width: 120,
                    decoration: BoxDecoration(
                        color: pay ? Colors.white : Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                    ),
                    //padding: EdgeInsets.all(10),

                    child: FlatButton(
                        padding: EdgeInsets.all(2),
                        child: Text("THANH TOÁN", style: TextStyle(color: Colors.white, fontSize: 13),),
                      onPressed: (){
                          setState(() {
                            pay = true;
                            Navigator.pop(context);
                          });
                      },
                    ),
                  ),
                ),
              ],
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
        width: 400,
        height: 200,
        fit: BoxFit.fitWidth,
      );
  }

  Widget input1() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tiêu đề & Giá"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Stack(alignment: Alignment.center, children: [
              ClipRRect(
                child: imageProduct(),
                borderRadius: BorderRadius.circular(10),
              ),
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
                      Icon(
                        Icons.add_photo_alternate,
                        size: 30,
                        color: Colors.grey,
                      ),
                      Text(
                        'Ảnh',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  _showChoiseDialog(context);
                },
              ),
            ]),
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
                  onChanged: (val) {
                    if (val == '' || val == null) {}
                  },
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.only(left: 10),
                    //icon: Icon(Icons.account_circle),
                    //hintText: 'Title',
                    labelText: 'Tên sách',
                    labelStyle:
                        TextStyle(fontSize: 17.5, fontStyle: FontStyle.italic),
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
                    suffixText: "VNĐ",
                    labelText: 'Giá',
                    labelStyle:
                        TextStyle(fontSize: 17.5, fontStyle: FontStyle.italic),
                    hintStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: FlatButton(
          child: Text(
            "TIẾP TỤC",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            setState(() {
              indexInput = 1;
            });
          },
        ),
      ),
    );
  }

  Widget input2() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin sách"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
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
                    labelText: 'Tác giả',
                    labelStyle:
                        TextStyle(fontSize: 17.5, fontStyle: FontStyle.italic),
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
                    labelText: 'Nhà xuất bản',
                    labelStyle:
                        TextStyle(fontSize: 17.5, fontStyle: FontStyle.italic),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: DropdownButton(
                    items: _category
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.blue),
                              ),
                              value: value,
                            ))
                        .toList(),
                    underline: SizedBox(),
                    onChanged: (selectedAccountType) {
                      print('$selectedAccountType');
                      setState(() {
                        dropdownValue = selectedAccountType;
                      });
                    },
                    value: dropdownValue,
                    isExpanded: true,
                    hint: Text(
                      'Danh mục',
                      style: TextStyle(
                          fontSize: 17.5, fontStyle: FontStyle.italic),
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
                  controller: year,
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.only(left: 10),
                    //icon: Icon(Icons.account_circle),
                    //hintText: 'Title',
                    labelText: 'Năm xuất bản',
                    labelStyle:
                        TextStyle(fontSize: 17.5, fontStyle: FontStyle.italic),
                    hintStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton(
                child: Text(
                  "QUAY LẠI",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  setState(() {
                    indexInput = 0;
                  });
                },
              ),
              FlatButton(
                child: Text(
                  "TIẾP TỤC",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  setState(() {
                    indexInput = 2;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget input3() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
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
                    labelText: 'Mô tả',
                    labelStyle:
                        TextStyle(fontSize: 17.5, fontStyle: FontStyle.italic),
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
            Row(
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                      value: prime,
                      activeColor: Colors.red,
                      onChanged: (value) {
                        setState(() {
                          if(pay) prime = true;
                          else
                          prime = value;
                        });
                      }),
                ),
                Text(
                  "Hiển thị ưu tiên",
                  style: TextStyle(fontSize: 18.0),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),

            prime ? Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("Số ngày: $_currentSliderValue", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                Slider(
                value: _currentSliderValue,
                min: 1,
                max: 10,
                divisions: 9,
                label: _currentSliderValue.round().toString(),
                onChanged: !pay ? (double value) {
                  setState(() {
                    _currentSliderValue = value;
                    cost = _currentSliderValue * 10000 - 1000 * (_currentSliderValue - 1);
                  });
                } : null,
              ),
                  Text("Số tiền phải trả: ${money.format(double.parse(cost.toString())) + " VND"}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                  Center(
                    child: Container(
                      height: 35,
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: pay ? Colors.white : Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                      ),
                      //padding: EdgeInsets.all(10),

                      child: FlatButton(
                        padding: EdgeInsets.all(10),
                        child: !pay ? Text("THANH TOÁN", style: TextStyle(color: Colors.white),) :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("ĐÃ THANH TOÁN", style: TextStyle(color: Colors.blue),),
                            SizedBox(width: 3,),
                            Icon(Icons.check_circle, color: Colors.blue, size: 17,)
                          ],
                        ),
                        onPressed: (){
                          if(!pay){
                            _showPayDialog(context);
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ) : SizedBox()
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              child: Text(
                "QUAY LẠI",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                setState(() {
                  indexInput = 1;
                });
              },
            ),
            FlatButton(
              child: Text(
                "ĐĂNG",
                style: TextStyle(
                    color: (title.value.text != '' &&
                            fileImage != null &&
                            dropdownValue != null && ((prime && pay) || !prime))
                        ? Colors.white
                        : Colors.white24,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (title.value.text != '' &&
                    fileImage != null &&
                    dropdownValue != null && ((prime && pay) || !prime)) {
                  double dayPrime;
                  if(pay) dayPrime = _currentSliderValue;
                  else dayPrime = 0;
                  Book book = new Book(
                    title: title.value.text,
                    subtitle: "" + description.value.text,
                    price: "" + price.value.text.replaceAll(",", ""),
                    author: "" + author.value.text,
                    category: "" + dropdownValue,
                    publisher: "" + publisher.value.text,
                    year: "" + year.value.text,
                    score: dayPrime,
                    //imageNames: [fileImage.path.split('/').last],
                    imageURLs: [fileImage.path],
                  );

                  AuthService().uploadBook(book).then((val) {
                    if (val.data["success"]) {
                      //print(val.data["newBook"]);
                      Navigator.pop(context);
                      Book newBook = Book.fromJson(val.data["newBook"]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Detail(
                                  book: newBook,
                                  canChat: false,
                                )),
                      );
                    } else {
                      print(val.data['msg']);
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget InputScreens() {
  //   switch (indexInput) {
  //     case 0:
  //       return input1();
  //     case 1:
  //       return input2();
  //     case 2:
  //       return input3();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: indexInput,
      children: [input1(), input2(), input3()],
    );
  }
}
