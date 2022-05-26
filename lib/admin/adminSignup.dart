// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/admin/adminHome.dart';
import 'package:the_olx/admin/adminLogic.dart/authFunctionsA.dart';
import 'package:the_olx/admin/adminLogin.dart';
import 'package:the_olx/logic/authFunctions.dart';

class AdminSignup extends StatefulWidget {
  const AdminSignup({Key? key}) : super(key: key);

  @override
  State<AdminSignup> createState() => _AdminSignupState();
}

class _AdminSignupState extends State<AdminSignup> {
  TextEditingController aEmailC = TextEditingController();
  TextEditingController aNameC = TextEditingController();
  TextEditingController aPassC = TextEditingController();
  TextEditingController aRePassC = TextEditingController();
  TextEditingController aNumberC = TextEditingController();
  TextEditingController aCodeC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Admin SignUp',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: aEmailC,
                  decoration: InputDecoration(
                    hintText: "Admin Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: aNameC,
                  decoration: InputDecoration(
                    hintText: "Admin Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: aPassC,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Admin Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: aRePassC,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Repeat Password",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: aNumberC,
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: aCodeC,
                  decoration: InputDecoration(
                    hintText: "Admin Code",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    signupFuncAdmin(
                            aEmailC.text,
                            aNameC.text,
                            aPassC.text,
                            aRePassC.text,
                            aCodeC.text,
                            int.parse(aNumberC.text))
                        .then((value) {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: AdminHome(),
                              type: PageTransitionType.leftToRightWithFade));
                    });
                  },
                  child: Container(
                    color: Colors.orange,
                    height: 50,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Make Account',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: AdminLogic(),
                              type: PageTransitionType.leftToRightWithFade));
                    },
                    child: Text('Login Instead!')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
