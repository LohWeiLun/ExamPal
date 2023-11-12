import 'package:exampal/Models/chatModel.dart';
import 'package:exampal/Pages/Friends/CustomUI/customcard.dart';
import 'package:exampal/Pages/Friends/Screen/selectContact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChatPage extends StatefulWidget{
  const ChatPage ({Key? key}) : super (key: key);



  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{

  List<ChatModel> chats = [
    ChatModel(
      name: "Dev Stack",
      isGroup: false,
      currentMessage: "Hi Everyone",
      time: "04:00",
      icon: "assets/icons/person.svg",
    ),
    ChatModel(
      name: "MonkeyD",
      isGroup: false,
      currentMessage: "Hi Gais",
      time: "13:15",
      icon: "assets/icons/person.svg",
    ),
    ChatModel(
      name: "HuiYi",
      isGroup: true,
      currentMessage: "Hi Wei Lun",
      time: "11:10",
      icon: "assets/icons/groups.svg",
    ),
    ChatModel(
      name: "WeiLun",
      isGroup: true,
      currentMessage: "Hi Hui Yi",
      time: "12:30",
      icon: "assets/icons/groups.svg",
    ),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (builder)=> SelectContact()));
      },child: Icon(Icons.chat),),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (contex,index)=>CustomCard(chatModel: chats[index],),
      ),
    );
  }
}