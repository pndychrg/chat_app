import 'package:chat_app/models/user.dart';
import 'package:chat_app/screens/authenticate/authenticate.dart';
import 'package:chat_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<LocalUser?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home(
        currentUser: user,
      );
    }
  }
}
