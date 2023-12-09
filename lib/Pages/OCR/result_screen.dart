import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Result'),
      // actions: [
      //   IconButton(onPressed: () {}, icon: Icon(Icons.picture_as_pdf),),
      // ],
    ),
    body: Container(
      padding: const EdgeInsets.all(30.0),
      child: Text(text),
    ),
  );
}

