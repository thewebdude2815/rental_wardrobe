// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_olx/screens/editAccount.dart';
import 'package:the_olx/screens/landingpage.dart';
import 'package:the_olx/screens/splashScreen.dart';

import '../logic/authFunctions.dart';
import '../logic/dataController.dart';

class Profile extends StatefulWidget {
  List dataReceieved;
  Profile({required this.dataReceieved});
  // String name;
  // String email;
  // String number;
  // Profile({required this.name, required this.email, required this.number});
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var myMenuItems = <String>[
    'Edit Account',
    'Logout',
    'Delete Account',
  ];

  void onSelect(item) {
    switch (item) {
      case 'Edit Account':
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return EditAccount(
            number: widget.dataReceieved[2],
            role: widget.dataReceieved[6],
            imgUrl: widget.dataReceieved[3],
            userName: widget.dataReceieved[0],
            email: widget.dataReceieved[1],
            gender: widget.dataReceieved[4],
            userid: widget.dataReceieved[5],
          );
        }));
        break;
      case 'Logout':
        FirebaseAuth.instance.signOut().whenComplete(() {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return LandingPage();
          }));
        });
        break;
      case 'Delete Account':
        _onDeleteAlert();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  backgroundColor: Colors.white,
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(EvaIcons.arrowBackOutline)),
                  Center(
                    child: Text(
                      'Profile',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  PopupMenuButton<String>(
                      offset: Offset.zero,
                      onSelected: onSelect,
                      itemBuilder: (BuildContext context) {
                        return myMenuItems.map((String choice) {
                          return PopupMenuItem<String>(
                            child: Text(choice),
                            value: choice,
                          );
                        }).toList();
                      })
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // color: Color(0xFF3B2977).withOpacity(0.2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.dataReceieved[3]),
                    radius: 70,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.dataReceieved[0],
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height * 0.09,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF3B2977).withOpacity(0.7),
              ),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Icon(
                    EvaIcons.emailOutline,
                    color: Colors.white,
                  ),
                  SizedBox(width: 50),
                  Text(
                    widget.dataReceieved[1],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height * 0.09,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF3B2977).withOpacity(0.7),
              ),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Icon(
                    EvaIcons.homeOutline,
                    color: Colors.white,
                  ),
                  SizedBox(width: 50),
                  Text(
                    widget.dataReceieved[7],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height * 0.09,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF3B2977).withOpacity(0.7),
              ),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Icon(
                    EvaIcons.phoneCallOutline,
                    color: Colors.white,
                  ),
                  SizedBox(width: 50),
                  Text(
                    '+${widget.dataReceieved[2]}',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height * 0.09,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF3B2977).withOpacity(0.7),
              ),
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Icon(
                    EvaIcons.person,
                    color: Colors.white,
                  ),
                  SizedBox(width: 50),
                  Text(
                    widget.dataReceieved[4],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  _onDeleteAlert() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "WARNING!",
      desc:
          "Deleting Your Profile Will Delete Your Products & Renting Products.",
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            await deleteAccount().then((value) {
              print('Deleted');
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return LandingPage();
              }));
            });
          },
          color: Colors.red,
        )
      ],
    ).show();
  }
}
