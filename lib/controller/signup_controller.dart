import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class SignupScreenController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  GlobalKey<FormState> signupformkey = GlobalKey<FormState>();

  ////////////////////////Variable for text formfield///////////////////////////
  String emailtext = 'Email';
  String passwordtext = 'Password';
  String nametext = ' Full Name';
  String phonetext = 'Phone No';
  Icon personicons = const Icon(Icons.person);
  Icon phoneicons = const Icon(Icons.phone);
  Icon emailicons = const Icon(Icons.email);
  Icon passwordicons = const Icon(Icons.lock);

  ////////////////////////Validation for Email///////////////////////////
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Your Email";
    }
    if (!GetUtils.isEmail(value)) {
      return "Enter Valid Email";
    }
    return null;
  }
  ////////////////////////Validation for Password///////////////////////////

  String? validatePassword(String? value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  ////////////////////////Validation for UserName///////////////////////////

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Your Name";
    }
    if (value.contains('[a-zA-Z]')) {
      return "Enter a Valid Name";
    }
    return null;
  }

  ////////////////////////Validation for Phone No///////////////////////////

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter Your Phone no";
    }
    // if (value.isPhoneNumber) {
    //   return "Enter a Valid Phone no";
    // }
    return null;
  }

  //////////////////////Sign Up on pressed///////////////////////////
  onPressedSignUp() {
    Get.snackbar("Sucessfully Sign Up", "Sign Up Successful",
        animationDuration: const Duration(seconds: 1),
        backgroundColor: Colors.grey,
        colorText: Colors.white,
        padding: const EdgeInsets.all(10));
    Get.defaultDialog(
        title: "Status", content: const Text("Successfully Sign Up"));
  }

///////////////////////////firebase authentication//////////////////////////
  static CollectionReference userReference =
      FirebaseFirestore.instance.collection("users");

  Future<bool> signUpUser({
    required String email,
    required String password,
    required String fullName,
    required String phoneNo,
  }) async {
    bool status = false;
    try {
      status = true;
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? currentUser = credential.user;
      if (currentUser != null) {
        Map<String, dynamic> userMetaData = {
          "phone": phoneNo,
          "email": email,
          "gender": "",
          "education": "",
        };
        await FirebaseChatCore.instance.createUserInFirestore(
          types.User(
              firstName: fullName,
              id: credential.user!.uid,
              imageUrl: 'https://i.pravatar.cc/300?u=$email',
              lastName: fullName,
              metadata: userMetaData),
        );
        // DocumentReference currentUserReference =
        //     userReference.doc(currentUser.uid);
        // Map<String, dynamic> userProfileData = {
        //   "name": fullName.capitalize,
        //   "password": password,
        //   "phone": phoneNo,
        //   "email": email,
        //   "uid": currentUser.uid,
        // };
        // await currentUserReference.set(userProfileData);
      }
      status = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return status;
  }
}
