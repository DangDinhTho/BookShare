import 'package:flutter/material.dart';
import 'package:share_books/screens/home/product.dart';

class Detail extends StatelessWidget {
  final Product product;
  const Detail({Key key, @required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 20,
            child: Image.asset(product.image),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),),
                SizedBox(height: 5.0,),
                Text("\$ " + product.price.toString(), style: TextStyle(color: Colors.green),)
              ],
            )
          ),

          Divider(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(product.description),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          children: [
            Expanded(
              child: FlatButton(
                    child: Icon(Icons.forum, color: Colors.white,),
              ),
            ),
            Expanded(
              child: FlatButton(
                child: Icon(Icons.card_giftcard, color: Colors.white,),
              ),
            ),

            Expanded(
              child: FlatButton(
                padding: EdgeInsets.all(0),
                disabledColor: Colors.red,
                child: Text("Buy", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
