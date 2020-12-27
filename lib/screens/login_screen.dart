import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_books/screens/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_books/screens/sign_up_screen.dart';
import 'package:share_books/services/authservice.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  String username, password, token;

  String notification = "";
  login(token) async {
    print(token);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('token', token);
    sharedPreferences.setString('username', username);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Home()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("ĐĂNG NHẬP"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: (Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                notification,
                style: TextStyle(color: Colors.red),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(left: 10),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextField(
                  controller: _username,
                  decoration: InputDecoration(
                      //contentPadding: EdgeInsets.only(left: 10),
                      icon: Icon(Icons.account_circle),
                      hintText: 'Tên đăng nhập',
                      hintStyle: TextStyle(color: Colors.blue),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.grey,
                        ),
                        iconSize: 20,
                        onPressed: () {

                          _username.clear();
                          setState(() {
                            notification = "";
                          });
                          //print(_editingController.);
                        },
                      )),
                  onTap: (){
                    setState(() {
                      notification = "";
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.only(left: 10),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                      //contentPadding: EdgeInsets.only(left: 10),
                      icon: Icon(Icons.lock),
                      hintText: 'Mật khẩu',
                      hintStyle: TextStyle(color: Colors.blue),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.grey,
                        ),
                        iconSize: 20,
                        onPressed: () {
                          _password.clear();
                          setState(() {
                            notification = "";
                          });
                          //print(_editingController.);
                        },
                      )),
                  onTap: (){
                    setState(() {
                      notification = "";
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: FlatButton(
                  child: Text("ĐĂNG NHẬP"),
                  onPressed: () {
                    username = _username.value.text;
                    password = _password.value.text;

                    if(username == ""){
                      setState(() {
                        notification = "Tên đăng nhập không được để trống!";
                      });
                    }
                    else if(password == ""){
                      setState(() {
                        notification = "mật khẩu không được để trống!";
                      });
                    }
                    else{
                      AuthService().login(username, password).then((val) {
                        if (val.data['success']) {
                          var token = val.data['token'];
                          login(token);
                        } else {
                          print(val.data["msg"]);
                          setState(() {
                            notification = "Sai tên đăng nhập hoặc mật khẩu!";
                          });
                        }
                      });
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: FlatButton(
                  child: Text("ĐĂNG KÍ"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) => SignUpScreen()));
                  },
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
