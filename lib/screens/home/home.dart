import 'package:chat_app/models/user.dart';
import 'package:chat_app/screens/home/conversationScreen.dart';
import 'package:chat_app/screens/home/search/search.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//---------------------------------------
// sending current logged in user details through this screen to search screen
//---------------------------------------
class Home extends StatefulWidget {
  LocalUser? currentUser;
  Home({required this.currentUser});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  //creating a stream
  late Stream? chatRoomStream = null;
  //getting the chatRooms before creating of the screen
  @override
  void initState() {
    // print(widget.currentUser?.name);
    // setting up if clause to ensure chatrooms are only recieved when user is not
    // null
    if (widget.currentUser?.name != null) {
      _databaseMethods.getChatRooms(widget.currentUser?.name).then((value) {
        setState(() {
          chatRoomStream = value;
        });
      });
    }

    super.initState();
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.docs[index]
                        .get("chatRoomId")
                        .toString()
                        .replaceAll("_", ""),
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<LocalUser?>(context);
    // print(user?.name);
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
          child: chatRoomList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(user?.name);
            print(user?.uID);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => SearchScreen(
                          currentUser: widget.currentUser,
                        )));
          },
          child: Icon(Icons.search),
        ),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;

  ChatRoomsTile({required this.userName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context,MaterialPageRoute(builder: (_)=>ConversationScreen(chatRoomMap: chatRoomMap, currentUser: widget.currentUser)))
      },
      child: Container(
        child: Row(
          children: [
            Container(
              child: Text(
                "${userName.substring(0, 1)}",
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(userName),
          ],
        ),
      ),
    );
  }
}
