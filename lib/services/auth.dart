import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // create user object based on firebase user
  LocalUser? _createlocalUser(User? user) {
    return user != null
        ? LocalUser(uID: user.uid, email: user.email, name: user.displayName)
        : null;
  }

  // auth change user stream
  Stream<LocalUser?> get user {
    return _auth.authStateChanges().map((User? user) => _createlocalUser(user));
  }

  //sign in annon
  // Future signInAnnon() async {
  //   try {
  //     UserCredential result = await _auth.signInAnonymously();
  //     User? user = result.user;

  //     return _createlocalUser(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  //sign in with email & password
  Future signInEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return _createlocalUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  //register with email& password
  Future signUpWithEmailPass(
      String email, String password, String userName) async {
    try {
      UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        result.user?.updateDisplayName(userName);

        return result;
      });

      User? user = result.user;
      user?.updateDisplayName(userName);
      return _createlocalUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
