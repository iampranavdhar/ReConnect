import 'package:ReConnect/Screen/conversationscreen.dart';
import 'package:ReConnect/Screen/search.dart';
import 'package:ReConnect/Screen/signin.dart';
import 'package:ReConnect/services/authentication.dart';
import 'package:ReConnect/services/constants.dart';
import 'package:ReConnect/services/database.dart';
import 'package:ReConnect/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();

  Stream chatRooms;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRooms,
      builder: (context,snapshot){
        
        return snapshot.hasData
        ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          shrinkWrap: true,
          itemBuilder:(context,index){
            return ChatRoomTile(
              userName:snapshot.data.documents[index].data["chatroomId"].toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),      //This tostring replace method is for making the username_usename2 to username2 i.e showing only the person who sended the message but not our name.
            chatRoomId:snapshot.data.documents[index].data["chatroomId"]);
        }): Container();
      },
    );
  }


  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getChatRooms(Constants.myName).then((value){
    setState(() {
      setState(() {
        chatRooms=value;
      });
    });
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions:[
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=> SignIn()
              ));
            } ,
                      child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: Container(child: chatRoomList()),
        
  bottomNavigationBar: CurvedNavigationBar(                      // Got the package named as the Curved Navigation bar from th epub.dev
    height:45,
    color: Colors.cyan,
    buttonBackgroundColor: Colors.amber,
    backgroundColor: Colors.blueAccent,
    items: <Widget>[
      Icon(Icons.add, size: 30),
    ],
    onTap: (index) {
       Navigator.push(context, MaterialPageRoute(
            builder:(context) => SearchScreen()));
    },
  ),

    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String chatRoomId;
  final String userName;
  ChatRoomTile({this.userName,this.chatRoomId});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,MaterialPageRoute(
          builder: (context) => Chat(chatRoomId:chatRoomId)));
      },
          child: Container(
        child: Row(
          children: [
            Center(
                          child: Container(
                height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(userName.substring(0, 1),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                         // fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300)),
              ),
            ),
            SizedBox(width:8),
            Text(userName,
            style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                         // fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300)
            ),
          ],),
        
      ),
    );
  }
}
