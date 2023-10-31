
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePagaState createState() => _SchedulePagaState();
}

class _SchedulePagaState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text("Theme Data",
            style: TextStyle(
                fontSize: 30
            ),
          )
        ],
      ),

    );
  }
}