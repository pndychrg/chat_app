import 'package:chat_app/main.dart';
import 'package:chat_app/screens/authenticate/sign_up.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //form key
  final formKey = new GlobalKey<FormState>();

  //authservice instance
  final AuthService _auth = AuthService();

  // TextFormField Controllers Setup
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  // boolean for loading option
  bool isLoading = false;

  // error specifier
  String errorText = '';
  // sign In function
  signInFunction() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      dynamic result = await _auth.signInEmailPassword(
          _emailController.text, _passwordController.text);

      if (result == null) {
        setState(() {
          isLoading = false;
        });
        setState(() {
          errorText = "Bad Credentials";
        });
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => MyApp()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Container(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
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
                                signInFunction();
                              },
                              child: Text("Sign In"),
                            ),
                          ),
                          // Container(
                          //   child: ElevatedButton(
                          //     onPressed: () {},
                          //     child: Text("Sign In with Google"),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    errorText,
                    style: TextStyle(color: Colors.red),
                  ),
                  Text("Don't have an account"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_) => SignUp()));
                    },
                    child: Text("Sign Up"),
                  ),
                ],
              ),
            ),
    );
  }
}
