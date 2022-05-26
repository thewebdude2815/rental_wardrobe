// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_olx/admin/categoryList.dart';
import 'package:the_olx/admin/productsList.dart';
import 'package:the_olx/admin/userList.dart';

import 'adminLogic.dart/firestoreFunctionsA.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int noOfProducts = 0;
  int noOfUsers = 0;
  int noOfRentPro = 0;
  @override
  void initState() {
    getDetails();
    super.initState();
  }

  getDetails() async {
    var numberOfProducts = await gettingProductnumber();
    var numberOfUsers = await gettingUsernumber();
    var numberOfRent = await gettingProductsOnRent();
    setState(() {
      noOfProducts = numberOfProducts;
      noOfUsers = numberOfUsers;
      noOfRentPro = numberOfRent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Welcome, Admin',
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
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.orangeAccent),
                      child: Center(
                        child: Text(
                          'Total Products: ${noOfProducts}',
                          style: TextStyle(color: Colors.white, fontSize: 19),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 245, 98, 253)),
                      child: Center(
                        child: Text(
                          'Total Users: ${noOfUsers}',
                          style: TextStyle(color: Colors.white, fontSize: 19),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 76, 231, 248)),
                      child: Center(
                        child: Text(
                          'Products On Rent: ${noOfRentPro}',
                          style: TextStyle(color: Colors.white, fontSize: 19),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return ProductsList();
                        }));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'View Products',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return CategoryList();
                        }));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Categories',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return UserList();
                        }));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'View Users',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
