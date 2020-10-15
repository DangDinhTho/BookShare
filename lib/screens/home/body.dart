import 'package:flutter/material.dart';
import 'package:share_books/screens/home/product.dart';

import 'item_card.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
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
    );
  }
}
