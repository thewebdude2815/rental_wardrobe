import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_olx/admin/adminHome.dart';
import 'package:the_olx/admin/adminLogic.dart/firestoreFunctionsA.dart';
import 'package:the_olx/logic/pickImage.dart';
import 'package:the_olx/logic/productFunctions.dart';

class AddCat extends StatefulWidget {
  const AddCat({Key? key}) : super(key: key);

  @override
  State<AddCat> createState() => _AddCatState();
}

class _AddCatState extends State<AddCat> {
  TextEditingController categoryC = TextEditingController();
  Uint8List? _image;
  void selectImage() async {
    Uint8List? _img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = _img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        GestureDetector(
          onTap: () {
            selectImage();
          },
          child: _image == null
              ? Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Color.fromARGB(255, 216, 216, 215),
                    ),
                    Positioned(
                      left: 63,
                      top: 60,
                      child: Icon(
                        EvaIcons.imageOutline,
                        size: 35,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: MemoryImage(_image!),
                    ),
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            decoration: InputDecoration(
                hintText: "Enter Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                )),
            controller: categoryC,
          ),
        ),
        ElevatedButton(
            onPressed: () {
              createcategory(categoryC.text, _image).then((value) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AdminHome();
                }));
              });
            },
            child: Text('Add Category'))
      ]),
    ));
  }
}
