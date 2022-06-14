import 'package:chat_app/main.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/screens/authenticate/sign_in.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // Authenticate service
  final AuthService _auth = AuthService();
  // database service
  final DatabaseMethods _databaseMethods = DatabaseMethods();

  //form key
  final formKey = new GlobalKey<FormState>();

  // TextFormField Controllers Setup
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  // boolean for loading option
  bool isLoading = false;

  // error specifier
  String errorText = '';
  signUpFunction() async {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic> userInfoMap = {
        "name": _usernameController.text,
        "email": _emailController.text,
      };
      setState(() {
        isLoading = true;
      });

      dynamic result = await _auth.signUpWithEmailPass(
          _emailController.text, _passwordController.text);

      if (result == null) {
        setState(() {
          isLoading = false;
        });
        setState(() {
          errorText = "Error Occured";
        });
      } else {
        _databaseMethods.updateUserData(result.uID, userInfoMap);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => MyApp()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //screen size
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Messanging App"),
      ),
      body: isLoading
          ? Container(
              child: SpinKitSpinningLines(
                color: Colors.blue,
                size: 70,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //form
                  Card(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: ((value) {
                              return value!.isEmpty || value.length < 2
                                  ? "Invalid Username"
                                  : null;
                            }),
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: "Enter UserName",
                            ),
                          ),
                          TextFormField(
                            validator: (val) {
                              if (val != null) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Please Provide a valid Email ID";
                              } else {
                                return null;
                              }
                            },
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: "Enter Email here",
                            ),
                          ),
                          TextFormField(
                            validator: (val) {
                              return val!.length > 6
                                  ? null
                                  : "Please Provide Password with 6+ character";
                            },
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Password",
                            ),
                          ),
                          Container(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                signUpFunction();
                              },
                              child: Text("Sign Up"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text("Already have an account"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_) => SignIn()));
                    },
                    child: Text("Sign In"),
                  ),
                  Text(
                    errorText,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
    );
  }
}
