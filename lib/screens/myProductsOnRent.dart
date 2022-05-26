// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/screens/requestDetails.dart';

import '../logic/dataController.dart';

class MyProductsOnRent extends StatefulWidget {
  const MyProductsOnRent({Key? key}) : super(key: key);

  @override
  State<MyProductsOnRent> createState() => _MyProductsOnRentState();
}

class _MyProductsOnRentState extends State<MyProductsOnRent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(EvaIcons.arrowBackOutline)),
                Text(
                  'My Products On Rent',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(),
              ],
            ),
          ),
          GetBuilder<DataController>(
              init: DataController(),
              builder: (value) {
                return FutureBuilder(
                    future: value.getMyProductsOnRent(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        final requestCount = snapshot.data.docs;
                        if (requestCount.isEmpty) {
                          return Center(
                            child:
                                Lottie.asset('images/404a.json', height: 250),
                          );
                        } else {
                          return Container(
                              height: MediaQuery.of(context).size.height * 1,
                              child: ListView.builder(
                                  itemCount: requestCount.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color:
                                                  Colors.grey.withOpacity(0.3)),
                                        ),
                                      ),
                                      margin: EdgeInsets.all(20),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.network(
                                                requestCount[index]
                                                    ['productImage'],
                                                height: 80),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  requestCount[index]
                                                          ['productName']
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      color: Color(0xFF3B2977),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                    "Rent By: ${requestCount[index]['users'][1]}")
                                              ],
                                            ),
                                            SizedBox(width: 30),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child: RequestDetails(
                                                          users: requestCount[index]
                                                                ['users'],
                                                          rentBy: requestCount[index]
                                                                ['rentBy'],
                                                            productId: requestCount[index]
                                                                ['doc_name'],
                                                            timeCompleted:
                                                                requestCount[index][
                                                                    'timeCompleted'],
                                                            approved:
                                                                requestCount[index]
                                                                    [
                                                                    'approvedStatues'],
                                                            rentEndDate:
                                                                requestCount[index]
                                                                    ['days'],
                                                            rentRequestDate: requestCount[index]
                                                                ['uploadDate'],
                                                            image: requestCount[index][
                                                                'productImage'],
                                                            productName: requestCount[index]
                                                                ['productName'],
                                                            productPrice:
                                                                requestCount[index]
                                                                    ['productPrice'],
                                                            uploadedBy: requestCount[index]['productBy']),
                                                        type: PageTransitionType.bottomToTop));
                                              },
                                              child: Container(
                                                height: 50,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF3B2977),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'View',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }));
                        }
                      }
                    });
              })
        ]),
      )),
    );
  }
}
