import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/constant/constantFile.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String username, email, password;
  bool _secureText = true;

  final _key = new GlobalKey<FormState>();

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    final response =
        await http.post(BaseUrl.register, body: {
      "username": username,
      "email": email,
      "password": password,
    });

    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert Username";
                }
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(labelText: "Username"),
            ),
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
                    icon: Icon(
                        _secureText ? Icons.visibility_off : Icons.visibility),
                  )),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
