import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firestoreFunctionsA.dart';

Future<String> signupFuncAdmin(
    String email, name, password, repPassword, adminCode, int number) async {
  String err = "";
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    var userId = userCredential.user!.uid;
    await addDataAdmin(
      email,
      name,
      password,
      repPassword,
      userId,
      userId,
      adminCode,
      number,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      err = "password-error";
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      err = "email-error";
      print('The account already exists for that email.');
    } else {
      print(e.toString());
    }
  } catch (e) {
    print(e.toString());
  }

  return err;
}

Future<String> loginA(String email, password) async {
  String err = "";
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    err = "success";
  } catch (e) {
    err = 'error';
  }
  return err;
}
