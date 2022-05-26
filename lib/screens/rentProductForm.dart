// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:the_olx/logic/dataController.dart';
import 'package:the_olx/screens/firstScreen.dart';
import 'package:the_olx/screens/rentingRequests.dart';
import 'package:the_olx/screens/settings.dart';
import 'package:the_olx/logic/validationFunction.dart';
import '../logic/firestoreFunctions.dart';

class RentProductForm extends StatefulWidget {
  String productId;
  String productName;
  String productPrice;
  String image;
  String uploadedBy;
  RentProductForm(
      {required this.productId,
      required this.image,
      required this.productName,
      required this.productPrice,
      required this.uploadedBy});
  @override
  State<RentProductForm> createState() => _RentProductFormState();
}

class _RentProductFormState extends State<RentProductForm> {
  DateTime date = DateTime.now();
  TextEditingController daysC = TextEditingController();
  TextEditingController cityC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  createRentRoom() async {
    setState(() {
      isLoading = true;
    });
    String myname = await DataController().getUserName();
    String uploadedByName = widget.uploadedBy;
    // dynamic rentRoomId = getRentRoomId(myname, widget.productName);
    List<String> users = [uploadedByName, myname];
    FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .update({"onRent": true, "rentTimeCompleted": false});
    addRentData(
        date,
        cityC.text,
        widget.productId,
        users,
        widget.productName,
        widget.productPrice,
        widget.image,
        widget.productPrice,
        uploadedByName,
        myname);
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return FirstScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(EvaIcons.arrowBackOutline)),
                    Text(
                      'Rent A Product',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Product Information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        height: 170,
                        imageUrl: widget.image,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productName.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Rs ${widget.productPrice}/Per Day',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  'How many days do you want to rent the product for?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2023));
                  if (newDate == null) return;
                  setState(() {
                    date = newDate;
                  });
                  print(date);
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 97, 230, 253),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text('Select Date')),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: TextField(
              //     controller: daysC,
              //     keyboardType: TextInputType.number,
              //     decoration: InputDecoration(
              //         focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //         hintText: 'In Days.'),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Which city do you want the product to rent in?',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: validateCity,
                    controller: cityC,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'City Name.'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    createRentRoom();
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: 50,
                  width: double.infinity,
                  child: Center(
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              'Send Rent Request',
                              style: TextStyle(color: Colors.white),
                            )),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xFF3B2977),
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

String getRentRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
