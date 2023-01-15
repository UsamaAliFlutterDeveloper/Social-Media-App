import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_project/controller/image_controller.dart';
import 'package:getx_project/screens/comment_screen.dart';
import 'package:getx_project/screens/home_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../models/user_model.dart';
import '../widgets/custom_text.dart';
import 'create_post_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  CollectionReference userReference =
      FirebaseFirestore.instance.collection("users");
  User? user = FirebaseAuth.instance.currentUser;
  Future<UserModelFireBase> getdata() async {
    DocumentSnapshot ref = await userReference.doc(user!.uid).get();
    UserModelFireBase data = UserModelFireBase.fromDocumentSnapshot(ref);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModelFireBase>(
        future: getdata(),
        builder:
            (BuildContext context, AsyncSnapshot<UserModelFireBase> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return const Center(
                child: Text("null"),
              );
            }
            UserModelFireBase detail = snapshot.data!;
            return Scaffold(
                resizeToAvoidBottomInset: false,
                //////////////////////App Bar ///////////////////////////
                appBar: AppBar(
                  backgroundColor: Colors.amber,
                  title: const Text("User Profile Screen"),
                  centerTitle: true,
                  elevation: 0,
                  actions: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: CustomText(
                            text: "back",
                            textColor: Colors.white,
                            textWeight: FontWeight.w400,
                            textFontSize: 14.toDouble(),
                            textAlign: TextAlign.end))
                  ],
                ),
                drawer: Drawer(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(detail.coverImageUrl),
                                fit: BoxFit.cover)),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(detail.profileImageUrl),
                        ),
                        accountName: Text(detail.name),
                        accountEmail: Text(detail.email)),
                    TextButton.icon(
                        onPressed: () {
                          Get.to(CreatePostScreen(userDetail: detail));
                        },
                        icon: const Icon(Icons.post_add,
                            size: 30, color: Colors.black),
                        label: CustomText(
                            text: "Create Post Screen",
                            textColor: Colors.black,
                            textWeight: FontWeight.w500,
                            textFontSize: 16.toDouble(),
                            textAlign: TextAlign.start)),
                    TextButton.icon(
                        onPressed: () {
                          Get.to(const HomeScreen());
                        },
                        icon: const Icon(Icons.post_add,
                            size: 30, color: Colors.black),
                        label: CustomText(
                            text: "Home Screen",
                            textColor: Colors.black,
                            textWeight: FontWeight.w500,
                            textFontSize: 16.toDouble(),
                            textAlign: TextAlign.start)),
                    TextButton.icon(
                        onPressed: () {
                          Get.to(const CommentsScreen());
                        },
                        icon: const Icon(Icons.post_add,
                            size: 30, color: Colors.black),
                        label: CustomText(
                            text: "Comment Screen",
                            textColor: Colors.black,
                            textWeight: FontWeight.w500,
                            textFontSize: 16.toDouble(),
                            textAlign: TextAlign.start))
                  ],
                )),
                body: GetBuilder<ImageController>(
                    init: ImageController(),
                    builder: (_) {
                      return Column(children: [
                        GetBuilder<ImageController>(
                            /////////profileimagescreen///////////////
                            id: _.imageUpdateKey,
                            builder: (_) {
                              return _.imageFile != null
                                  ? Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        //////coverimagescreen/////////////
                                        GetBuilder<ImageController>(
                                          id: _.imageUpdateKeyTwo,
                                          builder: (logic) {
                                            return logic.coverFile != null
                                                ? GestureDetector(
                                                    onTap: () {
                                                      logic.pickUserCoverImage(
                                                          context);
                                                      logic
                                                          .uploadCoverImagetoFirebasestorage(
                                                              context);
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 30),
                                                      height: 200,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      color: Colors.grey,
                                                      child: ClipRRect(
                                                        child: SizedBox(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            height: 200,
                                                            child: Image.file(
                                                              logic.coverFile!,
                                                              fit: BoxFit.cover,
                                                            )),
                                                      ),
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                          onTap: () {
                                                            logic
                                                                .pickUserCoverImage(
                                                                    context);
                                                            logic
                                                                .uploadCoverImagetoFirebasestorage(
                                                                    context);
                                                          },
                                                          child: SizedBox(
                                                            height: 200,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Image
                                                                .network(detail
                                                                    .coverImageUrl),
                                                          )),
                                                    ],
                                                  );
                                          },
                                        ),
                                        //////////////////////User Profile image ///////////////////////////
                                        Positioned(
                                          top: 30,
                                          left: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              50,
                                          child: GestureDetector(
                                            onTap: () {
                                              _.pickUserProfileImage(context);
                                            },
                                            child: _.imageFile != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: SizedBox(
                                                        width: 100,
                                                        height: 100,
                                                        child: Image.file(
                                                          _.imageFile!,
                                                          fit: BoxFit.cover,
                                                        )),
                                                  )
                                                : Container(),
                                          ),
                                        ),

                                        Positioned(
                                          top: 90,
                                          left: 150,
                                          child: IconButton(
                                              onPressed: () async {
                                                await _.pickUserProfileImage(
                                                    context);
                                              },
                                              icon: const Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 30,
                                              )),
                                        ),
                                      ],
                                    )
                                  : Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              _.pickUserCoverImage(context);
                                              _.uploadCoverImagetoFirebasestorage(
                                                  context);
                                            },
                                            child: SizedBox(
                                              height: 200,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Image.network(
                                                detail.coverImageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                        Positioned(
                                          left: 160,
                                          top: 105,
                                          child: GestureDetector(
                                            onTap: () {
                                              _.pickUserProfileImage(context);
                                              _.uploadImagetoFirebasestorage(
                                                  context);
                                            },
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child: Image.network(
                                                    detail.profileImageUrl,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                          ),
                                        )
                                      ],
                                    );
                            }),
                        Expanded(
                          child: ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Card(
                                child: SizedBox(
                                  height: 350,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: SizedBox(
                                            height: 50,
                                            width: 50,
                                            child:
                                                // ignore: unnecessary_null_comparison
                                                detail.profileImageUrl == null
                                                    ? Container(
                                                        color: Colors.grey,
                                                      )
                                                    : Image.network(
                                                        detail.profileImageUrl,
                                                        fit: BoxFit.cover,
                                                      ),
                                          ),
                                        ),
                                        title: Text(detail.name),
                                        subtitle: Text(detail.email),
                                      ),
                                      Expanded(
                                          // ignore: unnecessary_null_comparison
                                          child: detail.profileImageUrl == null
                                              ? Container(
                                                  color: Colors.grey,
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                    image: NetworkImage(
                                                        detail.coverImageUrl),
                                                    fit: BoxFit.cover,
                                                  )),
                                                )),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    MdiIcons.thumbUp,
                                                    color: Colors.grey,
                                                  )),
                                              const Text(
                                                "Like",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    Get.to(
                                                        const CommentsScreen());
                                                  },
                                                  icon: const Icon(
                                                    MdiIcons.comment,
                                                    color: Colors.grey,
                                                  )),
                                              const Text(
                                                "Comments",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    MdiIcons.share,
                                                    color: Colors.grey,
                                                  )),
                                              const Text(
                                                "Share",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ]);
                    }));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
