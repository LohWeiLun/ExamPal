
import 'package:provider/provider.dart';
import 'package:exampal/Models/user.dart' as model;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MobileScreenLayout extends StatefulWidget{
  const MobileScreenLayout({Key? key}) : super(key:key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('This is Mobile'),
      ),
    );
  }
}
