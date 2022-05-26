// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/screens/singleProductUser.dart';
import '../logic/dataController.dart';

class ProductsByCategory extends StatefulWidget {
  String categoryName;
  String categoryImage;
  ProductsByCategory({required this.categoryName, required this.categoryImage});

  @override
  State<ProductsByCategory> createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends State<ProductsByCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: Text(
                    widget.categoryName,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.topCenter,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5), BlendMode.colorBurn),
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.categoryImage)),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GetBuilder<DataController>(
                init: DataController(),
                builder: (value) {
                  return FutureBuilder(
                    future: value.getCategoryData(widget.categoryName),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        final productCount = snapshot.data.docs;
                        if (productCount.isEmpty) {
                          return Center(
                            child:
                                Lottie.asset('images/404a.json', height: 250),
                          );
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.82,
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.50,
                              ),
                              itemCount: productCount.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: SingleProductUser(
                                          userId: productCount[index]
                                              ['user_id'],
                                          ratings: productCount[index]
                                              ['ratings'],
                                          productId: productCount[index]
                                              ['productId'],
                                          uploaderImage: productCount[index]
                                              ['uploaderImage'],
                                          onRent: productCount[index]['onRent'],
                                          rentTimeCompleted: productCount[index]
                                              ['rentTimeCompleted'],
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
                                          fit: BoxFit.fitWidth,
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
                                        Text(
                                          productCount[index]['description'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.grey),
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
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: productCount[index]
                                                              ["onRent"] ==
                                                          true &&
                                                      productCount[index][
                                                              "rentTimeCompleted"] ==
                                                          false
                                                  ? BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                    )
                                                  : BoxDecoration(
                                                      color: Color(0xFF3B2977),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                    ),
                                              child: Icon(
                                                EvaIcons.homeOutline,
                                                color: Colors.white,
                                              ),
                                            )
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
            ],
          ),
        ),
      ),
    );
  }
}
