// ignore_for_file: unnecessary_const

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UserInformation extends StatefulWidget {
  String uid,
      userImage,
      userName,
      userAddress,
      userPhone,
      userGender,
      userEmail;
  UserInformation(
      {required this.uid,
      required this.userAddress,
      required this.userGender,
      required this.userImage,
      required this.userName,
      required this.userPhone,
      required this.userEmail});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  backgroundColor: Colors.white,
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(EvaIcons.arrowBackOutline)),
                  const Center(
                    child: const Text(
                      'User Profile',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // color: Color(0xFF3B2977).withOpacity(0.2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.userImage),
                    radius: 70,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.userName,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height * 0.09,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF3B2977).withOpacity(0.7),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(
                    EvaIcons.emailOutline,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 50),
                  Text(
                    widget.userEmail,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height * 0.09,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF3B2977).withOpacity(0.7),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(
                    EvaIcons.homeOutline,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 50),
                  Text(
                    widget.userAddress,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height * 0.09,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF3B2977).withOpacity(0.7),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(
                    EvaIcons.phoneCallOutline,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 50),
                  Text(
                    '+${widget.userPhone}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: MediaQuery.of(context).size.height * 0.09,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF3B2977).withOpacity(0.7),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(
                    EvaIcons.person,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 50),
                  Text(
                    widget.userGender,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  _onDeleteAlert() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "WARNING!",
      desc:
          "Deleting Your Profile Will Delete Your Products & Renting Products.",
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            // await deleteAccount().then((value) {
            //   print('Deleted');
            //   Navigator.push(context, MaterialPageRoute(builder: (_) {
            //     return LandingPage();
            //   }));
            // });
          },
          color: Colors.red,
        )
      ],
    ).show();
  }
}
