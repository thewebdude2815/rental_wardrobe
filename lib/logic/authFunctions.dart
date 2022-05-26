import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_olx/logic/dataController.dart';

import 'firestoreFunctions.dart';

Future<void> signupFunc(String email, password, name, gender, Uint8List? image,
    int number, String address) async {
  String msg = "";
  try {
    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        gender.isEmpty ||
        image!.isEmpty ||
        address.isEmpty ||
        number.isNaN) {
      print('Missing Something');
      msg = 'empty';
      Get.snackbar('Error', 'Please Fill All Fields');
    } else {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var userId = userCredential.user!.uid;
      await addData(
          email, name, gender, userId, userId, image, number, address);
      Get.snackbar('Creating Account ', 'SuccessFull');
    }
  } catch (e) {
    msg = 'weird error';
  }
}

Future<String> signupFuncGoogle(String email, name, gender, Uint8List? image,
    int number, String address) async {
  String err = "";
  try {
    var userId = FirebaseAuth.instance.currentUser!.uid;

    await addData(email, name, gender, userId, userId, image, number, address);
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

Future<String> login(String email, password) async {
  String err = "";
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    Get.snackbar('Logging Account', 'Successfull');
  } catch (e) {
    Get.snackbar('Error in Login', e.toString());
  }
  return err;
}

Future<String> signInWithGoogle() async {
  // Trigger the authentication flow
  String err = '';
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;

    err = "All good";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      err = "email-error";
      print('The account already exists for that email.');
    }
  }
  return err;
}
// Future getProductsByUser() async {
//   String username = await DataController().getUserName();
//   QuerySnapshot snaps = await FirebaseFirestore.instance
//       .collection('products')
//       .where('uploadedBy', isEqualTo: username)
//       .get();
//   var data = snaps as Map<String, dynamic>;
//   print(data);
// }

Future deleteAccount() async {
  String? userId = FirebaseAuth.instance.currentUser!.uid;
  String username = await DataController().getUserName();
  var productIds = await DataController().getUserProductsIds();
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .delete()
        .then((value) async {
      for (var i = 0; i < productIds.length; i++) {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(productIds[i])
            .delete();
        await FirebaseFirestore.instance
            .collection('productOnRent')
            .doc(productIds[i])
            .delete();
      }
    }).then((value) async {
      await FirebaseAuth.instance.currentUser!.delete();
    });
    Get.snackbar('Deleting Account', 'User Successfully Deleted');
  } catch (e) {
    print(e.toString());
  }
}

Future verifyUserEmail() async {
  String result = "";
  // String? currentEmail = FirebaseAuth.instance.currentUser!.email;
  DocumentSnapshot snap = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
  // var userData = snap.data() as Map<String, dynamic>;
  // var userEmail = userData['email'];
  if (snap.exists) {
    result = 'present';
  } else {
    result = 'not present';
  }
  return result;
}
