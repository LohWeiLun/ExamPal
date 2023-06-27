import 'package:flutter/material.dart';

const Color lightBlue1 = Color(0xffecf1f2);
const Color lightBlue2 = Color(0xffc1e1e9);

const primaryClr = lightBlue2;

class Themes{
  static final light = ThemeData(
      primaryColor: primaryClr,
      scaffoldBackgroundColor: lightBlue1,
      brightness: Brightness.light
  );

  static final dark = ThemeData(
      primaryColor: Colors.blue,
      brightness: Brightness.dark
  );

}