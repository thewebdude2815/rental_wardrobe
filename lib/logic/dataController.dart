import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  Future getData() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('products')
        .where('user_id', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        // .where('uploaded_by', isNotEqualTo: await getUserName())
        .get();
    return snap;
  }

  Future getCategoryWiseData(String category) async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('products')
        .where('user_id', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('category', isEqualTo: category)
        // .where('uploaded_by', isNotEqualTo: await getUserName())
        .get();
    return snap;
  }

  Future getMyData() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('products')
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        // .where('uploaded_by', isNotEqualTo: await getUserName())
        .get();
    return snap;
  }

  Future getCategoryData(String category) async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category)
        .where('uploadedBy', isNotEqualTo: await getUserName())
        .get();
    return snap;
  }

  Future getRentRequest() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('productOnRent')
        .where('users', arrayContains: await getUserName())
        .where('productBy', isNotEqualTo: await getUserName())
        .where('approvedStatues', isEqualTo: false)
        .get();
    return snap;
  }

  Future getPreviousRented() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('productOnRent')
        .where('users', arrayContains: await getUserName())
        .where('productBy', isNotEqualTo: await getUserName())
        .where('approvedStatues', isEqualTo: true)
        .where('timeCompleted', isEqualTo: true)
        .get();
    return snap;
  }

  Future getProductsIRent() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('productOnRent')
        .where('users', arrayContains: await getUserName())
        .where('productBy', isNotEqualTo: await getUserName())
        .where('approvedStatues', isEqualTo: true)
        .where('timeCompleted', isEqualTo: false)
        .get();
    return snap;
  }

  Future getMyProductsOnRent() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('productOnRent')
        .where('users', arrayContains: await getUserName())
        .where('productBy', isEqualTo: await getUserName())
        .where('approvedStatues', isEqualTo: true)
        .get();
    return snap;
  }

  Future getRequestsReceived() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('productOnRent')
        .where('users', arrayContains: await getUserName())
        .where('productBy', isEqualTo: await getUserName())
        .where('approvedStatues', isEqualTo: false)
        .get();
    return snap;
  }

  Future updateRentStatus(String doc_name) async {
    FirebaseFirestore.instance
        .collection('productOnRent')
        .doc(doc_name)
        .update({'approvedStatues': true});
  }

  Future updateTimeCompletedStatus(String doc_name) async {
    FirebaseFirestore.instance
        .collection('productOnRent')
        .doc(doc_name)
        .update({'timeCompleted': true});
    FirebaseFirestore.instance
        .collection('products')
        .doc(doc_name)
        .update({'rentTimeCompleted': true});
  }

  Future getSearchResults(String searchedText) async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('products')
        .where('nameArray', arrayContains: searchedText)
        .where('user_id', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    return snap;
  }

  Future getCategories() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('categories').get();
    return snap;
  }

  Future getUserName() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    var userData = snap.data() as Map<String, dynamic>;
    var username = userData['name'];

    return username;
  }

  Future getUserProductsIds() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    var userData = snap.data() as Map<String, dynamic>;
    var userProductsArray = userData['productsByUser'];
    return userProductsArray;
  }

  Future getProductRatings(String productId) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('ratings')
        .doc(productId)
        .get();
    var userData = snap.data() as Map<String, dynamic>;
    var ratingsArray = userData['ratings'];
    return ratingsArray;
  }

  Future getSpecificUserId(String name) async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: name)
        .get();
  }

  Future currentUserImage() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var userData = snap.data() as Map<String, dynamic>;
    var username = userData['imageUrl'];

    return username;
  }

  Future getUserEmail() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    var userData = snap.data() as Map<String, dynamic>;
    var username = userData['name'];
    var useremail = userData['email'];
    var usernumber = userData['number'];
    var userImage = userData['imageUrl'];
    var userGender = userData['gender'];
    var userId = userData['uid'];
    var userRole = userData['role'];
    var userAddress = userData['address'];
    List<dynamic> userInfo = [
      username,
      useremail,
      usernumber.toString(),
      userImage,
      userGender,
      userId,
      userRole,
      userAddress
    ];

    return userInfo;
  }

  Future getUserRole() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    var userData = snap.data() as Map<String, dynamic>;
    var userrole = userData['role'];

    return userrole;
  }
}
