import 'package:chat_app/models/user.dart';
import 'package:chat_app/screens/home/conversationScreen.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  LocalUser? currentUser;
  SearchScreen({required this.currentUser});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //Database service class instance
  final DatabaseMethods _databaseMethods = DatabaseMethods();
  // search field controller
  TextEditingController userNameSearchController = new TextEditingController();

  // user list which is updated as users are found
  List userSearchList = [];
  // this function gets the userList and update it
  initiateSearch() async {
    var userTemplist =
        await _databaseMethods.getUserByUsername(userNameSearchController.text);
    setState(() {
      userSearchList = userTemplist;
    });
  }

  // this widget creates the list view with all the user matching to
  // given userName
  Widget searchList() {
    return userSearchList != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: userSearchList.length,
            itemBuilder: ((context, index) {
              // return SearchTile(
              //     userEmail: userList[index]['email'],
              //     userName: userList[index]['name']);
              return Container(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(userSearchList[index]['name']),
                        Text(userSearchList[index]['email']),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        createChatroomAndStartConversation(
                            userNameSearchController.text);
                      },
                      child: Text("Message"),
                    ),
                  ],
                ),
              );
            }))
        : Container();
  }

  // create unique chatroom id
  getChatRoomId(String a, String? b) {
    if (a.substring(0, 1).codeUnitAt(0) > b!.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  // create chatroom, send user to conversation screen, pushReplacement
  createChatroomAndStartConversation(String userSearchName) {
    //creating userList
    List<String?> users = [userSearchName, widget.currentUser?.name];
    print(users);

    // using function getchatroomid
    String chatRoomId = getChatRoomId(userSearchName, widget.currentUser?.name);
    // chatRoomMap
    Map<String, dynamic> chatRoomMap = {
      'users': users,
      'chatRoomId': chatRoomId
    };
    _databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => ConversationScreen()));
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
                  controller: userNameSearchController,
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

// class SearchTile extends StatelessWidget {
//   final String userName;
//   final String userEmail;
//   SearchTile({required this.userEmail, required this.userName});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         children: [
//           Column(
//             children: [
//               Text(userName),
//               Text(userEmail),
//             ],
//           ),
//           Spacer(),
//           ElevatedButton(
//             onPressed: () {},
//             child: Text("Message"),
//           ),
//         ],
//       ),
//     );
//   }
// }
