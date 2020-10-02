import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:news_app/constant/constantFile.dart';
import 'package:news_app/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:news_app/mainMenu.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
    debugShowCheckedModeBanner: false,
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, SignIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String email, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
      //print("$email, $password");
    }
  }

  login() async {
    final response =
        await http.post(BaseUrl.login, body: {
      "email": email,
      "password": password,
    });
    final data = jsonDecode(response.body);
    //  print(data);
    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String emailAPI = data['email'];
    String id_users = data['id_users'];

    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.SignIn;
        savePref(value, usernameAPI, emailAPI,id_users);
      });
      print(pesan);
    } else {
      print(pesan);
    }
  }

  savePref(int value, String username, String email, String id_users) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("username", username);
      preferences.setString("email", email);
      preferences.setString("id_users", id_users);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.SignIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(15),
              children: <Widget>[
                TextFormField(
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Please insert Email";
                    }
                  },
                  onSaved: (e) => email = e,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextFormField(
                  obscureText: true,
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: showHide,
                        icon: Icon(_secureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                      )),
                ),
                MaterialButton(
                  onPressed: () {
                    check();
                  },
                  child: Text("Login"),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Register(),
                    ));
                  },
                  child: Text(
                    "Create New Account",
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        );
        break;
      case LoginStatus.SignIn:
        return MainMenu(signOut);
        break;
    }
  }
}
