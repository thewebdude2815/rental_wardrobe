// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/logic/firestoreFunctions.dart';
import 'package:the_olx/screens/firstScreen.dart';
import 'package:the_olx/screens/mySingleProduct.dart';
import 'package:the_olx/screens/singleProductUser.dart';

import '../logic/dataController.dart';

class ProductsByMe extends StatefulWidget {
  const ProductsByMe({Key? key}) : super(key: key);

  @override
  State<ProductsByMe> createState() => _ProductsByMeState();
}

class _ProductsByMeState extends State<ProductsByMe> {
  String? myName;
  @override
  void initState() {
    getDetailsOfUser();
    super.initState();
  }

  getDetailsOfUser() async {
    var username = await currentUserName();

    setState(() {
      myName = username;
    });
    return username;
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return FirstScreen();
                              },
                            ),
                          );
                        },
                        child: Icon(EvaIcons.arrowBackOutline)),
                    Text(
                      'Your Ads',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox()
                  ],
                ),
              ),
              SingleChildScrollView(
                child: GetBuilder<DataController>(
                  init: DataController(),
                  builder: (value) {
                    return FutureBuilder(
                      future: value.getMyData(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          final productCount = snapshot.data?.docs;
                          if (productCount.isEmpty) {
                            return Center(
                              child:
                                  Lottie.asset('images/404a.json', height: 250),
                            );
                          } else {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.88,
                              child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.50,
                                ),
                                itemCount: productCount!.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.bottomToTop,
                                          child: MySingleProduct(
                                            ratings: productCount[index]
                                                ['ratings'],
                                            onRent: productCount[index]
                                                ['onRent'],
                                            uploaderImage: productCount[index]
                                                ['uploaderImage'],
                                            rentTimeCompleted:
                                                productCount[index]
                                                    ['rentTimeCompleted'],
                                            user_id: productCount[index]
                                                ['user_id'],
                                            nameArray: productCount[index]
                                                ['nameArray'],
                                            productId: productCount[index]
                                                ['productId'],
                                            productDescription:
                                                productCount[index]
                                                    ['description'],
                                            productImage: productCount[index]
                                                ['imageUrl'],
                                            productName: productCount[index]
                                                ['title'],
                                            productPrice: productCount[index]
                                                ['price'],
                                            uploadedBy: productCount[index]
                                                ['uploadedBy'],
                                            category: productCount[index]
                                                ['category'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 5, right: 5, bottom: 10),
                                      padding: EdgeInsets.all(10),
                                      height: 350,
                                      width: 250,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CachedNetworkImage(
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.fitWidth,
                                            alignment: Alignment.topCenter,
                                            imageUrl: productCount[index]
                                                ['imageUrl'],
                                            errorWidget: (context, url, error) {
                                              return Icon(Icons.error);
                                            },
                                            placeholder: (context, url) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            productCount[index]['title']
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(Icons.star,
                                                    color: Colors.amber),
                                                Text(productCount[index]
                                                        ['ratings']
                                                    .toString())
                                              ]),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            productCount[index]['description'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Rs. ${productCount[index]["price"]}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
