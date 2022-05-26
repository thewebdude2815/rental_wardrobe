// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/logic/dataController.dart';
import 'package:the_olx/screens/categoryBox.dart';
import 'package:the_olx/screens/homepage.dart';
import 'package:the_olx/screens/productByCategory.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
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
                    SizedBox(),
                    Text(
                      'Categories',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox()
                  ],
                ),
              ),
              GetBuilder<DataController>(
                init: DataController(),
                builder: (value) {
                  return FutureBuilder(
                    future: value.getCategories(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        final categoryLength = snapshot.data.docs;
                        return Container(
                            height: MediaQuery.of(context).size.height * 0.82,
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, mainAxisSpacing: 10),
                              itemCount: categoryLength.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: ProductsByCategory(
                                                categoryImage:
                                                    categoryLength[index]
                                                        ['imgUrl'],
                                                categoryName:
                                                    categoryLength[index]
                                                        ['name']),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  },
                                  child: CategoryBox(
                                    catName: categoryLength[index]['name'],
                                    image: categoryLength[index]['imgUrl'],
                                  ),
                                );
                              },
                            ));
                      } else {
                        return Container(
                          child: CircularProgressIndicator(),
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
