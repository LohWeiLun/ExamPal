import 'package:flutter/material.dart';

const poppins = "poppins";
const poppinbold = "poppins_bold";

TextStyle textStyle({color = Colors.black87,double? size = 16, font = poppinbold}){
  return TextStyle(
    fontFamily: font,
    color: color,
    fontSize: size,
  );
}