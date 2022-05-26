// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/logic/dataController.dart';
import 'package:the_olx/screens/myProductsOnRent.dart';
import 'package:the_olx/screens/previouslyRented.dart';
import 'package:the_olx/screens/productsIrented.dart';
import 'package:the_olx/screens/profile.dart';
import 'package:the_olx/screens/receivedRentingRequest.dart';
import 'package:the_olx/screens/rentingRequests.dart';

class MySettings extends StatefulWidget {
  const MySettings({Key? key}) : super(key: key);

  @override
  State<MySettings> createState() => _SettingsState();
}

class _SettingsState extends State<MySettings> {
  String myName = '';
  String myEmail = '';
  String myNumber = '';
  String imgUrl = '';
  String gender = '';
  List<dynamic> allData = [];
  @override
  void initState() {
    getDetailsOfUser();
    super.initState();
  }

  getDetailsOfUser() async {
    List<dynamic> myList = await DataController().getUserEmail();
    setState(() {
      allData = myList;
    });
    return myList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Lottie.asset('images/settings2.json', height: 350),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        child: Profile(
                          dataReceieved: allData,
                        ),
                        type: PageTransitionType.topToBottom),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 0.5, color: Colors.grey.withOpacity(0.3)),
                    ),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: const Text(
                    'My Profile',
                    style: TextStyle(fontSize: 21),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        child: MyProductsOnRent(),
                        type: PageTransitionType.topToBottom),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 0.5, color: Colors.grey.withOpacity(0.3)),
                    ),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: const Text(
                    'My Products On Rent',
                    style: TextStyle(fontSize: 21),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        child: ProductsIRented(),
                        type: PageTransitionType.topToBottom),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 0.5, color: Colors.grey.withOpacity(0.3)),
                    ),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: const Text(
                    'Products I Am Renting',
                    style: TextStyle(fontSize: 21),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        child: ReceivedRentingRequests(),
                        type: PageTransitionType.topToBottom),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 0.5, color: Colors.grey.withOpacity(0.3)),
                    ),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: const Text(
                    'Received Renting Requests',
                    style: TextStyle(fontSize: 21),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        child: RentingRequests(),
                        type: PageTransitionType.topToBottom),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 0.5, color: Colors.grey.withOpacity(0.3)),
                    ),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: const Text(
                    'My Renting Requests',
                    style: TextStyle(fontSize: 21),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        child: PreviouslyRented(),
                        type: PageTransitionType.topToBottom),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: const Text(
                    'Previously Rented Products',
                    style: TextStyle(fontSize: 21),
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
