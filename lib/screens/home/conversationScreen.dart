import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationScreen extends StatefulWidget {
  final Map chatRoomMap;
  final LocalUser? currentUser;
  ConversationScreen({required this.chatRoomMap, required this.currentUser});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  // sendMessage textField controller
  TextEditingController _sendMessageController = TextEditingController();

  // setting up instance of database methods
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  //function for sending the message to be called in send button
  sendMessage() {
    if (_sendMessageController.text.isNotEmpty) {
      // setting up the message Map
      Map<String, dynamic> messageMap = {
        "message": _sendMessageController.text,
        "sentBy": widget.currentUser?.name,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      // getting the conversation messages through database functions
      _databaseMethods.addConversationMessages(
          widget.chatRoomMap['chatRoomId'], messageMap);
      _sendMessageController.clear();
    }
  }

  late Stream chatMessageStream;
  // chat message list
  Widget ChatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data!.docs[index].get("message"),
                      isSendByMe: snapshot.data!.docs[index].get("sentBy") ==
                          widget.currentUser!.name);
                },
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    _databaseMethods
        .getConversationMessages(widget.chatRoomMap['chatRoomId'])
        .then((value) {
      chatMessageStream = value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomMap['users'][0]),
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ChatMessageList(),
            Container(
              // alignment: Alignment.bottomCenter,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(hintText: "Send message"),
                        controller: _sendMessageController,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        sendMessage();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile({required this.message, required this.isSendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        child: Text(
          message,
        ),
      ),
    );
  }
}
