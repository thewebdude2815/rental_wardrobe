// ignore_for_file: prefer_const_constructors

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/logic/dataController.dart';
import 'package:the_olx/screens/conversation.dart';
import 'package:the_olx/screens/rentProductForm.dart';

import '../logic/firestoreFunctions.dart';

class SingleProductUser extends StatefulWidget {
  String productName;
  String productDescription;
  String productPrice;
  String productImage;
  String uploadedBy;
  String category;
  bool onRent;
  bool rentTimeCompleted;
  String ratings;
  String uploaderImage;
  String productId;
  String userId;
  SingleProductUser(
      {required this.userId,
      required this.ratings,
      required this.productId,
      required this.productDescription,
      required this.productImage,
      required this.productName,
      required this.productPrice,
      required this.uploadedBy,
      required this.category,
      required this.onRent,
      required this.rentTimeCompleted,
      required this.uploaderImage});
  @override
  State<SingleProductUser> createState() => _SingleProductUserState();
}

class _SingleProductUserState extends State<SingleProductUser> {
  createChatroomAndStartConvo() async {
    String myUserId = FirebaseAuth.instance.currentUser!.uid;
    var currentUserName = await DataController().getUserName();
    var currentUserImage = await DataController().currentUserImage();
    dynamic chatRoomId = getChatRoomId(widget.userId, myUserId);
    List<String> users = [widget.userId, myUserId];
    List<String> userIds = [widget.uploadedBy, currentUserName];
    String userNames = getChatRoomId(widget.uploadedBy, currentUserName);
    Map<String, dynamic> chatRoomMap = {
      "chatInitiatedBy": currentUserName,
      "clientImage": currentUserImage,
      "uploaderImage": widget.uploaderImage,
      "users": users,
      "chatRoomId": chatRoomId,
      "userIds": userIds,
      "userNames": userNames
    };
    createChatRoom(
      chatRoomId,
      chatRoomMap,
    );
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return Conversation(
        uploaderImage: widget.uploaderImage,
        chattieName: currentUserName,
        chatRoomId: chatRoomId,
        chatPersonName: widget.uploadedBy,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(EvaIcons.arrowBackOutline)),
                    Text(
                      '${widget.productName}'.toUpperCase(),
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Color(0xFF3B2977)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Rs ${widget.productPrice}',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      fit: BoxFit.contain,
                      image: NetworkImage(
                        widget.productImage,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Description: ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  widget.productDescription,
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Ratings:',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.ratings,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Color(0xFF3B2977),
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.uploadedBy,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.category_sharp,
                          color: Color(0xFF3B2977),
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.category,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  createChatroomAndStartConvo();
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 50,
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    'Talk To The Owner',
                    style: TextStyle(color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xFF3B2977),
                  ),
                ),
              ),
              widget.onRent == true && widget.rentTimeCompleted == false
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          'This Product is Already On Rent, Please Contact The Owner',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: RentProductForm(
                                    productId: widget.productId,
                                    image: widget.productImage,
                                    productName: widget.productName,
                                    productPrice: widget.productPrice,
                                    uploadedBy: widget.uploadedBy),
                                type: PageTransitionType.bottomToTop));
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        height: 50,
                        width: double.infinity,
                        child: Center(
                            child: Text(
                          'Rent This Product Now!',
                          style: TextStyle(color: Colors.white),
                        )),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xFF3B2977),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

String getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
