// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/screens/firstScreen.dart';
import 'package:the_olx/screens/verifyOtp.dart';
import 'package:the_olx/screens/verifyOtpGoogle.dart';

import '../logic/authFunctions.dart';
import '../logic/pickImage.dart';
import '../logic/validationFunction.dart';

class SignUpGoogle extends StatefulWidget {
  const SignUpGoogle({Key? key}) : super(key: key);

  @override
  State<SignUpGoogle> createState() => _SignUpGoogleState();
}

class _SignUpGoogleState extends State<SignUpGoogle> {
  TextEditingController emailC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController numberC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  String? dropdownValue;
  String? currentEmail = FirebaseAuth.instance.currentUser!.email;

  final _formKey = GlobalKey<FormState>();
  String? userId = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = false;
  Uint8List? _image;
  void selectImage() async {
    Uint8List? _img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = _img;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate() &&
        dropdownValue != null &&
        _image != null) {
      Navigator.push(
          context,
          PageTransition(
              child: VerifyOtpGoogle(
                address: addressC.text,
                dropdown: dropdownValue!,
                email: emailC.text,
                image: _image!,
                name: nameC.text,
                number: int.parse(numberC.text),
              ),
              type: PageTransitionType.leftToRight));
      // setState(() {
      //   isLoading = true;
      // });
      // signupFuncGoogle(emailC.text, passC.text, nameC.text, dropdownValue,
      //         _image, int.parse(numberC.text), addressC.text)
      //     .whenComplete(() {
      //   Navigator.push(
      //       context,
      //       PageTransition(
      //           child: FirstScreen(), type: PageTransitionType.leftToRight));
      // });
    }
  }

  @override
  void initState() {
    print(currentEmail);
    setState(() {
      emailC.text = currentEmail!;
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
                  //   child: Lottie.asset('images/signup.json', height: 170),
                  // ),
                  GestureDetector(
                    onTap: () {
                      selectImage();
                    },
                    child: _image == null
                        ? Stack(
                            children: [
                              CircleAvatar(
                                radius: 80,
                                backgroundColor:
                                    Color.fromARGB(255, 216, 216, 215),
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
                  SizedBox(
                    height: 30,
                  ),
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
                  TextFormField(
                    controller: addressC,
                    decoration: InputDecoration(
                      hintText: "Home Address",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: validateNumber,
                    controller: numberC,
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
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
                              'Verify OTP',
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
