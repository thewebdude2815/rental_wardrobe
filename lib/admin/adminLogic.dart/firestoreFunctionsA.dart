import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:the_olx/logic/imageUpload.dart';

Future addDataAdmin(String email, name, password, repPassword, userId, uid,
    adminCode, int number) async {
  try {
    if (password != repPassword) {
      print('Passwords Dont match');
    } else if ((email.isNotEmpty || name.isNotEmpty || number != null) &&
        adminCode == "2x42") {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        "email": email,
        "name": name,
        "uid": uid,
        "number": number,
        "adminCode": adminCode,
        "role": "admin"
      });
    } else {
      print('Something issss wrong');
    }
  } catch (e) {
    print(e.toString());
  }
}

Future gettingProductnumber() async {
  QuerySnapshot snap =
      await FirebaseFirestore.instance.collection('products').get();
  var numberss = snap.docs.length;
  return numberss;
}

Future gettingUsernumber() async {
  QuerySnapshot snap = await FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'user')
      .get();
  var numberss = snap.docs.length;
  return numberss;
}

Future gettingProductsOnRent() async {
  QuerySnapshot snap =
      await FirebaseFirestore.instance.collection('productsOnRent').get();
  var numberss = snap.docs.length;
  return numberss;
}

Future createcategory(String categoryname, Uint8List? imageurl) async {
  try {
    String imgurl = await ImageUpload()
        .uploadImages("CategoryImages", categoryname, imageurl!);
    await FirebaseFirestore.instance
        .collection("categories")
        .doc(categoryname)
        .set({
      "imgUrl": imgurl,
      "name": categoryname,
    });
  } catch (e) {
    print(e.toString());
  }
}
