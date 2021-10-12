import 'dart:io';
import 'package:ReConnect/services/constants.dart';
import 'package:ReConnect/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  Chat({this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  TextEditingController messageController = new TextEditingController();

  Stream <QuerySnapshot>chats;
  String chatRoomId;


  Widget chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, snapshot) {
          return snapshot.hasData? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                    return MessageTile(
                       message: snapshot.data.documents[index].data["message"],
                      sendByMe:Constants.myName == snapshot.data.documents[index].data["sendBy"]);
                  }):Container();
        });
  }


  sendMessage() async{
    //Here we are sending messages to the database i.e mapping with the keys named as message and send and and then we show this messages to in the conversation screen.
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time":DateTime
        .now()
        .millisecondsSinceEpoch
      };
      await DatabaseMethods().addMessages(widget.chatRoomId, messageMap);
    };
    setState(() {
      messageController.text =
          ""; //This is for once the user is clicked on the send button then the text in the text field must vanish
    });

    @override
    void initState() async {
      await DatabaseMethods().getMessages(widget.chatRoomId).then((value) {
        setState(() async {
          chats = value;
        });
      });
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Stack(
          children: [
          chatMessages(),
          Row(children: [
            Container(
            alignment: Alignment.bottomCenter,
            width: 330,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2,vertical: 15),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              decoration: BoxDecoration(
                  color: Color(0xffe3e4e6),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      child: Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Message",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
          SizedBox(width:5),
          Container(
            padding: EdgeInsets.symmetric(vertical:10),
            alignment: Alignment.bottomRight,
            child: InkWell(
                    //We can use the GestureDetector as well but it will have all the properties of the button but when when clicked it doen't seem like clicked.
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      child: Image.asset(
                        "assets/images/goodsend.png",
                        height: 55,
                      ),
                    ),
                  ),),
          ],),
          
        ]),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  MessageTile({@required this.message,@ required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:MediaQuery.of(context).size.width,
      alignment: sendByMe ? Alignment.centerRight :Alignment.centerLeft,
          child: Container(
        child: Text(
          message,
          style: TextStyle(color: Colors.deepOrange,fontSize: 100),
        ),
      ),
    );
  }
}
