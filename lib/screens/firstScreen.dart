// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:the_olx/screens/categories.dart';
import 'package:the_olx/screens/productByMe.dart';
import 'package:the_olx/screens/settings.dart';
import 'homepage.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int myIndex = 0;

  List<String> catList = [];
  List<Widget> screens = [HomePage(), Categories(), ProductsByMe(), MySettings()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[myIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              myIndex = value;
              print(myIndex);
            });
          },
          currentIndex: myIndex,
          backgroundColor: Colors.white,
          elevation: 15,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF3B2977),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(
            color: Color(0xFF3B2977),
          ),
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(EvaIcons.homeOutline),
            ),
            BottomNavigationBarItem(
              label: 'Categories',
              icon: Icon(EvaIcons.listOutline),
            ),
            BottomNavigationBarItem(
                label: 'My Ads', icon: Icon(EvaIcons.image2)),
            BottomNavigationBarItem(
                label: 'Settings', icon: Icon(EvaIcons.settings2)),
          ]),
    );
  }
}
