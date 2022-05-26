// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/logic/authFunctions.dart';
import 'package:the_olx/screens/firstScreen.dart';
import 'package:the_olx/screens/signup.dart';

import '../logic/validationFunction.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String err = '';
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  void _submit() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String result = await login(emailC.text, passC.text);
      if (result == '') {
        Navigator.push(
            context,
            PageTransition(
                child: FirstScreen(), type: PageTransitionType.leftToRight));
      } else {
        setState(() {
          result = err;
        });
      }
      // .whenComplete(() {
      //   Navigator.push(
      //       context,
      //       PageTransition(
      //           child: FirstScreen(), type: PageTransitionType.leftToRight));
      // });
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
              gradient:
                  LinearGradient(begin: AlignmentDirectional.topEnd, colors: [
                Color(0xFF3B2977).withOpacity(0.7),
                Color.fromARGB(255, 139, 114, 223).withOpacity(0.5),
              ]),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(500.0),
              ),
            ),
          ),
        ),
        /////
        Positioned(
          child: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Lottie.asset('images/signup.json', height: 170),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        err,
                        style: TextStyle(color: Colors.red),
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
                                  'Login',
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
                            return Signup();
                          }));
                        },
                        child: Text("Make A New Account?"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    )));
  }
}
