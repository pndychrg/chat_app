import 'package:cloud_firestore/cloud_firestore.dart';

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
  Stream<QuerySnapshot> get userDatabase {
    return userCollection.snapshots();
  }

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

  createChatRoom(String chatRoomID, Map<String, dynamic> chatRoomMap) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomID)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }
}
