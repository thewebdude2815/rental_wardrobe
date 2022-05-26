// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/screens/firstScreen.dart';
import 'package:the_olx/screens/settings.dart';

import '../logic/dataController.dart';
import '../logic/firestoreFunctions.dart';

class ReceivedRentingRequests extends StatefulWidget {
  const ReceivedRentingRequests({Key? key}) : super(key: key);

  @override
  State<ReceivedRentingRequests> createState() =>
      _ReceivedRentingRequestsState();
}

class _ReceivedRentingRequestsState extends State<ReceivedRentingRequests> {
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
                  'Received Renting Request',
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
                    future: value.getRequestsReceived(),
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
                                            CachedNetworkImage(
                                              height: 80,
                                              imageUrl: requestCount[index]
                                                  ['productImage'],
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
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
                                                  requestCount[index]['users']
                                                      [1],
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text("Rent Status: Pending"),
                                              ],
                                            ),
                                            SizedBox(width: 30),
                                            GestureDetector(
                                              onTap: () async {
                                                await DataController()
                                                    .updateRentStatus(
                                                        requestCount[index]
                                                            ['doc_name'])
                                                    .whenComplete(() {
                                                  print('Updated');
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child: MySettings(),
                                                          type:
                                                              PageTransitionType
                                                                  .leftToRight));
                                                });
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    EvaIcons.checkmark,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await deleteRequest(
                                                        requestCount[index]
                                                            ['doc_name'])
                                                    .whenComplete(() {
                                                  print('Updated');
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child: FirstScreen(),
                                                          type:
                                                              PageTransitionType
                                                                  .leftToRight));
                                                });
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    EvaIcons.close,
                                                    color: Colors.white,
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
