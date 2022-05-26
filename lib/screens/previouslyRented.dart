// ignore_for_file: prefer_const_constructors
//  sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/logic/dataController.dart';
import 'package:the_olx/screens/requestDetails.dart';
import 'package:get/get.dart';

class PreviouslyRented extends StatefulWidget {
  const PreviouslyRented({Key? key}) : super(key: key);

  @override
  State<PreviouslyRented> createState() => _PreviouslyRentedState();
}

class _PreviouslyRentedState extends State<PreviouslyRented> {
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
                  'Rent Requests',
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
                    future: value.getPreviousRented(),
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
                                                Text("Rent Status: Compeleted")
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
