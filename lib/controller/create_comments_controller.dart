import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

class CreateCommentController extends GetxController {
  // ignore: prefer_final_fields, unused_field
  GlobalKey<FormState> _postformkey = GlobalKey();

  TextEditingController commenttextcontroller = TextEditingController();
  static CollectionReference commentReference =
      FirebaseFirestore.instance.collection("comment");
  User? currentuser = FirebaseAuth.instance.currentUser;

  ///////////////if Create Directory in Firestore////////////////////////
  CollectionReference imagecommentReference =
      FirebaseFirestore.instance.collection("commentImages");
  //////////////////////////////////////////////////////////////////////////////////////////

  File? commentImageFile;
  String commentImageUpdateKey = "commentImageUpdatekey";

  pickPostImage(BuildContext context) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    // final XFile? video = await _picker.pickVideo(source: ImageSource.camera);

    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if (croppedFile != null) {
        commentImageFile = File(croppedFile.path);
        update([commentImageUpdateKey]);
        onInit();
        // await  uploadCommentToFirebase(context);
      }
    }
  }

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
  }

  Future uploadCommentToFirebase(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    // ignore: non_constant_identifier_names
    String UniqueName = DateTime.now().microsecondsSinceEpoch.toString();

    /// UPLOAD IMAGE TO FIREBASE
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference ref =
        storage.ref().child("comment").child(UniqueName);
    try {
      // store the file
      await ref.putFile(commentImageFile!);

      /// Send Image URL to Firestore
      String commentImageUrl = "";
      commentImageUrl = await ref.getDownloadURL();
      String uid = '';
      //print("uid:$uid");
      if (user != null) {
        uid = user.uid;
      }
      try {
        DocumentReference currentcommentReference = commentReference.doc(uid);
        await currentcommentReference
            .update({"commentImageUrl": commentImageUrl});
        return true;
      } on Exception {
        // ignore: avoid_print
        print("comment img error");
        return false;
      }
      // ignore: dead_code
      Map<String, dynamic> data = {
        "uid": uid,
        "image url": commentImageUrl.toString(),
      };

      imagecommentReference
          .add(data)
          // ignore: avoid_print
          .then((value) => print("Successfully add to firestore"))
          // ignore: avoid_print
          .onError((error, stackTrace) => print('Error'));
      // ignore: empty_catches
    } catch (e) {}
  }

  void addCommentToFirestore(
      {required String commenttext,
      required String profileImageUrl,
      required String username,
      required String postid,
      required String datetimepost}) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    // CollectionReference postReference = FirebaseFirestore.instance.collection("post");
    String uid = "";
    if (currentUser != null) {
      uid = currentUser.uid;
    }
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    // DocumentReference currentUserRefrence = commentReference.doc(currentUser!.uid);
    Map<String, dynamic> data = {
      "uid": uid,
      "commenttext": commenttext,
      "userImageUrl": profileImageUrl,
      "datetimecomment": formattedDate,
      "username": username,
      "postid": postid,
      "datetimepostid": datetimepost
    };
    commentReference
        .add(data)
        // ignore: avoid_print
        .then((value) => print("Successfully add to firestore"))
        // ignore: avoid_print
        .onError((error, stacktrace) => print("Error $error"));
  }
}
