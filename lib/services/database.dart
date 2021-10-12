import 'package:cloud_firestore/cloud_firestore.dart';


// This dart package is for writing the function for sending the data to the database. 
class DatabaseMethods{


  getUserByUsername(String username) async{                                                                 //This is for getting the details of the user by searching his name in the search box.And we use async for using await so that it waits util that process is completed.
     return await Firestore.instance
     .collection("users")
     .where("name", isEqualTo:username)
     .getDocuments(); //This is sending the query to the database saying that we only want the document where the name is to the name we had provided in the username.
  }

  getUserByUserEmail(String userEmail) async{                                                                 //This is for getting the details of the user by searching his name in the search box.And we use async for using await so that it waits util that process is completed.
     return await Firestore.instance
     .collection("users")
     .where("email", isEqualTo:userEmail)
     .getDocuments(); //This is sending the query to the database saying that we only want the document where the name is to the name we had provided in the username.
  }


  Future <void> uploadUserInfo(userMap){
    Firestore.instance
    .collection("users")
    .add(userMap)
    .catchError((e){
      print(e.toString());
          });

  }

  Future <bool> createChatRoom(chatRoom,chatRoomId){
    Firestore.instance
    .collection("ChatRoom")
    .document(chatRoomId)
    .setData(chatRoom)
    .catchError((e){
      print(e.toString());  // This catch error is nothing but if there is any error then we must know and as that might not be readable we are converting to the string.
    });
  }

  Future <bool> addMessages(String chatRoomId,messageMap) async {
   await  Firestore.instance
    .collection("chatRoom")
    .document(chatRoomId)
    .collection("chats")
    .add(messageMap).catchError((e){print(e.toString());});
  }

  getMessages(String chatRoomId) async{
    return  Firestore.instance
    .collection("chatRoom")
    .document(chatRoomId)
    .collection("chats")
    .orderBy("time",descending: false)
    .snapshots();
  }

  getChatRooms(String userName) async {
    return await Firestore.instance
    .collection("chatRoom")
    .where("users",arrayContains: userName)
    .snapshots();
  }
}


