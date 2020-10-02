import 'package:flutter/material.dart';
import 'package:news_app/viewTabs/category.dart';
import 'package:news_app/viewTabs/home.dart';
import 'package:news_app/viewTabs/news.dart';
import 'package:news_app/viewTabs/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;

  MainMenu(this.signOut);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "", email = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      email = preferences.getString("email");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.lock_open),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            Home(),
            News(),
            Category(),
            Profile(),
          ],

          //   child: Text("Username : $username, \n Email : $email"),
        ),
        bottomNavigationBar: TabBar(
          labelColor: Colors.blueAccent,
          unselectedLabelColor: Colors.grey,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home),
              text: "Home",
            ),
            Tab(
              icon: Icon(Icons.new_releases),
              text: "News",
            ),
            Tab(
              icon: Icon(Icons.category),
              text: "Category",
            ),
            Tab(
              icon: Icon(Icons.perm_contact_calendar),
              text: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
