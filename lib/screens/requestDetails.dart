// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_olx/logic/dataController.dart';
import 'package:the_olx/logic/firestoreFunctions.dart';
import 'package:the_olx/screens/firstScreen.dart';
import 'package:the_olx/screens/landingpage.dart';
import 'package:the_olx/screens/productsIrented.dart';

class RequestDetails extends StatefulWidget {
  String productName;
  String productPrice;
  String image;
  String uploadedBy;
  Timestamp rentRequestDate;
  Timestamp rentEndDate;
  bool approved;
  bool timeCompleted;
  String productId;
  String rentBy;
  List users;
  RequestDetails({
    required this.users,
    required this.rentBy,
    required this.productId,
    required this.image,
    required this.productName,
    required this.productPrice,
    required this.uploadedBy,
    required this.rentEndDate,
    required this.rentRequestDate,
    required this.approved,
    required this.timeCompleted,
  });

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  String rating = "";
  dateFunction(dateValue) {
    DateTime date = dateValue.toDate();
    var received_date = DateFormat("yyyy-MM-dd").format(date);
    return received_date;
  }

  String myName = '';
  getName() async {
    String a = await DataController().getUserName();
    setState(() {
      myName = a;
    });
  }

  @override
  void initState() {
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Rent Request Details',
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
                    Image.network(widget.image, height: 170),
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
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            widget.timeCompleted == true
                                ? "Item Returned"
                                : 'Note: Please Return The Item On Time In Order To Avoid Penalties',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(144, 244, 67, 54),
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromARGB(164, 62, 146, 106),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Request For Rent Date:',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  Text(
                    dateFunction(widget.rentRequestDate),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromARGB(164, 62, 146, 106),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Rent End Date:',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  Text(
                    dateFunction(widget.rentEndDate),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromARGB(164, 62, 146, 106),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Request Status:',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  Text(
                    (widget.approved == true && widget.timeCompleted == false)
                        ? 'Renting'
                        : (widget.approved == true &&
                                widget.timeCompleted == true)
                            ? 'Completed'
                            : 'Pending',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20.0),
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromARGB(164, 62, 146, 106),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Product By:',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  Text(
                    widget.uploadedBy,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            widget.approved == true &&
                    widget.timeCompleted == false &&
                    widget.rentBy == myName
                ? GestureDetector(
                    onTap: () async {
                      _ratingAlert();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF3B2977),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Return Item',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  String _ratingAlert() {
    String message = '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Center(
          child: Text("Rate This Product"),
        ),
        content: rateAlertContent(),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              uploadRatings(widget.productId, rating).then((value) async {
                await DataController()
                    .updateTimeCompletedStatus(widget.productId)
                    .then((value) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return FirstScreen();
                  }));
                });
              });
            },
            child: Text("Upload Review"),
          ),
        ],
      ),
    );
    return message;
  }

  Widget rateAlertContent() {
    return RatingBar.builder(
        minRating: 1,
        itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
        onRatingUpdate: (rating) {
          this.rating = rating.toString();
        });
  }
}
