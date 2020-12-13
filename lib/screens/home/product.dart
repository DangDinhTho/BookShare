import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Product {
  final String imagePath, imageName, title, description, author, publisher, category, owner, price, id;
  //final int price;
  final Image image;
  Product({
    this.id,
    this.imagePath,
    this.imageName,
    this.title,
    this.price,
    this.description,
    this.author,
    this.publisher,
    this.category,
    this.owner,
    this.image

  });

  factory Product.fromJson(Map<String, dynamic> json){

    return Product(
      id: json['_id'] as String,
      imagePath: json['image'] as String,
      imageName: json['image'] as String,
      title: json['title'] as String,
      price: json['price'] as String,
      description: json['subtitle'] as String,
      author: json['author'] as String,
      publisher: json['publisher'] as String,
      category: json['category'] as String,
      owner: json['owner'] as String
    );

  }
}



List<Product> products = [
  Product(
      id: '1',
      title: "Harry Poster",
      price: '234',
      image: Image.asset('./assets/images/book_1.jpg'),
      description: dummyText,),
  Product(
    id: '2',
    title: "Harry Poster",
    price: '234',
    description: dummyText,),
  Product(
    id: '3',
    title: "Harry Poster",
    price: '234',
    description: dummyText,),

];

String dummyText =
    "The blurb (blurb- that's one of those grating, nails-on-a-chalkboard words, like percolate and swig, yuck) for this book says the story centers around a secret, underground experimenting facility that is connected to a teenager having strange visions so I kinda went into this book expecting it to be similar to the show Stranger Things.";
