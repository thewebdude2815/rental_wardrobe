import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_olx/admin/adminHome.dart';
import 'package:the_olx/screens/landingpage.dart';
import 'package:the_olx/screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TheOlxMain());
}

class TheOlxMain extends StatefulWidget {
  @override
  State<TheOlxMain> createState() => _TheOlxMainState();
}

class _TheOlxMainState extends State<TheOlxMain> {
  String role = '';

  checkRole() async {
    var currentRole;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No User yet");
    } else if (user != null) {
      DocumentSnapshot? snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      currentRole = snap['role'];
    }

    return currentRole;
  }

  decidePage() async {
    var roleName = await checkRole();
    if (roleName != null) {
      setState(() {
        role = roleName;
      });
    }

    return role;
  }

  @override
  void initState() {
    decidePage();
    // print(FirebaseAuth.instance.currentUser!.email);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.ralewayTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData && role == 'user') {
              return SplashScreen();
            } else if (snapshot.hasData && role == 'admin') {
              return AdminHome();
            } else {
              return LandingPage();
            }
          }),
    );
  }
}
