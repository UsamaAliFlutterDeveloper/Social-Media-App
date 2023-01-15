import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostControllerFirebase extends GetxController {
  TextEditingController postTextcontroller = TextEditingController();

  CollectionReference postsReference =
      FirebaseFirestore.instance.collection("posts");
  File? postimageFile;

  String imageUpdateKey = "imageUpdatekey";

  pickUserPostImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.camera);

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
        postimageFile = File(croppedFile.path);
        debugPrint("image.path: ${image.path}");
        update([imageUpdateKey]);
        // ignore: use_build_context_synchronously

      }
    }
  }

  void addPostToFirestore(
      {required String posttext,
      required String userimageurl,
      required String username}) async {
    User? user = FirebaseAuth.instance.currentUser;
    // ignore: non_constant_identifier_names
    String UniqueName = DateTime.now().microsecondsSinceEpoch.toString();

    final storageRef = FirebaseStorage.instance
        .ref()
        .child("UsersProfilePhoto/")
        .child("/$UniqueName");
    try {
      // store the file
      await storageRef.putFile(postimageFile!);

      /// Send Image URL to Firestore
      String imagePostUrl = "";
      imagePostUrl = await storageRef.getDownloadURL();
      // ignore: unnecessary_null_comparison
      if (imagePostUrl != null) {
        String uid = '';
        //print("uid:$uid");
        if (user != null) {
          uid = user.uid;
        }
        debugPrint("uid:$uid");
        // var format = DateFormat.yMd('ar');
        // var nowdatetime = format.format(DateTime.now());
        String nowdatetime = DateTime.now().microsecondsSinceEpoch.toString();
        Map<String, dynamic> data = {
          "uid": uid,
          "posttext": posttext,
          "userImageUrl": userimageurl,
          "datetimepost": nowdatetime,
          "username": username,
          "postImageUrl": imagePostUrl
        };

        postsReference
            .add(data)
            .then((value) => debugPrint("Successfully add to firestore"))
            .onError((error, stacktrace) => debugPrint("Error $error"));
        // try {
        //   DocumentReference currentPostReference = postReference.doc(uid);
        //   await currentPostReference.update({"postImageUrl": imagePostUrl});
        //   return true;
        // } on Exception catch (e) {
        //   print("post img error");
        //   return false;
        // }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
