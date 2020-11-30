import 'package:flutter/material.dart';

class Product {
  final String image, title, description, author, publisher, category, owner, price2;
  final int price, size, id;
  final Color color;
  const Product({
    this.id,
    this.image,
    this.title,
    this.price,
    this.description,
    this.author,
    this.publisher,
    this.category,
    this.owner, this.size, this.price2,
    this.color,

  });
}

List<Product> products = [
  Product(
      id: 1,
      title: "Harry Poster",
      price: 234,
      size: 12,
      description: dummyText,
      image: "assets/images/book_1.jpg",
      color: Color(0xFF3D82AE)),
  Product(
      id: 2,
      title: "Hat giong tam hon",
      price: 234,
      size: 8,
      description: dummyText,
      image: "assets/images/book_1.jpg",
      color: Color(0xFFD3A984)),
  Product(
      id: 3,
      title: "Doraemon",
      price: 234,
      size: 10,
      description: dummyText,
      image: "assets/images/book_1.jpg",
      color: Color(0xFF989493)),
  Product(
      id: 4,
      title: "Pikachu",
      price: 234,
      size: 11,
      description: dummyText,
      image: "assets/images/book_1.jpg",
      color: Color(0xFFE6B398)),
  Product(
      id: 5,
      title: "Morning",
      price: 234,
      size: 12,
      description: dummyText,
      image: "assets/images/book_1.jpg",
      color: Color(0xFFFB7883)),
  Product(
    id: 6,
    title: "Smart think",
    price: 234,
    size: 12,
    description: dummyText,
    image: "assets/images/book_1.jpg",
    color: Color(0xFFAEAEAE),
  ),
];

String dummyText =
    "The blurb (blurb- that's one of those grating, nails-on-a-chalkboard words, like percolate and swig, yuck) for this book says the story centers around a secret, underground experimenting facility that is connected to a teenager having strange visions so I kinda went into this book expecting it to be similar to the show Stranger Things.";
