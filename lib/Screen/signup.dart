import 'package:ReConnect/Screen/chatroomscreen.dart';
import 'package:ReConnect/Screen/signin.dart';
import 'package:ReConnect/services/authentication.dart';
import 'package:ReConnect/services/database.dart';
import 'package:ReConnect/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'Widgets/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();

  signMeUp() {
    if (formKey.currentState.validate()) {

      Map<String, String> userInfoMap = {
        "name" : userNameTextEditingController.text,  //This map is for sending the data to the database and map the values in the textfield to the keys.(here email and username)
        "email" : emailTextEditingController.text,    // And this must be adiding before the isloading state only as the is loading screen comes the textfield screen removes and so it considers as blank fields and doesnt upload in the database.
      };

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);


      
      setState(() {
        isLoading = true;
      });

      authMethods.SignUpwithEmailandPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) => print("${val.uid}"));

      databaseMethods.uploadUserInfo(userInfoMap);
      HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom() ));
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Container(
              child: Center(
                child: SpinKitRotatingCircle(          //Imported a package named flutterspinkit from pub.dev
                  color: Colors.deepPurpleAccent,
                  size: 50.0,
                ),
              ),
            )
          : SingleChildScrollView(                             //Here we are writing this singleChildScrollview bcz when we click on the textfield keyboard appears and then textfield will not be visible so we are adding this so that we can scroll.
              child: Container(
                height: MediaQuery.of(context).size.height - 0, // If you get any blur that is outoff the screen then try to decrease or increase this negative value.This is mainly bcz it adjusts as per the phone size.
                alignment: Alignment.topCenter,
                child: Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Stack(                         //I added stack so that i can position it anywhere i want with the coordinates like left ,right,bottom.
                                children: <Widget>[
                                  Positioned(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        "assets/images/talking.png",
                                      ),
                                    ),
                                  ),
                                ],
                              ),


// From here  the Username,Email,Password Input field Starts.
// And in  middle we added some sizedboxes in the project so as to make it seperated and look good.

                              SizedBox(height: 20),

                              Container(                                          //And that total username,email,paasword i had kept it in a single container so that i can i can make it like a single card like structure.
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xffebe9e4),
                                    boxShadow: [                                  //Here for the box shadow we had created square brackets we can can make two different shadows for uo an down.
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
                                child: Column(                                 //And i had kept these in the column so that i can they come one by one in the column form.
                                  children: [

                                    Container(                                 // And then for each email,username,password i had kept in seperate container for providing hint text and some padding and some other stuff.
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: Color(0xfff5f8fd),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: TextFormField(
                                        validator: (val) {
                                          //This is for seeing weather the text field is empty or filled with the required conditions like greater than 3 words like that.
                                          return val.isEmpty || val.length <= 3
                                              ? "Please Provide Username"
                                              : null;
                                        },
                                        controller:
                                            userNameTextEditingController, //For contol of the text we are typing
                                        decoration: InputDecoration(
                                            hintText: "Username",
                                            border: InputBorder.none),
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
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
                                              : "Please enter a valid email adress"; //This is copied and we may not remember.
                                        },
                                        controller:
                                            emailTextEditingController, //For contol of the text we are typing
                                        decoration: InputDecoration(
                                            hintText: "Email",
                                            border: InputBorder.none),
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
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
                                        controller:
                                            passwordTextEditingController, //For contol of the text we are typing
                                        decoration: InputDecoration(
                                            hintText: "Password",
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 30),

//From here the Raised Buttons of sigup will appear.

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                                elevation: 13,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 55),
                                onPressed: () {
                                  signMeUp();
                                },
                                color: Colors.deepPurpleAccent,
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.white70),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            SizedBox(width: 5),


                            GestureDetector(
                              onTap: () {                                              //I changed it from raised button to container and then added gesture control to add an image of google.
                                
                              },
                                                          child: Container(
                                padding: EdgeInsets.symmetric(
                                            horizontal: 10,vertical: 5),
                                        decoration: BoxDecoration(
                                            color: Color(0xfff5f8fd),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                                boxShadow: [
                          BoxShadow(                                             //Created this shadow for looking elevated.
                              //For creating like a card.
                              color: Colors.black12,
                              offset: Offset(0.0, 18.0),                        // This offset is for making the the lenght of the shadow and also the brightness of the black color try seeing it by changing its values.
                              blurRadius: 15.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -04.0),
                              blurRadius: 10.0),
                        ]),
                                
                                child:Row(children: [
                                  Text("Sign Up With",style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.deepPurpleAccent,
                                        fontWeight: FontWeight.w700),),
                                  Image.asset("assets/images/google.png",height: 40,)
                                ],)
                              ),
                            )
                          ],
                        ),

//From here ending text of already have an account starts.


                        SizedBox(height: 25),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account?"),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap:(){
                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                    builder:(context) => SignIn() ));
                                },
                                                              child: Container(
                                                                child: Text("Sign In",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.deepPurpleAccent,
                                          fontSize: 18)),
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
