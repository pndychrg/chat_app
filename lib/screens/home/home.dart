import 'package:chat_app/screens/home/search/search.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    _auth.signOut();
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text("Messanging App"),
        ),
        body: Container(
          child: Text("home"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SearchScreen()));
          },
          child: Icon(Icons.search),
        ),
      ),
    );
  }
}
