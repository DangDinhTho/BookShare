import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:share_books/model/book.dart';
import 'package:share_books/screens/home/product.dart';
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

  uploadBook(book) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    print(token);
    dio.options.headers['Authorization'] = 'Bearer $token';

    var formData =  FormData.fromMap({
      'title': book.title,
      'subtitle': book.subtitle,
      'price': book.price,
      'author': book.author,
      'publisher': book.publisher,
      'year': book.year,
      'category': book.category,
      'image': await MultipartFile.fromFile(book.imageURLs[0] ,filename: book.imageNames[0]),
      // "files": [
      //   await MultipartFile.fromFile("./developerlibs.txt", filename: "developerlibs.txt"),
      //   await MultipartFile.fromFile("./developerlibs.txt", filename: "developerlibs.txt"),
      // ]
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

   Future<List<Book>> getAllBooks() async {
     var data = await http.get("http://10.0.2.2:3000/product/getAllBooks");
     var jsonData = json.decode(data.body);
     List<Book> books = [];
     for(var b in jsonData){
       Book book = Book.fromJson(b);
       books.add(book);
     }
     print(books.length);
     return books;
   }

}