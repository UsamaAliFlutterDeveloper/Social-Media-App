import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx_project/controller/signup_controller.dart';
import 'package:getx_project/notification%20services/local_notification_service.dart';
import 'package:getx_project/screens/sign_in.dart';

import 'package:getx_project/widgets/custom_text.dart';
import '../widgets/text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        // ignore: avoid_print
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          // ignore: avoid_print
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        // ignore: avoid_print
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          // ignore: avoid_print
          print(message.notification!.title);
          // ignore: avoid_print
          print(message.notification!.body);
          // ignore: avoid_print
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        // ignore: avoid_print
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          // ignore: avoid_print
          print(message.notification!.title);
          // ignore: avoid_print
          print(message.notification!.body);
          // ignore: avoid_print
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfffbbb04),
      //////////////////////App Bar ///////////////////////////
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 25,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CustomText(
                  text: "Sign In",
                  textColor: Colors.black,
                  textFontSize: 16.toDouble(),
                  textWeight: FontWeight.w600,
                  textAlign: TextAlign.justify,
                ),
              ))
        ],
      ),
      //////////////////////Sign Up Screen Body Start///////////////////////////
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: "Sign Up",
                      textColor: Colors.black,
                      textWeight: FontWeight.bold,
                      textFontSize: 36.toDouble(),
                      textAlign: TextAlign.start),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomText(
                      text:
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
                      textColor: Colors.black,
                      textWeight: FontWeight.w500,
                      textFontSize: 14.toDouble(),
                      textAlign: TextAlign.start),
                ],
              ),
            ),
            //////////////////////Sign Up Textformfield///////////////////////////
            Positioned(
              top: 175,
              child: Container(
                height: 600,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: GetBuilder<SignupScreenController>(
                  init: SignupScreenController(),
                  builder: (_) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Form(
                        key: _.signupformkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextFieldCustomWidget(
                              hinttext: _.nametext,
                              icons: _.personicons,
                              controller: _.fullNameController,
                              validator: _.validateName,
                            ),
                            TextFieldCustomWidget(
                              hinttext: _.emailtext,
                              icons: _.emailicons,
                              controller: _.emailController,
                              validator: _.validateEmail,
                            ),
                            TextFieldCustomWidget(
                              hinttext: _.phonetext,
                              icons: _.phoneicons,
                              controller: _.phoneNoController,
                              validator: _.validatePhone,
                            ),
                            TextFieldCustomWidget(
                              hinttext: _.passwordtext,
                              icons: _.passwordicons,
                              controller: _.passwordController,
                              validator: _.validatePassword,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: CustomText(
                                  text: "Forgot Password?",
                                  textColor: Colors.black,
                                  textWeight: FontWeight.w500,
                                  textFontSize: 14.toDouble(),
                                  textAlign: TextAlign.end),
                            ),

                            //////////////////////Sign Up Button///////////////////////////
                            GestureDetector(
                              onTap: () async {
                                if (_.signupformkey.currentState!.validate()) {
                                  await _.signUpUser(
                                      email: _.emailController.text,
                                      password: _.passwordController.text,
                                      fullName: _.fullNameController.text,
                                      phoneNo: _.phoneNoController.text);

                                  Get.to(const SignInScreen());
                                  _.onPressedSignUp();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, bottom: 50),
                                child: Container(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: CustomText(
                                        text: "Sign Up",
                                        textColor: Colors.white,
                                        textWeight: FontWeight.bold,
                                        textFontSize: 18.toDouble(),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
