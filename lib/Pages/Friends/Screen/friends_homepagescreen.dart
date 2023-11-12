import 'package:exampal/Pages/Friends/Page/chatpage.dart';
import 'package:exampal/Pages/Friends/Screen/cameraScreen.dart';
import 'package:flutter/material.dart';

class FriendsHomescreen extends StatefulWidget {
  FriendsHomescreen({Key? key}) : super(key: key);

  @override
  _FriendsHomescreenState createState() => _FriendsHomescreenState();
}

class _FriendsHomescreenState extends State<FriendsHomescreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ExamPal"),
        actions: [
          IconButton(onPressed: () {/*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CameraScreen()),
          );*/}, icon: Icon(Icons.camera_alt)),
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          PopupMenuButton<String>(
            onSelected: (value){
              print(value);
            },
            itemBuilder: (BuildContext context){
            return[
              PopupMenuItem(child: Text("New Group"), value: "New Group",),
              PopupMenuItem(child: Text("New broadcast"), value: "New broadcast",),
              PopupMenuItem(child: Text("Starred Message"), value: "Starred Message",),
            ];
          },),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              icon: Icon(Icons.groups_3),
            ),
            Tab(
              text: "Chats",
            ),
            Tab(
              text: "Updates",
            ),
            Tab(
              text: "CALLS",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          CameraScreen(),
          ChatPage(),
          Text("Updates"),
          Text("calls"),
        ],
      ),
    );
  }
}
