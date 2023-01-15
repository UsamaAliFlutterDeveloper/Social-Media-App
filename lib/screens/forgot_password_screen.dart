import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_project/controller/forgot_password_controller.dart';
import 'package:getx_project/screens/sign_in.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPassword>(
      init: ForgotPassword(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text("Reset"),
        ),
        body: isLoading == false
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _.email,
                      decoration: const InputDecoration(hintText: "Email"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.purple),
                        ),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });

                          _
                              .resetPassword(
                            email: _.email.text.trim(),
                          )
                              .then((value) {
                            if (value == "Email sent") {
                              setState(() {
                                isLoading = false;
                              });
                              Get.to(const SignInScreen());
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(value)));
                            }
                          });
                        },
                        child: const Text("Reset account")),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Text("Already have an account? Login "),
                    ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
