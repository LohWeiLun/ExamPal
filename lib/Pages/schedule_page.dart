
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
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: const Color(0xffecf1f2),
          color: Color(0xffc1e1e9),
          animationDuration: Duration(milliseconds: 300),
          onTap: (index){
            print(index);
          },
          items: [
            Icon(
              Icons.group,
              color: Colors.black87,
            ),
            Icon(
              Icons.add,
              color: Colors.black87,
            ),
            Icon(
              Icons.person,
              color: Colors.black87,
            ),
          ],
        ),
        body: Column(
          children: [
            Text("Theme Data",
              style: TextStyle(
                  fontSize: 30
              ),
            )
          ],
        )
    );
  }
}