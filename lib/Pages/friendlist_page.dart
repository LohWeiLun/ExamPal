import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: FriendsListPage(),
  ));
}

class Friend {
  final String name;

  Friend(this.name);
}

class FriendsListPage extends StatefulWidget {
  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  List<Friend> friends = [
    Friend('Friend 1'),
    Friend('Friend 2'),
    Friend('Friend 3'),
    Friend('Friend 4'),
    Friend('Friend 5'),
  ];
  TextEditingController _friendNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
        backgroundColor: Colors.blue,
      ),
      body: buildFriendsList(),
      floatingActionButton: buildAddFriendButton(),
    );
  }

  Widget buildFriendsList() {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            leading: CircleAvatar(
              // You can add custom profile pictures here if needed
              backgroundColor: Colors.blue,
              child: Text(friends[index].name[0]),
            ),
            title: Text(
              friends[index].name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget buildAddFriendButton() {
    return FloatingActionButton(
      onPressed: () => _showAddFriendDialog(),
      child: Icon(Icons.person_add),
      backgroundColor: Colors.blue,
    );
  }

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Friend'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _friendNameController,
                decoration: InputDecoration(labelText: 'Friend Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newFriendName = _friendNameController.text;
                if (newFriendName.isNotEmpty) {
                  setState(() {
                    friends.add(Friend(newFriendName));
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _friendNameController.dispose();
    super.dispose();
  }
}
