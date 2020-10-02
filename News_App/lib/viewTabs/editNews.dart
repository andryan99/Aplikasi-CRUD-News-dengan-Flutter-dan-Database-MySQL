import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/constant/constantFile.dart';
import 'package:news_app/constant/newsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;

class EditNews extends StatefulWidget {
  final NewsModel model;
  final VoidCallback reload;

  EditNews(this.model, this.reload);

  @override
  _EditNewsState createState() => _EditNewsState();
}

class _EditNewsState extends State<EditNews> {
  final _key = new GlobalKey<FormState>();

  File _imageFile;
  String title, content, description, id_users;
  TextEditingController txtTitle, txtContent, txtDescription;

  setup() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id_users = preferences.getString("id_users");
    });
    txtTitle = TextEditingController(text: widget.model.title);
    txtContent = TextEditingController(text: widget.model.content);
    txtDescription = TextEditingController(text: widget.model.description);
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
    //3.3 Edit gambar
    try {
      var uri = Uri.parse(BaseUrl.editNews);
      var request = http.MultipartRequest("POST", uri);

      //--------------------------------------------------------------
      request.fields['title'] = title;
      request.fields['content'] = content;
      request.fields['description'] = description;
      request.fields['id_users'] = id_users;
      request.fields['id_news'] = widget.model.id_news;

      var stream =
          http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();

      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));

      var response = await request.send();

      if (response.statusCode > 2) {
        print("image Upload");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  _pilihGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1920);
    setState(() {
      _imageFile = image;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
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
            Container(
              width: double.infinity,
              child: InkWell(
                onTap: () {
                  _pilihGallery();
                },
                child: _imageFile == null
                    ? Image.network(BaseUrl.insertImage + widget.model.image)
                    : Image.file(
                        _imageFile,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            TextFormField(
              controller: txtTitle,
              onSaved: (e) => title = e,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: txtContent,
              onSaved: (e) => content = e,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            TextFormField(
              controller: txtDescription,
              onSaved: (e) => description = e,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(
              height: 5,
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
