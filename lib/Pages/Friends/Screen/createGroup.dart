import 'package:exampal/Pages/Friends/CustomUI/AvatarCard.dart';
import 'package:exampal/Pages/Friends/CustomUI/buttonCard.dart';
import 'package:flutter/material.dart';
import 'package:exampal/Models/chatModel.dart';
import '../CustomUI/contactCard.dart';

class CreateGroup extends StatefulWidget {
  CreateGroup({Key? key}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<ChatModel> contacts = [
    ChatModel(name: "Dev Stack", status: "A full stack developer"),
    ChatModel(name: "Balram", status: "Flutter Developer..........."),
    ChatModel(name: "Saket", status: "Web developer..."),
    ChatModel(name: "Bhanu Dev", status: "App developer...."),
    ChatModel(name: "Collins", status: "Raect developer.."),
    ChatModel(name: "Kishor", status: "Full Stack Web"),
    ChatModel(name: "Testing1", status: "Example work"),
    ChatModel(name: "Testing2", status: "Sharing is caring"),
    ChatModel(name: "Divyanshu", status: "....."),
    ChatModel(name: "Helper", status: "Love you Mom Dad"),
    ChatModel(name: "Tester", status: "I find the bugs"),
  ];

  List<ChatModel> groups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Group",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Add Participants",
                style: TextStyle(
                  fontSize: 13,
                ),
              )
            ],
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.search,
                  size: 26,
                ),
                onPressed: () {}),
            PopupMenuButton<String>(
              padding: EdgeInsets.all(0),
              onSelected: (value) {
                print(value);
              },
              itemBuilder: (BuildContext contesxt) {
                return [
                  PopupMenuItem(
                    child: Text("Invite a friend"),
                    value: "Invite a friend",
                  ),
                  PopupMenuItem(
                    child: Text("Contacts"),
                    value: "Contacts",
                  ),
                  PopupMenuItem(
                    child: Text("Refresh"),
                    value: "Refresh",
                  ),
                  PopupMenuItem(
                    child: Text("Help"),
                    value: "Help",
                  ),
                ];
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            ListView.builder(
                itemCount: contacts.length+1,
                itemBuilder: (context, index) {
                  if(index==0){
                    return Container(
                      height: groups.length > 0 ? 90 : 10,
                    );
                  }
                  return InkWell(
                    onTap: () {
                      if (contacts[index-1].select == false) {
                        setState(() {
                          contacts[index-1].select = true;
                          groups.add(contacts[index-1]);
                        });
                      } else {
                        setState(() {
                          contacts[index-1].select = false;
                          groups.remove(contacts[index-1]);
                        });
                      }
                    },
                    child: ContactCard(
                      contact: contacts[index-1],
                    ),
                  );
                }),
            groups.length > 0? Column(
              children: [
                Container(
                  height: 75,
                  color: Colors.white,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: contacts.length,
                      itemBuilder: (context, index){
                        if(contacts[index].select == true){
                          return InkWell(
                            onTap: () {
                              setState(() {
                                contacts[index].select = false;
                                groups.remove(contacts[index]);
                              });
                            },
                              child: AvatarCard(contact: contacts[index],));
                        }
                        else{
                          return Container();
                        }
                      }),
                ),
                Divider(
                  thickness: 1,
                ),
              ],
            ):Container(),
          ],
        ));
  }
}
