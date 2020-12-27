import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_books/model/book.dart';
import 'package:share_books/model/current_user.dart';
import 'package:share_books/model/current_user.dart';
import 'package:share_books/model/current_user.dart';
import 'package:share_books/model/user.dart';
import 'package:share_books/screens/home/market_screen.dart';
import 'package:share_books/screens/home/product.dart';
import 'package:share_books/services/authservice.dart';
import 'package:share_books/services/time_ago.dart';
import 'package:share_books/widgets/avatar.dart';
import 'package:url_launcher/url_launcher.dart';

class Detail extends StatefulWidget {
  final Book book;
  final bool canChat;
  const Detail({Key key, @required this.book, this.canChat = true})
      : super(key: key);

  @override
  _DetailState createState() => _DetailState(book: book, canChat: canChat);
}

class _DetailState extends State<Detail> {

  Book book;
  bool canChat;
  _DetailState({Key key, @required this.book, this.canChat})
      : super();

  void customLaunch(command) async {
    if(await canLaunch(command)){
      await launch(command);
    }
  }

  bool saved = false;

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat("#,##0", "en_US");
    User owner;
    final roundedShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: BorderSide(color: Colors.blue),
    );

    final stadiumBorder = StadiumBorder(
      side: BorderSide(color: Colors.blue),
    );

    if(Current.user.saved.contains(book.id)){
      saved = true;
    }
    else saved = false;

    bool isOwner = false;
    if(Current.user.name == book.owner)
      isOwner = true;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        actions: [
           isOwner ? FlatButton(
            child: book.active ? Text("Đã bán") : Text("Đã bán", style: TextStyle(color: Colors.white),),
            onPressed: (){
              if(book.active){
                AuthService().setActiveBook(book.id, false).then((val){
                  if(val.data["success"]){
                    Book b = Book.fromJson(val.data["result"]);
                     setState(() {
                       book = b;
                     });
                  }
                });
              }
              else{
                AuthService().setActiveBook(book.id, true).then((val){
                  if(val.data["success"]){
                    Book b = Book.fromJson(val.data["result"]);
                    setState(() {
                      book = b;
                    });
                  }
                });
              }
            },
          ) : SizedBox()
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 20,
            child: Image.network(
              widget.book.imageURLs[0],
              width: 300,
              height: 300,
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),

                  SizedBox(height: 3.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        money.format(double.parse(widget.book.price)) + " VND",
                        style: TextStyle(color: Colors.green),
                      ),

                      Container(
                        height: 25,
                        child: saved ?
                            RaisedButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(0),
                              shape:  stadiumBorder,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Đã lưu", style: TextStyle(fontSize: 12, color: Colors.white),),
                                  SizedBox(width: 3,),
                                  Icon(Icons.favorite, color: Colors.white, size: 17,)
                                ],
                              )
                              ,

                              onPressed: (){
                                AuthService().unSaveBook(widget.book.id).then((val) {
                                  if (val.data["success"]) {
                                    //var jsonData = json.decode(val.data["user"]);
                                    Current.user = User.fromJson(val.data["user"]);
                                    print("Deleteted");
                                    setState(() {

                                    });
                                  }
                                });
                              },
                            )
                        : FlatButton(
                          color: Colors.white,
                          textColor: Colors.blue,
                          padding: EdgeInsets.all(0),
                          shape:  roundedShape,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Lưu tin", style: TextStyle(fontSize: 12, color: Colors.blue),),
                              SizedBox(width: 3,),
                              Icon(Icons.favorite_border, color: Colors.blue, size: 17,)
                            ],
                          )
                          ,

                          onPressed: (){
                            AuthService().saveBook(widget.book.id).then((val) {
                              if (val.data["success"]) {
                                //var jsonData = json.decode(val.data["user"]);
                                Current.user = User.fromJson(val.data["user"]);
                                print("Ola");
                                setState(() {

                                });
                              }
                            });
                          },
                        ),
                      )
                    ],
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.file_upload,
                        size: 12,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Flexible(
                        child: Text(TimeAgo.timeAgoSinceDate(widget.book.timeUpload),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  )
                ],
              )),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),

            child: FutureBuilder(
                future: AuthService().getUser(widget.book.owner),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: Text(
                          "Loading...",
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                      ),
                    );
                  } else {
                    owner = snapshot.data;
                    return Row(
                      children: [
                        Avatar(
                          radius: 20.0,
                          imageUrl: snapshot.data.imageUrl,
                          circleColor: Colors.blue,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Container(
                                      width: 250,
                                      child: Text(
                                        snapshot.data.address,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ))
                      ],
                    );
                  }
                }),

            // child: Avatar(
            //       radius: 20.0,
            //        imageUrl: AuthService().getUser(book.owner).then(val){
            //
            // },
            //        circleColor: Colors.blue,
            //      ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(widget.book.subtitle),
          ),
          Divider(),
          Column(
            children: [
              FlatButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.folder_open,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Thể loại: " + widget.book.category,
                        style: TextStyle(color: Colors.blue))
                  ],
                ),
                // onPressed: () {
                //   Navigator.push(
                //       context,
                //       new MaterialPageRoute(
                //           builder: (BuildContext context) => MarketScreen(
                //             futureBooks:
                //             AuthService().getBooksOfCategory(widget.book.category),
                //             showBottomButton: true,
                //           )));
                // },
              ),
              FlatButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Tác giả: " + widget.book.author,
                        style: TextStyle(color: Colors.blue))
                  ],
                ),
                // onPressed: () {
                //   Navigator.push(
                //       context,
                //       new MaterialPageRoute(
                //           builder: (BuildContext context) => MarketScreen(
                //                 futureBooks:
                //                     AuthService().getBooksOfAuthor(widget.book.author),
                //             showBottomButton: true,
                //               )));
                // },
              ),
              FlatButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.business,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Nhà xuất bản: " + widget.book.publisher,
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),
                // onPressed: () {
                //   Navigator.push(
                //       context,
                //       new MaterialPageRoute(
                //           builder: (BuildContext context) => MarketScreen(
                //             futureBooks:
                //             AuthService().getBooksOfPublisher(widget.book.publisher),
                //             showBottomButton: true,
                //           )));
                // },
              ),
              FlatButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Năm xuất bản: " + widget.book.year,
                        style: TextStyle(color: Colors.blue))
                  ],
                ),
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          children: [
            Expanded(
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Gọi",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )
                  ],
                ),
                onPressed: (){
                  customLaunch('tel:' + owner.phoneNumber);
                },
              ),
            ),
            Expanded(
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Gửi SMS",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )
                  ],
                ),
                onPressed: (){
                  customLaunch('sms:' + owner.phoneNumber);
                },
              ),
            ),
            // Expanded(
            //   child: FlatButton(
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(
            //           Icons.forum,
            //           color: Colors.white,
            //         ),
            //         SizedBox(
            //           width: 8,
            //         ),
            //         Text(
            //           "Nhắn tin",
            //           style: TextStyle(fontSize: 15, color: Colors.white),
            //         )
            //       ],
            //     ),
            //
            //     onPressed: (){
            //       customLaunch('sms:' + owner.phoneNumber);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
