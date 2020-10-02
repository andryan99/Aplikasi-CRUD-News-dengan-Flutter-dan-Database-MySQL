import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app/constant/constantFile.dart';
import 'package:news_app/constant/newsModel.dart';
import 'package:news_app/viewTabs/addNews.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/viewTabs/editNews.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  final list = new List<NewsModel>();
  var loading = false;
  Future _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.detailNews);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new NewsModel(
          api['id_news'],
          api['image'],
          api['title'],
          api['content'],
          api['description'],
          api['date_news'],
          api['id_users'],
          api['username'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  _delete(String id_news) async {
    final response =
        await http.post(BaseUrl.deleteNews, body: {"id_news": id_news});

    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      _lihatData();
    } else {
      print(pesan);
    }
  }

  dialogDelete(String id_news) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                Text(
                  "Apakah Data ini ingin di hapus ?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text('No')),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                        onTap: () {
                          _delete(id_news);
                        },
                        child: Text('Yes'))
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddNews()));
        },
        child: Icon(Icons.add),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return Container(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            BaseUrl.insertImage + x.image,
                            width: 150,
                            height: 120,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  x.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(x.date_news),
                              ],
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.blueAccent,
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EditNews(x, _lihatData)));
                              }),
                          IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.blueAccent,
                              onPressed: () {
                                dialogDelete(x.id_news);
                              }),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
