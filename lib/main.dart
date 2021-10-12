import 'package:ReConnect/services/helper.dart';
import 'package:flutter/material.dart';
import 'Screen/chatroomscreen.dart';
import 'Screen/signin.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  bool userLoggedIn;
  @override
  void initState() {
     getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
      userLoggedIn = value;
    });
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      debugShowCheckedModeBanner: false,
      home: userLoggedIn != null ? ChatRoom() : SignIn());
  }
}


 