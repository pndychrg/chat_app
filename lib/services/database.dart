import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  //updating the user data
  Future updateUserData(String uID, Map userInfoMap) async {
    return await userCollection.doc(uID).set(userInfoMap);
  }
}
