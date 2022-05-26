// ignore_for_file: prefer_const_constructors

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/logic/firestoreFunctions.dart';
import 'package:the_olx/screens/editProduct.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:the_olx/screens/firstScreen.dart';
import 'package:the_olx/screens/homepage.dart';

class MySingleProduct extends StatefulWidget {
  String productName;
  String productDescription;
  String productPrice;
  String productImage;
  String uploadedBy;
  String category;
  String productId;
  List nameArray;
  bool onRent;
  String uploaderImage;
  bool rentTimeCompleted;
  String user_id;
  String ratings;
  MySingleProduct(
      {required this.ratings,
      required this.onRent,
      required this.uploaderImage,
      required this.rentTimeCompleted,
      required this.user_id,
      required this.productDescription,
      required this.nameArray,
      required this.productImage,
      required this.productId,
      required this.productName,
      required this.productPrice,
      required this.uploadedBy,
      required this.category});
  @override
  State<MySingleProduct> createState() => _MySingleProductState();
}

class _MySingleProductState extends State<MySingleProduct> {
  bool isLoading = false;
  deleteProduct(String proName) {
    setState(() {
      isLoading = true;
    });
    deleteFunction(proName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(EvaIcons.arrowBackOutline)),
                    Text(
                      '${widget.productName.toUpperCase()}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Color(0xFF3B2977)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Rs ${widget.productPrice}',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      fit: BoxFit.contain,
                      image: NetworkImage(
                        widget.productImage,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Text(
                          'Ratings:',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.ratings,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Description: ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  widget.productDescription,
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Color(0xFF3B2977),
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.uploadedBy,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.category_sharp,
                          color: Color(0xFF3B2977),
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.category,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: EditProduct(
                              onRent: widget.onRent,
                              uploaderImage: widget.uploaderImage,
                              rentTimeCompleted: widget.rentTimeCompleted,
                              user_id: widget.user_id,
                              nameArray: widget.nameArray,
                              productId: widget.productId,
                              productCategory: widget.category,
                              productDescription: widget.productDescription,
                              productImage: widget.productImage,
                              productName: widget.productName,
                              productPrice: widget.productPrice),
                          type: PageTransitionType.bottomToTop));
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 50,
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    'Edit This Product!',
                    style: TextStyle(color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.green,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _onDeleteAlert();
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 50,
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    'Delete This Product!',
                    style: TextStyle(color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onDeleteAlert() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "WARNING!",
      desc: "Are You Sure You Want To Delete This Product?",
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            deleteProduct(widget.productId);
            Navigator.push(
                context,
                PageTransition(
                    child: FirstScreen(),
                    type: PageTransitionType.bottomToTop));
          },
          color: Colors.red,
        )
      ],
    ).show();
  }
}
