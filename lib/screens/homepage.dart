// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_olx/logic/dataController.dart';

import 'package:the_olx/screens/addProduct.dart';
import 'package:the_olx/screens/categoryBox.dart';
import 'package:the_olx/screens/landingpage.dart';
import 'package:the_olx/screens/productByCategory.dart';
import 'package:the_olx/screens/rentProductForm.dart';

import 'package:the_olx/screens/searchedResult.dart';
import 'package:the_olx/screens/singleProductUser.dart';

import 'messages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _onRentAlert() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Oops!",
      desc: "This Product Is Already On Rent",
      buttons: [
        DialogButton(
          child: Text(
            "Okay",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
      ],
    ).show();
  }

  List<String> catList = [];
  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Best Products',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: Messages(),
                              type: PageTransitionType.bottomToTop));
                    },
                    child: Icon(
                      EvaIcons.messageCircle,
                      color: Color(0xFF3B2977),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return SearchedResult(searchT: searchText);
                  }));
                },
                controller: searchText,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(EvaIcons.search),
                  hintText: 'Search Items Here',
                  hintStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 235, 243, 251),
                  // contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Browse Categories',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final catCount = snapshot.data!.docs;
                  return Container(
                    height: 150,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: catCount.length,
                        itemBuilder: (context, index) {
                          if (catCount.length != catList.length) {
                            catList.add(catCount[index]['name']);
                          }
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: ProductsByCategory(
                                          categoryImage: catCount[index]
                                              ['imgUrl'],
                                          categoryName: catCount[index]
                                              ['name']),
                                      type: PageTransitionType.bottomToTop));
                            },
                            child: CategoryBox(
                              catName: catCount[index]['name'],
                              image: catCount[index]['imgUrl'],
                            ),
                          );
                        }),
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Recommended Products',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // ProductShimmerss(),
            GetBuilder<DataController>(
              init: DataController(),
              builder: (value) {
                return FutureBuilder(
                  future: value.getData(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      final productCount = snapshot.data.docs;
                      return Expanded(
                        child: GridView.builder(
                          // shrinkWrap: true,
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
                                        userId: productCount[index]['user_id'],
                                        ratings: productCount[index]['ratings'],
                                        productId: productCount[index]
                                            ['productId'],
                                        uploaderImage: productCount[index]
                                            ['uploaderImage'],
                                        onRent: productCount[index]['onRent'],
                                        rentTimeCompleted: productCount[index]
                                            ['rentTimeCompleted'],
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
                                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                                            GestureDetector(
                                              onTap: () {
                                                productCount[index]["onRent"] ==
                                                            true &&
                                                        productCount[index][
                                                                "rentTimeCompleted"] ==
                                                            false
                                                    ? _onRentAlert()
                                                    : Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (_) {
                                                        return RentProductForm(
                                                            productId:
                                                                productCount[
                                                                        index][
                                                                    "productId"],
                                                            image: productCount[
                                                                    index]
                                                                ["imageUrl"],
                                                            productName:
                                                                productCount[
                                                                        index]
                                                                    ["title"],
                                                            productPrice:
                                                                productCount[
                                                                        index]
                                                                    ["price"],
                                                            uploadedBy:
                                                                productCount[
                                                                        index][
                                                                    "uploadedBy"]);
                                                      }));
                                              },
                                              child: Container(
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
                                                            BorderRadius
                                                                .circular(40),
                                                      )
                                                    : BoxDecoration(
                                                        color:
                                                            Color(0xFF3B2977),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                      ),
                                                child: Icon(
                                                  EvaIcons.homeOutline,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      ]),
                                ));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: AddProduct(
                    categorList: catList,
                  ),
                  type: PageTransitionType.leftToRightWithFade));
        },
        child: Icon(EvaIcons.plusCircle),
      ),
    );
  }
}

class HomepageCatPro extends StatelessWidget {
  String category;
  HomepageCatPro({required this.category});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<DataController>(
        init: DataController(),
        builder: (value) {
          return FutureBuilder(
            future: value.getCategoryWiseData(category),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                final productCount = snapshot.data.docs;
                return Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.57,
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
                                  userId: productCount[index]['user_id'],
                                  ratings: productCount[index]['ratings'],
                                  productId: productCount[index]['productId'],
                                  uploaderImage: productCount[index]
                                      ['uploaderImage'],
                                  onRent: productCount[index]['onRent'],
                                  rentTimeCompleted: productCount[index]
                                      ['rentTimeCompleted'],
                                  productDescription: productCount[index]
                                      ['description'],
                                  productImage: productCount[index]['imageUrl'],
                                  productName: productCount[index]['title'],
                                  productPrice: productCount[index]['price'],
                                  uploadedBy: productCount[index]['uploadedBy'],
                                  category: productCount[index]['category'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 5, right: 5, bottom: 10),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 350,
                            width: 250,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.topCenter,
                                    imageUrl: productCount[index]['imageUrl'],
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
                                    productCount[index]['title'].toUpperCase(),
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
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: productCount[index]
                                                        ["onRent"] ==
                                                    true &&
                                                productCount[index]
                                                        ["rentTimeCompleted"] ==
                                                    false
                                            ? BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              )
                                            : BoxDecoration(
                                                color: Color(0xFF3B2977),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                        child: Icon(
                                          EvaIcons.homeOutline,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )
                                ]),
                          ));
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
    );
  }
}
