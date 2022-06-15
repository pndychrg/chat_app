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
  // search field controller
  TextEditingController userNameController = new TextEditingController();

  // user list which is updated as users are found
  List userList = [];
  // this function gets the userList and update it
  initiateSearch() async {
    var userTemplist =
        await _databaseMethods.getUserByUsername(userNameController.text);
    setState(() {
      userList = userTemplist;
    });
  }

  // this widget creates the list view with all the user matching to
  // given userName
  Widget searchList() {
    return userList != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: userList.length,
            itemBuilder: ((context, index) {
              return SearchTile(
                  userEmail: userList[index]['email'],
                  userName: userList[index]['name']);
            }))
        : Container();
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

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
                  // _databaseMethods.getUserByUsername(userNameController.text);
                  initiateSearch();
                },
              ),
            ],
          ),
          searchList(),
        ],
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  SearchTile({required this.userEmail, required this.userName});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Text(userName),
              Text(userEmail),
            ],
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {},
            child: Text("Message"),
          ),
        ],
      ),
    );
  }
}
