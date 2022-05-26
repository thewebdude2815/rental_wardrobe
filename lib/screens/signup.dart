// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'dart:typed_data';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/logic/authFunctions.dart';
import 'package:the_olx/logic/validationFunction.dart';
import 'package:the_olx/screens/firstScreen.dart';
import 'package:the_olx/screens/verifyOtp.dart';
import '../logic/pickImage.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String error = "";
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController numberC = TextEditingController();
  TextEditingController genderC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  String? dropdownValue;
  String dropdownError = '';
  String imageError = '';
  Uint8List? _image;
  void selectImage() async {
    Uint8List? _img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = _img;
    });
  }

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  void _submit() async {
    if (_formKey.currentState!.validate() &&
        dropdownValue != null &&
        _image != null) {
      Navigator.push(
          context,
          PageTransition(
              child: VerifyOtp(
                  address: addressC.text,
                  dropdown: dropdownValue!,
                  email: emailC.text,
                  image: _image!,
                  name: nameC.text,
                  number: int.parse(numberC.text),
                  password: passC.text),
              type: PageTransitionType.leftToRight));
      // String msg = await signupFunc(emailC.text, passC.text, nameC.text,
      //     dropdownValue, _image, int.parse(numberC.text), addressC.text);

    } else {
      setState(() {
        dropdownError = "Please Select Your Gender";
        imageError = "Please Select Profile Image";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          // overflow: Overflow.visible,
          children: [
            SingleChildScrollView(
              child: Container(
                height: 500.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: AlignmentDirectional.topEnd,
                      colors: [
                        Color(0xFF3B2977).withOpacity(0.7),
                        Color.fromARGB(255, 139, 114, 223).withOpacity(0.5),
                      ]),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(500.0),
                  ),
                ),
              ),
            ),
            ////
            Positioned(
              child: Container(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
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
                            height: 10,
                          ),
                          Text(
                            imageError,
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: validateEmail,
                            autofillHints: [AutofillHints.email],
                            controller: emailC,
                            decoration: InputDecoration(
                              focusColor: Color(0xFF3B2977),
                              focusedBorder: OutlineInputBorder(),
                              hintText: "Email",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            validator: validatePassword,
                            controller: passC,
                            obscureText: true,
                            decoration: InputDecoration(
                              focusColor: Color(0xFF3B2977),
                              focusedBorder: OutlineInputBorder(),
                              hintText: "Password",
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
                              focusColor: Color(0xFF3B2977),
                              focusedBorder: OutlineInputBorder(),
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
                              focusColor: Color(0xFF3B2977),
                              focusedBorder: OutlineInputBorder(),
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
                            //
                            decoration: InputDecoration(
                              focusColor: Color(0xFF3B2977),
                              focusedBorder: OutlineInputBorder(),
                              hintText: "Number",
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
                                if (newValue != null) {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                }
                              },
                              items: ['Male', 'Female'].map((e) {
                                return DropdownMenuItem(
                                    value: e, child: Text(e));
                              }).toList(),
                            ),
                          ),
                          Text(
                            dropdownError,
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              _submit();
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              child: Center(
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
                          TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return Login();
                              }));
                            },
                            child: Text("Already Has An Account?"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
