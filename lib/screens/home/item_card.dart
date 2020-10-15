import 'package:flutter/material.dart';
import 'package:share_books/constrain.dart';
import 'package:share_books/screens/home/product.dart';

class ItemCard extends StatelessWidget {
  final Product product;
  final Function press;
  const ItemCard({
    Key key,
    this.product,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
            child: Container(
              padding: EdgeInsets.all(10),
              // For  demo we use fixed height  and width
              // Now we dont need them
              //  height: 120,
              //  width: 160,
               color: Constrain().appColor,
              // decoration: BoxDecoration(
              //   color: product.color,
              //   borderRadius: BorderRadius.circular(16),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: "${product.id}",
                    child: Image.asset(product.image),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10 / 4),
                    child: Text(
                      // products is out demo list
                      product.title,
                      style: TextStyle(color: Constrain().selectedColor),
                    ),
                  ),
                  Text(
                    "\$${product.price}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
    );
  }
}
