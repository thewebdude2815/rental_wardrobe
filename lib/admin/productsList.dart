// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_olx/admin/singleProduct.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(EvaIcons.arrowBackOutline)),
                    Text(
                      'Product List',
                      style: TextStyle(fontSize: 20),
                    ),
                    GestureDetector(
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                        },
                        child: Icon(EvaIcons.logOutOutline))
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        final productCount = snapshot.data!.docs;
                        return Container(
                          margin: EdgeInsets.only(right: 20),
                          height: 300,
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productCount.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return SingleProduct(
                                      onRent: productCount[index]['onRent'],
                                      productDescription: productCount[index]
                                          ['description'],
                                      productImage: productCount[index]
                                          ['imageUrl'],
                                      productName: productCount[index]['title'],
                                      productPrice: productCount[index]
                                          ['price'],
                                      uploadedBy: productCount[index]
                                          ['uploadedBy'],
                                      category: productCount[index]['category'],
                                    );
                                  }));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image(
                                          fit: BoxFit.cover,
                                          height: 220,
                                          image: NetworkImage(
                                            productCount[index]['imageUrl'],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        productCount[index]['title'],
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Color(0xFF3B2977)),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "\$${productCount[index]['price']}",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
