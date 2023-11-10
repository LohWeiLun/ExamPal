import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: FriendsListPage(),
  ));
}

class Friend {
  final String name;

  Friend(this.name);
}

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({super.key});

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
  final TextEditingController _friendNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends List'),
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
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            leading: CircleAvatar(
              // You can add custom profile pictures here if needed
              backgroundColor: Colors.blue,
              child: Text(friends[index].name[0]),
            ),
            title: Text(
              friends[index].name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget buildAddFriendButton() {
    return FloatingActionButton(
      onPressed: () => _showAddFriendDialog(),
      backgroundColor: Colors.blue,
      child: const Icon(Icons.person_add),
    );
  }

  void _showAddFriendDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Friend'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _friendNameController,
                decoration: const InputDecoration(labelText: 'Friend Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
              child: const Text('Add'),
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
