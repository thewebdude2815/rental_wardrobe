// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/admin/singleProduct.dart';
import 'package:the_olx/screens/singleProductUser.dart';
import '../logic/dataController.dart';

class ProductsByCategoryAdmin extends StatefulWidget {
  String categoryName;
  String categoryImage;
  ProductsByCategoryAdmin(
      {required this.categoryName, required this.categoryImage});

  @override
  State<ProductsByCategoryAdmin> createState() =>
      _ProductsByCategoryAdminState();
}

class _ProductsByCategoryAdminState extends State<ProductsByCategoryAdmin> {
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
                      } else if (snapshot.hasData) {
                        final productCount = snapshot.data.docs;
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.82,
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.54,
                            ),
                            itemCount: productCount.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      child: SingleProduct(
                                        onRent: productCount[index]['onRent'],
                                        productDescription: productCount[index]
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
                                      borderRadius: BorderRadius.circular(20)),
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
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        productCount[index]['title'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
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
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: Text('No Products Avaliable'),
                          ),
                        );
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
