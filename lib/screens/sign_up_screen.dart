import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_books/constrain.dart';
import 'package:share_books/screens/home/home.dart';
import 'package:share_books/services/authservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  TextEditingController _confirmPassword = new TextEditingController();
  TextEditingController _phoneNumber = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  //TextEditingController _username = new TextEditingController();
  String username, phoneNumber, address, confirmPassword, password, token;
  String falseConstrain = '';

  login(token) async{
    print(token);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString('token', token);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Home()), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SIGN UP"),
        centerTitle: true,

      ),
      body:
      Center(

        child: SingleChildScrollView(
          child: (
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(falseConstrain, style: TextStyle(color: Colors.red),),

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
                          hintText: 'username',
                          hintStyle: TextStyle(color: Colors.blue),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.cancel, color: Colors.grey,),
                            iconSize: 20,
                            onPressed: (){
                              _username.clear();
                              //print(_editingController.);
                            },
                          )

                      ),

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
                      controller: _phoneNumber,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(left: 10),
                          icon: Icon(Icons.phone),
                          hintText: 'phone number',
                          hintStyle: TextStyle(color: Colors.blue),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.cancel, color: Colors.grey,),
                            iconSize: 20,
                            onPressed: (){
                              _username.clear();
                              //print(_editingController.);
                            },
                          )

                      ),

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
                      controller: _address,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(left: 10),
                          icon: Icon(Icons.location_on),
                          hintText: 'address',
                          hintStyle: TextStyle(color: Colors.blue),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.cancel, color: Colors.grey,),
                            iconSize: 20,
                            onPressed: (){
                              _username.clear();
                              //print(_editingController.);
                            },
                          )

                      ),

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
                          hintText: 'password',
                          hintStyle: TextStyle(color: Colors.blue),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.cancel, color: Colors.grey,),
                            iconSize: 20,
                            onPressed: (){
                              _password.clear();
                              //print(_editingController.);
                            },
                          )

                      ),

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
                      controller: _confirmPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(left: 10),
                          icon: Icon(Icons.lock),
                          hintText: 'confirm password',
                          hintStyle: TextStyle(color: Colors.blue),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.cancel, color: Colors.grey,),
                            iconSize: 20,
                            onPressed: (){
                              _password.clear();
                              //print(_editingController.);
                            },
                          )

                      ),

                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: FlatButton(
                      child: Text("SIGNUP"),
                      onPressed: (){

                        username = _username.value.text;
                        phoneNumber = _phoneNumber.value.text;
                        address = _address.value.text;
                        password = _password.value.text;
                        confirmPassword = _confirmPassword.value.text;

                        if(username == '' || phoneNumber == '' || address == '' || password ==''){
                          setState(() {
                            falseConstrain = 'something is null';
                          });
                        }
                        else if(confirmPassword != password){
                          setState(() {
                            falseConstrain = 'password is not fill';
                          });
                        }
                        else{
                          //print(username + '-' + password);
                          AuthService().signUp(username, phoneNumber, address, password).then((val){
                            if(val.data['success']){
                              AuthService().login(username, password).then((val) {
                                if(val.data['success']) {
                                  var token = val.data['token'];
                                  login(token);
                                }
                                else{
                                  print('no');
                                }
                              });
                            }
                          });
                        }

                      },
                    ),
                  ),


                ],
              )
          ),
        ),
      ),
    );
  }
}
