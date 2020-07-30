import 'package:easy_interfone/HomeAdmin.dart';
import 'package:easy_interfone/Login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomeAdmin(),
    theme: ThemeData(
      primaryColor: Color(0xff00008B),
      accentColor: Color(0xff00008B)
    ),
    debugShowCheckedModeBanner: false,
  ));
}

