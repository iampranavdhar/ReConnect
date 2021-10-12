import 'package:ReConnect/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ReConnect/Screen/conversationscreen.dart';

class AuthMethods{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){
    return user !=null ?  User(uid:user.uid): null; //TRUE:FAlSE => This means if the given statement is true then first statement is executed other wise second one will be executed
  }

  Future signInWithEmailAndPassword(String email, String password) async {

    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);

      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
  } catch (e) {
    print(e.toString());
    return null;
  } //If we don't use try and catch if the pass and email doesn't match it causes errors and app may close and may experience issues so we use this.

  } 

  Future SignUpwithEmailandPassword(String email,String password) async{
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email)async{
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async{
    try {
      return await _auth.signOut();
    } catch (e) {
    }
  }
}