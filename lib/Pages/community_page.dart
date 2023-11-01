import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Page'),
      ),
      body: ListView(
        children: [
          PostCard(
            username: 'user1',
            image: 'assets/post1.jpg',
            likes: 53,
            comments: 12,
          ),
          PostCard(
            username: 'user2',
            image: 'assets/post2.jpg',
            likes: 37,
            comments: 8,
          ),
          // Add more PostCard widgets for additional posts
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String username;
  final String image;
  final int likes;
  final int comments;

  PostCard({required this.username, required this.image, required this.likes, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(username),
          ),
          Image.asset(image),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('$likes likes'),
          ),
          ListTile(
            leading: Icon(Icons.comment),
            title: Text('$comments comments'),
          ),
          // Add more features like 'Like' and 'Comment' buttons
        ],
      ),
    );
  }
}
