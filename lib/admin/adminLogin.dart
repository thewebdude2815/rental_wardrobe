// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_olx/admin/adminHome.dart';
import 'package:the_olx/admin/adminLogic.dart/authFunctionsA.dart';
import 'package:the_olx/admin/adminSignup.dart';

class AdminLogic extends StatefulWidget {
  const AdminLogic({Key? key}) : super(key: key);

  @override
  State<AdminLogic> createState() => _AdminLogicState();
}

class _AdminLogicState extends State<AdminLogic> {
  TextEditingController aEmailC = TextEditingController();
  TextEditingController aPassC = TextEditingController();
  String err = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Admin Login',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                err,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
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
              GestureDetector(
                onTap: () async {
                  String msg = await loginA(aEmailC.text, aPassC.text);
                  if (msg == "success") {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: AdminHome(),
                            type: PageTransitionType.leftToRightWithFade));
                  } else if (msg == "error") {
                    setState(() {
                      err = "Password Or Email Incorrect!";
                    });
                  }
                  // signupFuncAdmin(aEmailC.text, aNameC.text, aPassC.text,
                  //         aRePassC.text, aCodeC.text, int.parse(aNumberC.text))
                  // .then((value) {

                  // });
                },
                child: Container(
                  color: Colors.orange,
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return AdminSignup();
                  }));
                },
                child: Text('Signup Instead!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
