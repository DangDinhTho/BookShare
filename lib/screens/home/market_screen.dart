import 'package:flutter/material.dart';
import 'package:share_books/constrain.dart';
import 'package:share_books/screens/home/product.dart';

import 'item_card.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  bool _folded = false;
  TextEditingController _editingController = new TextEditingController();

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
              padding: const EdgeInsets.only(left: 10.0),
              child: TextField(
                controller: _editingController,
                decoration: InputDecoration(
                  //contentPadding: EdgeInsets.only(left: 10),

                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.blue[300]),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.cancel, color: Colors.grey,),
                      iconSize: 20,
                      onPressed: (){
                        _editingController.clear();
                        //print(_editingController.);
                      },
                    )

                ),

              ),
            ),
          ),
          SizedBox(width: 30,),

          IconButton(
            icon: Icon(Icons.forum),
            iconSize: 30,
          ),

          SizedBox(width: 10,)
        ],
      ),
      body: Container(
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) => ItemCard(
                product: products[index],
                // press: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => DetailsScreen(
                //         product: products[index],
                //       ),
                //     )),
              )
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        //elevation: 10,
        child: Icon(Icons.library_add),
        onPressed: (){
          print("He");
        },

      ),
    );
  }
}
