import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Page'),
      ),
      body: ListView(
        children: const [
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

  const PostCard({super.key, required this.username, required this.image, required this.likes, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(username),
          ),
          Image.asset(image),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: Text('$likes likes'),
          ),
          ListTile(
            leading: const Icon(Icons.comment),
            title: Text('$comments comments'),
          ),
          // Add more features like 'Like' and 'Comment' buttons
        ],
      ),
    );
  }
}
