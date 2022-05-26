// ignore_for_file: prefer_const_constructors

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class SingleProduct extends StatefulWidget {
  String productName;
  String productDescription;
  String productPrice;
  String productImage;
  String uploadedBy;
  String category;
  bool onRent;
  SingleProduct(
      {required this.onRent,
      required this.productDescription,
      required this.productImage,
      required this.productName,
      required this.productPrice,
      required this.uploadedBy,
      required this.category});

  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
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
                    const EdgeInsets.only(top: 10.0, bottom: 20.0, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Icon(EvaIcons.arrowBackOutline),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      '${widget.productName}'.toUpperCase(),
                      style: TextStyle(fontSize: 17),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.orangeAccent),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text('Rs ${widget.productPrice}'),
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
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Description: ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    Text(
                      'Product By : ${widget.uploadedBy}',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      'Category : ${widget.category}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                width: double.infinity,
                height: 50,
                color: Colors.redAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Rent Status: ',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    Text(
                      widget.onRent == true ? "On Rent" : "Not On Rent",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    )
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
