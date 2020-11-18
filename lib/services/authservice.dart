import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class AuthService{
  Dio dio = new Dio();

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

  getinfor(token) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    return await dio.get('http://10.0.2.2:3000/getinfor');
  }

}