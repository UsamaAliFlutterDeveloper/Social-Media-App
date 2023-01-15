import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CreateComentsControllerFirebase extends GetxController {
  CollectionReference commentsReference =
      FirebaseFirestore.instance.collection("Comments");
  Future<bool> addCommenttoFirebase() async {
    Map<String, dynamic> commentData = {};
    bool status = false;
    commentsReference.add(commentData).then((value) {
      status = true;
    }).onError((error, stackTrace) {
      status = false;
    });
    return status;
  }
}
