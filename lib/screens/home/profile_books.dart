import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_books/constrain.dart';
import 'package:share_books/model/book.dart';
import 'package:share_books/model/current_user.dart';
import 'package:share_books/screens/home/home.dart';
import 'package:share_books/screens/home/loc_screen.dart';
import 'package:share_books/screens/home/post_product.dart';
import 'package:share_books/screens/home/product.dart';
import 'package:share_books/services/authservice.dart';
import 'dart:async';

import 'item_card.dart';


class ProfileBooks extends StatefulWidget {
  final Future<List<Book>> futureBooks;
  //final bool showBottomButton;
  final int type;
  final String username;
  // final Stream stream;
  // final Stream streamType;
  const ProfileBooks(
      {Key key, this.futureBooks, this.type = 0, this.username})
      : super(key: key);

  @override
  _ProfileBooks createState() => _ProfileBooks(futureBooks, type, username);
}

class _ProfileBooks extends State<ProfileBooks> {
  //bool showBottomButton;
  int type;
  TextEditingController _editingController = new TextEditingController();
  Future<List<Book>> futureBooks;
  String username;
  _ProfileBooks(this.futureBooks, this.type, this.username);

  List<Book> books = new List();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // scrollController.addListener(() {
    //   if (scrollController.position.maxScrollExtent ==
    //       scrollController.offset) {
    //
    //     //setListBook(AuthService().getAllBooks(books));
    //   }
    // });

  }


  void setListBook(Future<List<Book>> _futureBooks) {
    setState(() {
      futureBooks = _futureBooks;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[50],
        child: RefreshIndicator(
          onRefresh: refresh,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FutureBuilder(
                  future: futureBooks,
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
                      books = snapshot.data;
                      return GridView.builder(
                          itemCount: snapshot.data.length,
                          controller: scrollController,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio: 0.9,
                          ),
                          itemBuilder: (context, index) => ItemCard(
                            book: snapshot.data[index],
                            contextId: type,
                            // press: () => Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => DetailsScreen(
                            //         product: products[index],
                            //       ),
                            //     )),
                          ));
                    }
                  })),
        ),
      ),
      // bottomNavigationBar: type != 0
      //     ? BottomAppBar(
      //         color: Colors.blue,
      //         child: FlatButton(
      //           child: Text(
      //             "TRỞ VỀ CHỢ SÁCH",
      //             style: TextStyle(
      //                 color: Colors.white, fontWeight: FontWeight.bold),
      //           ),
      //           onPressed: () {
      //             Navigator.pop(context);
      //             Navigator.push(
      //                 context,
      //                 new MaterialPageRoute(
      //                     builder: (BuildContext context) => Home()));
      //           },
      //         ),
      //       )
      //     : SizedBox(),


      floatingActionButton: Container(
        width: 40,
        height: 40,
        child: FloatingActionButton(
          backgroundColor: Colors.blue[200],
          elevation: 0,
          heroTag: type,
          child: Icon(Icons.refresh),
          onPressed: () {
            refresh();
          },
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,


    );
  }

  Future<Null> refresh() async {
    Completer<Null> completer = new Completer();
      switch(type) {
        case 1:
          setListBook(AuthService().getBooksOfPoster(username));
          break;
        case 2:
          setListBook(AuthService().getBooksSaved(username));
          break;
      }
    completer.complete();
    return completer.future;
  }
}
