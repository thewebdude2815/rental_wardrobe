// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:the_olx/logic/dataController.dart';
import 'package:the_olx/screens/conversation.dart';

import '../logic/firestoreFunctions.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  void initState() {
    getname();
    super.initState();
  }

  String names = '';

  getname() async {
    String myName = await DataController().getUserName();

    setState(() {
      names = myName;
    });
    print(names);
    return names;
  }

  Widget chatRoomDisplayes() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatRooms')
          .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var chatRoomCount = snapshot.data!.docs;
          if (chatRoomCount.isEmpty) {
            return Center(
              child: Lottie.asset('images/msg.json', height: 250),
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height * 1,
              child: ListView.builder(
                  itemCount: chatRoomCount.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return Conversation(
                                uploaderImage: chatRoomCount[index]
                                    ['uploaderImage'],
                                chattieName: names,
                                chatPersonName: chatRoomCount[index]
                                        ['userNames']
                                    .toString()
                                    .replaceAll("_", "")
                                    .replaceAll(names, ""),
                                chatRoomId: chatRoomCount[index]['chatRoomId'],
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                child: chatRoomCount[index]
                                            ['chatInitiatedBy'] ==
                                        names
                                    ? Image.network(
                                        chatRoomCount[index]['uploaderImage'],
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        chatRoomCount[index]['clientImage'],
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              chatRoomCount[index]['userNames']
                                  .toString()
                                  .replaceAll("_", "")
                                  .replaceAll(names, ""),
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(EvaIcons.arrowBackOutline)),
                    Text(
                      'Your Messages',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox()
                  ],
                ),
              ),
              chatRoomDisplayes()
            ],
          ),
        ),
      ),
    );
  }
}
