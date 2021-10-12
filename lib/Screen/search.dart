import 'package:ReConnect/Screen/Widgets/widgets.dart';
import 'package:ReConnect/Screen/conversationscreen.dart';
import 'package:ReConnect/services/constants.dart';
import 'package:ReConnect/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot searchSnapshot;
  bool isLoading=false;

  initiateSearch() async {

    if(searchTextEditingController.text.isNotEmpty){
      
    
    await databaseMethods.getUserByUsername(searchTextEditingController.text).then((val) {
      print("$searchSnapshot");
      setState(() {
        searchSnapshot = val;
      });
    });
  }
  }

   Widget searchList() {
    //This widget is for getting the search list below the search bar when we type it in the search bar.
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal:20,vertical:3),
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(30),
                ),
                              child: SearchTile(
                  searchSnapshot.documents[index].data["userName"],
                  searchSnapshot.documents[index].data["userEmail"],
                ),
              );
            })
        : Container();
  }

  @override
  void initState(){
    super.initState();
  }

  createChatroomAndStartTalking(String userName){

    if(userName != Constants.myName){

      List<String> users=[Constants.myName,userName];
      String chatRoomId = getChatRoomId(Constants.myName,userName);
      
    

      Map<String, dynamic> chatRoom = {
        "users"  : users,
        "chatRoomId" : chatRoomId
      };

    databaseMethods.createChatRoom(chatRoom,chatRoomId);  //This is for once the user is clicked on the search then the text in the text field must vanish

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => Chat(
        chatRoomId:chatRoomId,
      )
      ));
    }
    else{
      print("You can not send Message to yourself.");
    }
  }



  Widget SearchTile(String userName,String userEmail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal:10,vertical:10),
      decoration: BoxDecoration(                         
        color:Colors.indigo,                           
        shape: BoxShape.rectangle,
      ),
      child: Row(
        children: [
          Expanded(
                      child: Container(
                        child: Container(
                          child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName,
                    style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),),
                    SizedBox(height: 5,),
                    Text(userEmail) // Here the text is not fixed it changes according to the user we are searching for.
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          InkWell(
            onTap:(){
              createChatroomAndStartTalking(
              userName
            );
            } ,
                      child: Container(
              child:Text("Message",style:TextStyle(fontSize: 15)),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            ),
          )
        ],
      ),
    );
  }


  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading? 
      Container(
        child: Center(child:CircularProgressIndicator()),)
      :Container(
        child: Column(children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            decoration: BoxDecoration(
                color: Color(0xffe3e4e6),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                Expanded(
                                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  //We can use the GestureDetector as well but it will have all the properties of the button but when when clicked it doen't seem like clicked.
                  onTap: () {
                    initiateSearch();
                  },
                  
                  child: Container(
                    height: 45,
                    width: 45,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffd0d3d9),
                        boxShadow: [
                          BoxShadow(
                              //For creating like a card.
                              color: Colors.black12,
                              offset: Offset(0.0, 15.0),
                              blurRadius: 15.0),
                        ]),
                    child: Image.asset("assets/images/search_white.png"),
                  ),
                )
              ],
            ),
          ),
          Expanded(child: Container(child: searchList()))
        ]),
      ),
    );
  }
}



