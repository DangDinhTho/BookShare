import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:share_books/model/book.dart';
import 'package:share_books/model/current_user.dart';
import 'package:share_books/model/user.dart';
import 'package:share_books/screens/home/product.dart';
import 'package:share_books/widgets/avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthService{
  Dio dio = new Dio();

  getUsername() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('token');
  }

  signUp(username, phoneNumber, address, password) async{
    try{
      return await dio.post('http://10.0.2.2:3000/signup', data: {
        'name': username,
        'phone_number': phoneNumber,
        'address': address,
        'password': password
      }, options: Options(contentType: Headers.formUrlEncodedContentType));
    }
    on DioError catch(err){
      //Fluttertoast.showToast(msg: err.response.data['msg']);
      print('non object');
      return err.response;
    }
  }

  login(name, password) async {
    try{
      return await dio.post('http://10.0.2.2:3000/authenticate', data: {
        'name': name,
        'password': password
      }, options: Options(contentType: Headers.formUrlEncodedContentType));
    }
    on DioError catch(err){
      //Fluttertoast.showToast(msg: err.response.data['msg']);
      print('non object');
      return err.response;
    }

  }

   getInfor(token) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    return await dio.get('http://10.0.2.2:3000/getinfor');

  }

  Future<User> getUser(username) async{
    var data = await http.get("http://10.0.2.2:3000/getUser/$username");

    var jsonData = json.decode(data.body);
    if(jsonData["success"]){
      User user = User.fromJson(jsonData["user"]);
      return user;
    }
    else return null;
  }

  uploadBook(book) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';

    // final filePath = await FlutterAbsolutePath.getAbsolutePath(files[0].identifier);
    //
    // File tempFile = File(filePath);
    // print(tempFile.path);

    var formData =  FormData.fromMap({
      'title': book.title,
      'subtitle': book.subtitle,
      'price': book.price,
      'author': book.author,
      'publisher': book.publisher,
      'year': book.year,
      'category': book.category,
      'score': book.score.toInt().toString(),
      'image': await MultipartFile.fromFile(book.imageURLs[0]),
    });

    try{
      return await dio.post('http://10.0.2.2:3000/product/newBook', data: formData,
          options: Options(contentType: Headers.formUrlEncodedContentType));
    }
    on DioError catch(err){
      //Fluttertoast.showToast(msg: err.response.data['msg']);
      print('non object');
      return err.response;
    }
  }

  saveBook(bookId) async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    var formData = {
      'bookId': bookId,
    };

    try {
      return await dio.post(
          'http://10.0.2.2:3000/user/saveBook', data: formData,
          options: Options(contentType: Headers.formUrlEncodedContentType));
    }
    on DioError catch (err) {
      //Fluttertoast.showToast(msg: err.response.data['msg']);
      print('non object');
      return err.response;
    }
  }

  unSaveBook(bookId) async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    var formData = {
      'bookId': bookId,
    };

    try {
      return await dio.post(
          'http://10.0.2.2:3000/user/unSaveBook', data: formData,
          options: Options(contentType: Headers.formUrlEncodedContentType));
    }
    on DioError catch (err) {
      //Fluttertoast.showToast(msg: err.response.data['msg']);
      print('non object');
      return err.response;
    }
  }

  uploadAvt(file) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    print(token);
    dio.options.headers['Authorization'] = 'Bearer $token';

    var formData =  FormData.fromMap({
      'image': await MultipartFile.fromFile(file),
    });

    try{
      return await dio.post('http://10.0.2.2:3000/user/uploadAvt', data: formData,
          options: Options(contentType: Headers.formUrlEncodedContentType));
    }
    on DioError catch(err){
      //Fluttertoast.showToast(msg: err.response.data['msg']);
      print('non object');
      return err.response;
    }
  }



   Future<List<Book>> getAllBooks(List<Book> books) async {
     var skip = books.length;
     var data = await http.get("http://10.0.2.2:3000/product/getAllBooks?skip=$skip");
     var jsonData = json.decode(data.body);
     //List<Book> books = [];
     for(var b in jsonData){
       Book book = Book.fromJson(b);
       bool exits = false;
       if(books.length > 0)
       for(var b0 in books){
         if(b0.id == book.id){
           exits = true;
           break;
         }
       }
       if(!exits)
       books.add(book);
     }
     return sortBooks(books);
     //return books;
   }

  Future<List<Book>> getBooksFilter(String category, String minCost, String maxCost) async {
    if(category == "Tất cả") category = "";

    var data = await http.get("http://10.0.2.2:3000/product/filter?category=$category&minCost=$minCost&maxCost=$maxCost");

    var jsonData = json.decode(data.body);
    if(jsonData["success"]){
      List<Book> books = [];
      for(var b in jsonData["result"]){
        Book book = Book.fromJson(b);
        books.add(book);
      }
      return sortBooks(books);
      //return books;
    }
    else return null;
  }

  Future<List<Book>> searchBook(String params) async {

    var data = await http.get("http://10.0.2.2:3000/product/search?search=$params");

      var jsonData = json.decode(data.body);
      if(jsonData["success"]){
        List<Book> books = [];
        for(var b in jsonData["result"]){
          Book book = Book.fromJson(b);
          books.add(book);
        }
        //return books;
        return sortBooks(books);
      }
      else return null;
  }

  Future<List<Book>> getBooksOfAuthor(String author) async {

    var data = await http.get("http://10.0.2.2:3000/product/withAuthor?author=$author");

    var jsonData = json.decode(data.body);
    if(jsonData["success"]){
      List<Book> books = [];
      for(var b in jsonData["result"]){
        Book book = Book.fromJson(b);
        books.add(book);
      }
      //return books;
      return sortBooks(books);
    }
    else return null;
  }

  Future<List<Book>> getBooksOfPublisher(String publisher) async {

    var data = await http.get("http://10.0.2.2:3000/product/withPublisher?publisher=$publisher");

    var jsonData = json.decode(data.body);
    if(jsonData["success"]){
      List<Book> books = [];
      for(var b in jsonData["result"]){
        Book book = Book.fromJson(b);
        books.add(book);
      }
      //return books;
      return sortBooks(books);
    }
    else return null;
  }

  Future<List<Book>> getBooksOfCategory(String category) async {

    var data = await http.get("http://10.0.2.2:3000/product/withCategory?category=$category");

    var jsonData = json.decode(data.body);
    if(jsonData["success"]){
      List<Book> books = [];
      for(var b in jsonData["result"]){
        Book book = Book.fromJson(b);
        books.add(book);
      }
      //return books;
      return sortBooks(books);
    }
    else return null;
  }

  Future<List<Book>> getBooksOfPoster(String poster) async {

    var data = await http.get("http://10.0.2.2:3000/product/withOwner?owner=$poster");

    var jsonData = json.decode(data.body);
    if(jsonData["success"]){
      List<Book> books = [];
      for(var b in jsonData["result"]){
        Book book = Book.fromJson(b);
        books.add(book);
      }
      return books;
    }
    else return null;
  }


  Future<List<Book>> getBooksSaved(String name) async {
    var data = await http.get("http://10.0.2.2:3000/user/getBookSaved?name=$name");

    var jsonData = json.decode(data.body);
    if(jsonData["success"]){
      List<Book> books = [];
      for(var b in jsonData["result"]){
        Book book = Book.fromJson(b);
        books.add(book);
      }
      print(books.length);
      return books;
    }
    else return null;
  }

  setActiveBook(String bookId, bool isActive) async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    var formData = {
      'bookId': bookId,
      'active': isActive
    };

    try {
      return await dio.post(
          'http://10.0.2.2:3000/product/setBookActive', data: formData,
          options: Options(contentType: Headers.formUrlEncodedContentType));
    }
    on DioError catch (err) {
      //Fluttertoast.showToast(msg: err.response.data['msg']);
      print('non object');
      return err.response;
    }
  }

  sortBooks(List<Book> books){
    List<Book> _books = books;
       _books.sort((a, b) => b.score.compareTo(a.score));
       return _books;
  }

}