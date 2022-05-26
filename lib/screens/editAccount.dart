// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/logic/firestoreFunctions.dart';
import 'package:the_olx/screens/firstScreen.dart';
import 'package:the_olx/screens/settings.dart';

import '../logic/authFunctions.dart';
import '../logic/pickImage.dart';
import '../logic/validationFunction.dart';

class EditAccount extends StatefulWidget {
  String userName;
  String email;
  String gender;
  String userid;
  String imgUrl;
  String role;
  String number;
  EditAccount(
      {required this.userName,
      required this.email,
      required this.gender,
      required this.userid,
      required this.imgUrl,
      required this.role,
      required this.number});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  String error = "";
  TextEditingController emailC = TextEditingController();

  TextEditingController nameC = TextEditingController();

  TextEditingController genderC = TextEditingController();
  String? dropdownValue;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  void _submit() {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      updateDataFunction(widget.userid, emailC.text, nameC.text, dropdownValue,
              widget.imgUrl, widget.role, widget.number)
          .whenComplete(() {
        Navigator.push(
            context,
            PageTransition(
                child: MySettings(), type: PageTransitionType.leftToRight));
      });
    }
  }

  @override
  void initState() {
    setState(() {
      nameC.text = widget.userName;
      emailC.text = widget.email;
      dropdownValue = widget.gender;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Center(
                  //   child: Lottie.asset('images/signup.json', height: 100),
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // ),

                  TextFormField(
                    validator: validateEmail,
                    autofillHints: [AutofillHints.email],
                    controller: emailC,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: validateName,
                    controller: nameC,
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Select Gender'),
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
                      items: ['Male', 'Female'].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      _submit();
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Center(
                              child: Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            )),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xFF3B2977),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
