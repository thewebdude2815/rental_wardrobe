// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:the_olx/screens/firstScreen.dart';

import '../logic/authFunctions.dart';

class VerifyOtpGoogle extends StatefulWidget {
  String email, name, address, dropdown;
  Uint8List image;
  int number;
  VerifyOtpGoogle({
    required this.address,
    required this.dropdown,
    required this.email,
    required this.image,
    required this.name,
    required this.number,
  });

  @override
  State<VerifyOtpGoogle> createState() => _VerifyOtpGoogleState();
}

class _VerifyOtpGoogleState extends State<VerifyOtpGoogle> {
  bool isLoadingF = false;
  bool isLoadingV = false;
  TextEditingController otpC = TextEditingController();
  String verificationid = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Lottie.asset('images/otp.json', height: 300),
            TextFormField(
              controller: otpC,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isLoadingF = true;
                });
                fetchOtp(widget.number, widget.email, widget.name,
                        widget.address, widget.dropdown, widget.image)
                    .then((value) {
                  setState(() {
                    isLoadingF = false;
                  });
                });
              },
              child: Container(
                height: 50,
                width: double.infinity,
                child: Center(
                  child: isLoadingF
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Fetch OTP',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFF3B2977),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isLoadingV = true;
                });
                verifyotp(widget.email, widget.name, widget.address,
                        widget.dropdown, widget.number, widget.image)
                    .then((value) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return FirstScreen();
                  }));
                });
              },
              child: Container(
                height: 50,
                width: double.infinity,
                child: Center(
                    child: isLoadingV
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
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
      )),
    );
  }

  Future fetchOtp(phoneNo, email, name, address, gender, image) async {
    print(phoneNo);
    FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+${phoneNo.toString()}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await signupFuncGoogle(email, name, gender, image, phoneNo, address);
        },
        verificationFailed: (FirebaseException e) {
          if (e.code == 'invalid-phone-number') {
            print('invalid number');
          }
        },
        codeSent: (String verificationid, int? resendToken) async {
          this.verificationid = verificationid;
        },
        codeAutoRetrievalTimeout: (String verificationid) {});
  }

  Future verifyotp(email, name, address, gender, number, image) async {
    PhoneAuthCredential cred = PhoneAuthProvider.credential(
        verificationId: verificationid, smsCode: otpC.text.toString());
    await signupFuncGoogle(email, name, gender, image, number, address);
  }
}
