import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:the_olx/logic/dataController.dart';
import 'package:the_olx/logic/imageUpload.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future addData(String email, name, gender, userId, uid, Uint8List? image,
    int number, String address) async {
  try {
    if (email.isNotEmpty ||
        name.isNotEmpty ||
        gender.isNotEmpty ||
        number != null) {
      String imageurl =
          await ImageUpload().uploadImages('Profile Pictures', name, image!);
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        "email": email,
        "name": name,
        "gender": gender,
        "imageUrl": imageurl,
        "uid": uid,
        "number": number,
        "role": "user",
        "productsByUser": [],
        "address": address
      });
    }
  } catch (e) {
    print(e.toString());
  }
}

Future addRentData(
    DateTime days,
    String cityName,
    String rentRoomId,
    List userList,
    String productName,
    String productPrice,
    String productImage,
    dynamic overallPrice,
    String productBy,
    String rentBy) async {
  try {
    if (cityName.isNotEmpty ||
        rentRoomId.isNotEmpty ||
        userList.isNotEmpty ||
        productName.isNotEmpty ||
        productPrice.isNotEmpty ||
        productImage.isNotEmpty ||
        overallPrice.isNotEmpty ||
        productBy.isNotEmpty ||
        rentBy.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(rentRoomId)
          .update({'onRent': true});
      await FirebaseFirestore.instance
          .collection('productOnRent')
          .doc(rentRoomId)
          .set({
        "days": days,
        "cityName": cityName,
        "users": userList,
        "approvedStatues": false,
        "timeCompleted": false,
        "uploadDate": DateTime.now(),
        "productName": productName,
        "productPrice": productPrice,
        "productImage": productImage,
        "overallPrice": overallPrice,
        "productBy": productBy,
        "doc_name": rentRoomId,
        "rentBy": rentBy
      });
    }
  } catch (e) {}
}

Future currentUserName() async {
  DocumentSnapshot snap = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
  var userData = snap.data() as Map<String, dynamic>;
  var username = userData['name'];

  return username;
}

Future deleteFunction(String productName) async {
  await FirebaseFirestore.instance
      .collection('products')
      .doc(productName)
      .delete();
  await FirebaseFirestore.instance
      .collection('productOnRent')
      .doc(productName)
      .delete();
  await FirebaseFirestore.instance
      .collection('ratings')
      .doc(productName)
      .delete();
  Get.snackbar('Product Delete', 'Product Successfully Deleted');
}

Future deleteRequest(productName) async {
  await FirebaseFirestore.instance
      .collection('productOnRent')
      .doc(productName)
      .delete();
  Get.snackbar('Product Delete', 'Request Deleted Successfully');
}

Future updateDataFunction(
    String userId, String email, name, gender, imgUrl, role, number) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    "name": name,
    "email": email,
    "gender": gender,
    "imageUrl": imgUrl,
    "role": role,
    "number": number,
    "uid": userId
  });
}

Future createChatRoom(
    String chatRoomId, Map<String, dynamic> chatRoomMap) async {
  FirebaseFirestore.instance
      .collection("chatRooms")
      .doc(chatRoomId)
      .set(chatRoomMap);
}

Future sendAMessageFunction(
  String chatRoomId,
  String message,
  String sentBy,
  String type,
  Uint8List? image,
) async {
  if (type == "text") {
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .add({
      'message': message,
      'sentBy': sentBy,
      'type': type,
      'timeSent': DateTime.now()
    });
  } else if (type == "image") {
    String imgUrl = await uploadMessageImages(image!);
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .add({
      'message': imgUrl,
      'sentBy': sentBy,
      'type': type,
      'timeSent': DateTime.now()
    });
  }
}

Future<String> uploadMessageImages(Uint8List image) async {
  String childName = Uuid().v1();
  Reference ref = FirebaseStorage.instance
      .ref()
      .child('ChatImages')
      .child('${childName}.jpg');
  UploadTask uploadTask = ref.putData(image);
  TaskSnapshot taskSnapshot = await uploadTask;
  String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}

Future uploadRatings(String productId, String rating) async {
  List productRatings = await DataController().getProductRatings(productId);
  productRatings.add(rating);

  FirebaseFirestore.instance
      .collection('ratings')
      .doc(productId)
      .set({"ratings": productRatings});
  double ratings = await getRatings(productId);
  print(ratings);
  await FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .update({"ratings": ratings.toStringAsFixed(1)});
}

Future<double> getRatings(String productId) async {
  double sum = 0;
  DocumentSnapshot snap = await FirebaseFirestore.instance
      .collection('ratings')
      .doc(productId)
      .get();
  var ratingData = snap.data() as Map<String, dynamic>;
  var ratingArray = ratingData['ratings'];
  for (int i = 0; i < ratingArray.length; i++) {
    sum += double.parse(ratingArray[i]);
  }

  double rating = sum / ratingArray.length;

  return rating;
}

// Future getRatingCount(String productId) async {
//   DocumentSnapshot snap = await FirebaseFirestore.instance
//       .collection('ratings')
//       .doc(productId)
//       .get();
//   var ratingData = snap.data() as Map<String, dynamic>;
//   var ratingArray = ratingData['ratings'];
//   return ratingArray.length;
// }
