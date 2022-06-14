import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //Database service class instance
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  TextEditingController userNameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search People"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: userNameController,
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _databaseMethods.getUserByUsername(userNameController.text);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
