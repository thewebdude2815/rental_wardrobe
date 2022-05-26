// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_olx/admin/addcat.dart';
import 'package:the_olx/screens/firstScreen.dart';
import 'package:the_olx/screens/homepage.dart';
import 'package:the_olx/screens/productByMe.dart';

import '../logic/pickImage.dart';
import '../logic/productFunctions.dart';

class AddProduct extends StatefulWidget {
  List<String> categorList;
  AddProduct({required this.categorList});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String? authorName, title, description;
  TextEditingController productNameC = TextEditingController();
  TextEditingController productPriceC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  bool isLoading = false;
  List nameArray = [];
  Uint8List? _image;
  String? dropdownValue;

  void selectImage() async {
    Uint8List? _img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = _img;
    });
  }

  Future uploadBlogData() async {
    setState(() {
      isLoading = true;
    });
    await uploadProduct(
      productNameC.text,
      productPriceC.text,
      descriptionC.text,
      _image,
      dropdownValue,
      nameArray,
    );
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
                      'Add Product',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox()
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  selectImage();
                },
                child: _image != null
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 170,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: MemoryImage(_image!)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Icon(
                            Icons.add_a_photo_rounded,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 170,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 186, 186, 186),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Icon(
                            Icons.add_a_photo_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  controller: productNameC,
                  decoration: InputDecoration(
                    hintText: "Product Name",
                  ),
                  onChanged: (value) {
                    setState(() {
                      nameArray.add(value);
                    });
                  },
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
              Container(
                padding: EdgeInsets.all(20.0),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('Select Category'),
                  value: dropdownValue,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    width: double.infinity,
                    color: Color(0xFF3B2977),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: widget.categorList.map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                ),
              ),
              InkWell(
                onTap: () async {
                  await uploadBlogData();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FirstScreen();
                  }));
                },
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Add Product!",
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
