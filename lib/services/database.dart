import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {
  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  // final CollectionReference chatRoom =
  //     FirebaseFirestore.instance.collection("ChatRoom");

  //updating the user data
  Future updateUserData(String uID, Map userInfoMap) async {
    return await userCollection.doc(uID).set(userInfoMap);
  }

  //setting userdata stream for further use

  getUserByUsername(String username) async {
    // User map which is to be found
    List<Map?> userList = [];
    // getting all the data from firestore
    final data = await FirebaseFirestore.instance.collection("users").get();
    // final data = await userCollection.get();
    // Iterating all the documents of the firestore and checking thier data
    // if the username is found or not
    data.docs.forEach((element) {
      Map user = element.data();
      // if (user['name'] == username) {
      //   userList.add(user);
      // }
      // checking if any username contains the substring of
      // given username
      if (user['name'].toString().contains(username)) {
        userList.add(user);
      }
    });
    // print(userList);
    return userList;
  }

  // getting username by uID to remove issue of getting null userName
  getUserNamebyUID(String uID) async {
    String userName = '';
    //getting the collection users
    var data = await FirebaseFirestore.instance.collection("users").get();
    data.docs.forEach((element) {
      Map user = element.data();
      if (user['uID'] == uID) {
        userName = user['name'];
      }
    });
    return userName;
  }

  //getusername list to ensure usernames are not repeated
  getUsernameList() async {
    var userNameList = [];
    // getting user collection from firebase
    var data = await FirebaseFirestore.instance.collection("users").get();
    data.docs.forEach((element) {
      Map user = element.data();

      userNameList.add(user['name']);
    });
    return userNameList;
  }

  Map<String, dynamic> LocalChatRoomMap = {};
  getChatRoomByChatRoomId(String chatRoomId) async {
    Map<String, dynamic> funcChatRoomMap = {};
    bool chatRoomFound = false;
    // getting all chatRoom collection and finding if the chatRoomId Exists
    final data = await FirebaseFirestore.instance.collection("chatRoom").get();
    data.docs.forEach((element) {
      Map<String, dynamic> chatRoomMap = element.data();
      if (chatRoomMap['chatRoomId'] == chatRoomId) {
        chatRoomFound = true;
        funcChatRoomMap = chatRoomMap;
      }
    });
    if (chatRoomFound) {
      LocalChatRoomMap = funcChatRoomMap;
    }
  }

  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomMap) async {
    // checking if the chatRoomId preexists
    await getChatRoomByChatRoomId(chatRoomId);
    // print(LocalChatRoomMap);
    // if clause
    if (LocalChatRoomMap.isEmpty) {
      FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(chatRoomId)
          .set(chatRoomMap)
          .catchError((e) {
        print(e.toString());
      });
    }
  }

  addConversationMessages(String chatRoomId, Map<String, dynamic> messageMap) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String? userName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
