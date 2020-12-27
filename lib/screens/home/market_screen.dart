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

StreamController<Future<List<Book>>> streamController = StreamController();

class MarketScreen extends StatefulWidget {
  final Future<List<Book>> futureBooks;
  final bool showBottomButton;
  final Stream stream;
  const MarketScreen({Key key, this.futureBooks, this.showBottomButton = false, this.stream}) : super(key:key);

  @override
  _MarketScreenState createState() => _MarketScreenState(showBottomButton: showBottomButton, marketScreen: this);
}

class _MarketScreenState extends State<MarketScreen> {
  bool showBottomButton;
  MarketScreen marketScreen;
  TextEditingController _editingController = new TextEditingController();
  Future<List<Book>> futureBooks;
  _MarketScreenState({Key key, this.showBottomButton, this.marketScreen}) : super();

  @override
  void initState() {
    super.initState();

    widget.stream.listen((event) {
      SetListBook(event);
    });
  }
  void SetListBook(Future<List<Book>> _futureBooks){
      setState(() {
       futureBooks = _futureBooks;
     });
    print("Here");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constrain().appColor,
        actions: [
          Container(
            margin: EdgeInsets.all(10),

            width: 270,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: TextField(
                controller: _editingController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.only(left: 10),

                    hintText: 'Tìm kiếm',
                    hintStyle: TextStyle(color: Colors.blue[300]),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.cancel, color: Colors.grey,),
                      iconSize: 20,
                      onPressed: (){
                        _editingController.clear();
                        setState(() {
                          futureBooks = AuthService().getAllBooks();
                        });
                        //print(_editingController.);
                      },
                    )

                ),

                onSubmitted: (val){
                  setState(() {
                    futureBooks = AuthService().searchBook(_editingController.value.text);
                  });
                },

              ),
            ),
          ),
          //SizedBox(width: 30,),

          Container(
            alignment: Alignment.center,
            //width: 30,
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.local_bar, color: Colors.white, size: 25,),

                  Text("Lọc", style: TextStyle(fontSize: 12, color: Colors.white),)
                ],
              ),
              onPressed: (){
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => LocScreen()
                      //     MarketScreen(
                      //   futureBooks:
                      //   AuthService().getBooksSaved(Current.user.name), showBottomButton: true,
                      // )
                    ));
              },
            ),
          ),

         // SizedBox(width: 10,)
        ],
      ),
      body: Container(
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: FutureBuilder(
            future: futureBooks,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("Loading...", style: TextStyle(color: Colors.blue, fontSize: 20),),
                  ),
                );
              }
              else {
                return GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) =>
                        ItemCard(
                          book: snapshot.data[index],
                          // press: () => Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => DetailsScreen(
                          //         product: products[index],
                          //       ),
                          //     )),
                        )
                );
              }
            }

          ),
        ),
      ),

      bottomNavigationBar: showBottomButton ? BottomAppBar(
        color: Colors.blue,
        child: FlatButton(
          child: Text(
            "TRỞ VỀ CHỢ SÁCH",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => Home()));

          },
        ),
      ): SizedBox(),

      floatingActionButton: FloatingActionButton(
        //elevation: 10,
        child: Icon(Icons.library_add),
        onPressed: (){
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) => PostProduct(
                  )));
        },

      ),
    );
  }
}
