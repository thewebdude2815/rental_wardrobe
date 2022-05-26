// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_olx/logic/productFunctions.dart';
import 'package:the_olx/screens/firstScreen.dart';
import 'package:the_olx/screens/productByMe.dart';

import '../logic/pickImage.dart';

class EditProduct extends StatefulWidget {
  String productName;
  String productPrice;
  String productDescription;
  String productImage;
  String productCategory;
  String productId;
  List nameArray;
  bool onRent;
  String uploaderImage;
  bool rentTimeCompleted;
  String user_id;
  EditProduct(
      {required this.onRent,
      required this.uploaderImage,
      required this.rentTimeCompleted,
      required this.user_id,
      required this.productDescription,
      required this.nameArray,
      required this.productId,
      required this.productImage,
      required this.productName,
      required this.productPrice,
      required this.productCategory});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  String? authorName, title, description;

  TextEditingController productNameC = TextEditingController();
  TextEditingController productPriceC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  bool isLoading = false;

  Future updateBlogData() async {
    setState(() {
      isLoading = true;
    });

    updateProduct(
        widget.productId,
        productNameC.text,
        productPriceC.text,
        descriptionC.text,
        widget.productImage,
        widget.productCategory,
        widget.nameArray,
        widget.onRent,
        widget.rentTimeCompleted,
        widget.uploaderImage,
        widget.user_id);
  }

  @override
  void initState() {
    print(widget.nameArray);
    setState(() {
      productNameC.text = widget.productName;
      productPriceC.text = widget.productPrice;
      descriptionC.text = widget.productDescription;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // actions: [
      //   IconButton(
      //     onPressed: () {
      //       Navigator.push(context, MaterialPageRoute(builder: (_) {
      //         return AddCat();
      //       }));
      //     },
      //     icon: Icon(Icons.summarize),
      //   )
      // ],
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
                          Navigator.pop(context);
                        },
                        child: Icon(EvaIcons.arrowBackOutline)),
                    Text(
                      'Edit Product',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox()
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  controller: productNameC,
                  decoration: InputDecoration(
                    hintText: "Product Name",
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  controller: productPriceC,
                  decoration: InputDecoration(
                    hintText: "Product Price",
                  ),
                  onChanged: (value) {
                    title = value;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  controller: descriptionC,
                  decoration: InputDecoration(
                    hintText: "Description",
                  ),
                  onChanged: (value) {
                    description = value;
                  },
                ),
              ),
              InkWell(
                onTap: () async {
                  await updateBlogData();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProductsByMe();
                  }));
                },
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            "Update Product!",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF3B2977),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
