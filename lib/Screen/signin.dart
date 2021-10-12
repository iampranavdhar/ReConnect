import 'package:ReConnect/Screen/signup.dart';
import 'package:ReConnect/services/authentication.dart';
import 'package:ReConnect/services/database.dart';
import 'package:ReConnect/services/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'Widgets/widgets.dart';
import 'chatroomscreen.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}


class _SignInState extends State<SignIn> {

  bool isLoading = false;
 
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  QuerySnapshot snapshotUserInfo;
  final formKey = GlobalKey<FormState>();

  signIn() {
    if (formKey.currentState.validate()) {

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      
      databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
      });

      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe8ebed), //Color(0xffd8c3e3) => Nice colour
      body: isLoading
          ? Container(
              child: Center(
                child: SpinKitRotatingCircle(
                  //Imported a package named flutterspinkit from pub.dev
                  color: Colors.deepPurpleAccent,
                  size: 50.0,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    70, //For moving according to the screen when the keyboard comeup.
                alignment: Alignment.center,
                child: Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 180,
                              width: 600,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/images/friendship.png",
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 60),

// From here the login Credentials start.

                        Form(
                          key: formKey,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffe1e2e3),
                                boxShadow: [
                                  BoxShadow(
                                      //For creating like a card.
                                      color: Colors.black12,
                                      offset: Offset(0.0, 15.0),
                                      blurRadius: 15.0),
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0.0, -10.0),
                                      blurRadius: 10.0),
                                ]),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      )),
                                      SizedBox(height: 5),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Color(0xfff5f8fd),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: TextFormField(
                                      validator: (val) {
                                        return RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(val)
                                            ? null
                                            : "Please enter a valid email adress";
                                      },
                                      controller: emailTextEditingController,
                                      decoration: InputDecoration(
                                        hintText: "Email",
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Color(0xfff5f8fd),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: TextFormField(
                                      obscureText: true,
                                      validator: (val) {
                                        return val.isEmpty || val.length < 6
                                            ? "Password length must contain minimum 6 characters."
                                            : null;
                                      },
                                      controller: passwordTextEditingController,
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.vpn_key,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),

                        SizedBox(
                          height: 25,
                        ),

                        Container(
                          alignment: Alignment.centerRight,
                          child: Container(
                              child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.w500),
                          )),
                        ),

                        SizedBox(height: 25),

//From here the signin buttons will occur.

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                                elevation: 3,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 50),
                                onPressed: () {
                                  signIn();
                                },
                                color: Colors
                                    .deepPurpleAccent, //Not bad=>Color(0xff1d56b8),
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.white70),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                )),
                            SizedBox(width: 10),
                            GestureDetector(
                              //Signin with google button.
                              onTap: () {
                                //I changed it from raised button to container and then added gesture control to add an image of google.
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Color(0xfff5f8fd),
                                    
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                            //Created this shadow for looking elevated.
                                            //For creating like a card.
                                            color: Colors.black12,
                                            offset: Offset(0.0,
                                                18.0), // This offset is for making the the lenght of the shadow and also the brightness of the black color try seeing it by changing its values.
                                            blurRadius: 15.0),
                                        BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(0.0, -04.0),
                                            blurRadius: 10.0),
                                      ]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // I had added main axis allignment to be center to make to be at the center.
                                    children: [
                                      Text(
                                        "Sign In With",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.deepPurpleAccent,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Image.asset(
                                        "assets/images/google.png",
                                        height: 40,
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),

                        SizedBox(height: 30),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?"),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  authMethods.signOut();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()));
                                },
                                child: Container(
                                  child: Text("Register now",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.deepPurpleAccent)),
                                ),
                              )
                            ]),
                      ],
                    )),
              ),
            ),
    );
  }
}
