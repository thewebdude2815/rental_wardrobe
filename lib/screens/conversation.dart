// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../logic/firestoreFunctions.dart';
import '../logic/pickImage.dart';

class Conversation extends StatefulWidget {
  // String person0Number;
  // String person1Number;
  String uploaderImage;
  String chatPersonName;
  String chatRoomId;
  String chattieName;
  Conversation(
      {required this.uploaderImage,
      required this.chattieName,
      required this.chatPersonName,
      required this.chatRoomId});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController messageC = TextEditingController();
  Uint8List? _image;
  bool imgStatus = false;
  void selectImage() async {
    Uint8List? _img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = _img;
      imgStatus = true;
    });
  }

  Widget messageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(widget.chatRoomId)
          .collection('chats')
          .orderBy('timeSent')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final messageCount = snapshot.data!.docs;

          if (messageCount.isEmpty) {
            return Container(
              child: Center(child: Text('No Messages Found')),
            );
          } else {
            return ListView.builder(
              itemCount: messageCount.length,
              itemBuilder: (context, index) {
                if (messageCount[index]['type'] == "text") {
                  return MessageTile(
                    message: messageCount[index]['message'],
                    sentByMe:
                        messageCount[index]['sentBy'] == widget.chattieName,
                  );
                } else if (messageCount[index]['type'] == "image") {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: 200,
                    width: 150,
                    alignment: Alignment.centerRight,
                    child: CachedNetworkImage(
                      imageUrl: messageCount[index]['message'],
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          }
        }
      },
    );
  }

  sendMessage() {
    if (messageC != null && imgStatus == false) {
      sendAMessageFunction(widget.chatRoomId, messageC.text, widget.chattieName,
              "text", _image)
          .catchError((e) {
        print('Some Other Error');
      });
      messageC.text = "";
      setState(() {
        _image = null;
        imgStatus = false;
      });
    } else if (messageC != null && imgStatus == true) {
      sendAMessageFunction(widget.chatRoomId, messageC.text, widget.chattieName,
              "image", _image)
          .catchError((e) {
        print('Some Error');
      });
      messageC.text = "";
      setState(() {
        _image = null;
        imgStatus = false;
      });
    }
  }

  @override
  void initState() {
    setState(() {
      messageList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3B2977),
        title: Text(widget.chatPersonName),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: messageList(),
              ),
              SizedBox(
                height: 30,
              ),
              Positioned(
                // bottom: 0,
                // left: 0,
                // right: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  // color: Color(0xFF3B2977),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: Container(
                            child: Icon(
                              EvaIcons.image,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      _image != null
                          ? Expanded(
                              flex: 4,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: MemoryImage(_image!)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            )
                          : Expanded(
                              flex: 4,
                              child: TextField(
                                controller: messageC,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Type Something!',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF3B2977)),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: const Icon(
                          EvaIcons.arrowUpwardOutline,
                          color: Colors.black,
                          size: 35,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  String message;
  bool sentByMe;
  MessageTile({required this.message, required this.sentByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        decoration: BoxDecoration(
            color: sentByMe ? Colors.blue : Color.fromARGB(255, 92, 92, 92),
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          message,
          style: TextStyle(fontSize: 17, color: Colors.white),
        ),
      ),
    );
  }
}
