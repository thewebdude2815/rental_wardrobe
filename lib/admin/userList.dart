// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_olx/admin/userInformation.dart';
import 'package:the_olx/logic/dataController.dart';
import 'package:the_olx/screens/landingpage.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(EvaIcons.arrowBackOutline)),
                    Text(
                      'User List',
                      style: TextStyle(fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return LandingPage();
                          }));
                        });
                      },
                      child: Icon(EvaIcons.logOutOutline),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('role', isEqualTo: 'user')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      final userCount = snapshot.data!.docs;
                      return Container(
                        height: 900,
                        child: ListView.builder(
                          itemCount: userCount.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return UserInformation(
                                      uid: userCount[index]['uid'],
                                      userAddress: userCount[index]['address'],
                                      userGender: userCount[index]['gender'],
                                      userImage: userCount[index]['imageUrl'],
                                      userName: userCount[index]['name'],
                                      userPhone:
                                          userCount[index]['number'].toString(),
                                      userEmail: userCount[index]['email']);
                                }));
                              },
                              child: Container(
                                height: 80,
                                margin: EdgeInsets.only(bottom: 10),
                                child: Card(
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          userCount[index]['imageUrl'],
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text(userCount[index]['name'])
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
