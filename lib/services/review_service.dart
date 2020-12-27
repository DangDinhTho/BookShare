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
import 'package:share_books/model/review.dart';
import 'package:share_books/model/user.dart';
import 'package:share_books/screens/home/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ReviewService{
  Dio dio = new Dio();

  Future<User> getUser(username) async{
    var data = await http.get("http://10.0.2.2:3000/getUser/$username");

    var jsonData = json.decode(data.body);
    User user = User.fromJson(jsonData["user"]);
    print(jsonData);
    return user;
  }

  upReview(content, image) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    print(token);
    dio.options.headers['Authorization'] = 'Bearer $token';

    // final filePath = await FlutterAbsolutePath.getAbsolutePath(files[0].identifier);
    //
    // File tempFile = File(filePath);
    // print(tempFile.path);

    var formData =  FormData.fromMap({
      'content': content,
      'image': await MultipartFile.fromFile(image),
    });

    try{
      return await dio.post('http://10.0.2.2:3000/post/addNew', data: formData,
          options: Options(contentType: Headers.formUrlEncodedContentType));
    }
    on DioError catch(err){
      //Fluttertoast.showToast(msg: err.response.data['msg']);
      print('non object');
      return err.response;
    }
  }


  upReviewNoImage(content) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    print(token);
    dio.options.headers['Authorization'] = 'Bearer $token';



    try{
      return await dio.post('http://10.0.2.2:3000/post/addNew2', data: {
        'content': content,
      }, options: Options(contentType: Headers.formUrlEncodedContentType));

    }
    on DioError catch(err){
      //Fluttertoast.showToast(msg: err.response.data['msg']);
      print('non object');
      return err.response;
    }
  }

  like(Review review) async {
    try{
      return await dio.post('http://10.0.2.2:3000/post/like', data: {
        'name': Current.user.name,
        '_id': review.id
      }, options: Options(contentType: Headers.formUrlEncodedContentType));
    }
    on DioError catch(err){
      //Fluttertoast.showToast(msg: err.response.data['msg']);
      print('non object');
      return err.response;
    }
  }

  unlike(Review review) async {
    try{
      return await dio.post('http://10.0.2.2:3000/post/unlike', data: {
        'name': Current.user.name,
        '_id': review.id
      }, options: Options(contentType: Headers.formUrlEncodedContentType));
    }
    on DioError catch(err){
      //Fluttertoast.showToast(msg: err.response.data['msg']);
      print('non object');
      return err.response;
    }
  }

  comment(Review review, String content) async {
    try{
      return await dio.post('http://10.0.2.2:3000/post/comment', data: {
        '_id': review.id,
        'owner': Current.user.name,
        'content': content
      }, options: Options(contentType: Headers.formUrlEncodedContentType));
    }
    on DioError catch(err){
      //Fluttertoast.showToast(msg: err.response.data['msg']);
      print('non object');
      return err.response;
    }
  }


  Future<List<Review>> getAllReview() async {
    var data = await http.get("http://10.0.2.2:3000/post/getAllPosts");
    var jsonData = json.decode(data.body);
    List<Review> reviews = [];
    for(var b in jsonData){
      Review review = Review.fromJson(b);
      reviews.add(review);
      //print(review.comments);
    }
    //print("reviews");
    return reviews;
  }

  Future<List<Review>> getReviewOwner(String owner) async {
    var data = await http.get("http://10.0.2.2:3000/post/withOwner?owner=$owner");
    var jsonData = json.decode(data.body);
    if(jsonData["success"]){
      List<Review> reviews = [];
      for(var r in jsonData["result"]){
        Review review = Review.fromJson(r);
        reviews.add(review);
      }
      return reviews;
    }
    else return null;
  }

}