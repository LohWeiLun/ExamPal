import 'package:exampal/Widgets/post_card.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget{
  const FeedScreen({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Image.asset(
          "assets/logo/exampalLogo.png",
          height: 32,
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.messenger_outline,color:Colors.black87))
        ],
      ),
      body: const PostCard(),
    );
  }
}