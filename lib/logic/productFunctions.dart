import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:the_olx/logic/dataController.dart';
import 'package:the_olx/logic/firestoreFunctions.dart';
import 'package:the_olx/logic/imageUpload.dart';
import 'package:uuid/uuid.dart';

Future uploadProduct(String title, String price, String description,
    Uint8List? image, String? category, List nameArray) async {
  try {
    if (price.isNotEmpty || title.isNotEmpty || description.isNotEmpty) {
      String productId = Uuid().v1();
      List allUserProductArray = await DataController().getUserProductsIds();
      allUserProductArray.add(productId);
      String imageurl = await ImageUpload()
          .uploadImages('Product Pictures', productId, image!);
      String names = await currentUserName();
      String uploaderImage = await DataController().currentUserImage();
      String userid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .update({"productsByUser": allUserProductArray});
      await FirebaseFirestore.instance
          .collection('ratings')
          .doc(productId)
          .set({"ratings": []});
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .set({
        "title": title,
        "productId": productId,
        "price": price,
        "description": description,
        "imageUrl": imageurl,
        "category": category,
        "uploadedTime": Timestamp.now(),
        "uploadedBy": names,
        "user_id": userid,
        "nameArray": nameArray,
        "onRent": false,
        "rentTimeCompleted": false,
        "uploaderImage": uploaderImage,
        "ratings": "0"
      });
    }
    Get.snackbar('Uploaded Product', 'Successfully');
  } catch (e) {
    Get.snackbar('Error in Upolading', e.toString());
  }
}

Future updateProduct(
    String productId,
    String title,
    String price,
    String description,
    String image,
    String? category,
    List nameArray,
    bool onRent,
    bool rentTimeCompleted,
    String uploaderImage,
    String user_id) async {
  try {
    if (price.isNotEmpty || title.isNotEmpty || description.isNotEmpty) {
      String names = await currentUserName();
      String userid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .set({
        "onRent": onRent,
        "rentTimeCompleted": rentTimeCompleted,
        "uploaderImage": uploaderImage,
        "user_id": user_id,
        "title": title,
        "price": price,
        "description": description,
        "imageUrl": image,
        "category": category,
        "uploadedTime": Timestamp.now(),
        "uploadedBy": names,
        "user_id": userid,
        "nameArray": nameArray,
        "productId": productId
      });
    }
    Get.snackbar('Updated Product', 'Successfully');
  } catch (e) {
    Get.snackbar('Error in Updating', e.toString());
  }
}

Future addCategory(String catName) async {
  try {
    if (catName.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(catName)
          .set({"name": catName});
    }
  } catch (e) {
    print(e.toString());
  }
}
