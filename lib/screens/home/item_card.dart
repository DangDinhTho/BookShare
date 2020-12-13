import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_books/constrain.dart';
import 'package:share_books/model/book.dart';
import 'package:share_books/screens/home/detail.dart';
import 'package:share_books/screens/home/product.dart';
import 'package:share_books/services/cut_price.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class ItemCard extends StatelessWidget {
  final Book book;
  final Function press;


  const ItemCard({
    Key key,
    this.book,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat("#,##0", "en_US");
    return GestureDetector(
      onTap: press,
      child: Card(
        elevation: 0,
        child: FlatButton(
          padding: EdgeInsets.all(0),
          child: Container(
            decoration: BoxDecoration(
              //borderRadius: BorderRadiusDirectional.all(Radius.circular(5)),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(8),
            // For  demo we use fixed height  and width
            // Now we dont need them
            //  height: 120,
            //  width: 160,
            //color: Constrain().appColor,
            // decoration: BoxDecoration(
            //   color: product.color,
            //   borderRadius: BorderRadius.circular(16),
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: "${book.id}",
                  //child: Image.network(book.imageURLs[0], width: 200, height: 200, fit: BoxFit.contain),
                  child: Image.network(book.imageURLs[0], width: 200, height: 100, fit: BoxFit.fitWidth,),
                ),
                Container(
                  height: 40,
                  padding: const EdgeInsets.only(top: 2.5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    // products is out demo list
                    book.title,
                    style: TextStyle(color: Constrain().selectedColor, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),

                SizedBox(height: 5,),
                Text(
                  money.format(double.parse(book.price)) + " VND",
                  style: TextStyle(color: Colors.green),
                  overflow: TextOverflow.ellipsis,
                ),

                Row(

                  children: [
                    Icon(Icons.location_on, size: 12, color: Colors.grey,),
                    SizedBox(width: 3,),

                    Flexible(
                      child: Text(
                        "${book.address}",
                        style: TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => Detail(
                          book: book,
                        )));
          },
        ),
      ),
    );
  }
}
