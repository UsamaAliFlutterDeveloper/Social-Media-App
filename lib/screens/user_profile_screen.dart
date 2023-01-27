import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_project/controller/image_controller.dart';
import 'package:getx_project/models/post_model.dart';
import 'package:getx_project/models/user_model_meta_data.dart';
import 'package:getx_project/screens/comment_screen.dart';

import 'package:getx_project/screens/show_all_post_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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

  CollectionReference postReference =
      FirebaseFirestore.instance.collection("posts");
  User? user = FirebaseAuth.instance.currentUser;
  Future<UserProfileModel> getdata() async {
    DocumentSnapshot ref = await userReference.doc(user!.uid).get();
    UserProfileModel data = UserProfileModel.fromDocumentSnapshot(ref);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfileModel>(
        future: getdata(),
        builder:
            (BuildContext context, AsyncSnapshot<UserProfileModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return const Center(
                child: Text("null"),
              );
            }
            UserProfileModel detail = snapshot.data!;
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
                        accountName: Text(detail.firstName),
                        accountEmail: Text(detail.metadata.email)),
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
                          Get.to(const AllPostScreen());
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
                        onPressed: () {},
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
                                          top: 100,
                                          left: 0,
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
                                                  : Container()),
                                        ),
                                      ],
                                    )
                                  : Stack(
                                      alignment: Alignment.bottomLeft,
                                      clipBehavior: Clip.none,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              _.pickUserCoverImage(context);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 30,
                                              ),
                                              height: 200,
                                              width: Get.width,
                                              child: Image.network(
                                                detail.coverImageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                        InkWell(
                                          onTap: () {
                                            _.pickUserProfileImage(context);
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: SizedBox(
                                              height: 80,
                                              width: 80,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Image.network(
                                                    detail.profileImageUrl,
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                            }),
                        Expanded(
                          child: FutureBuilder(
                              future: postReference
                                  .where('uid', isEqualTo: user!.uid)
                                  .get(),
                              builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) =>
                                  snapshot.data != null
                                      ? ListView.builder(
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            Map<String, dynamic> data = snapshot
                                                .data!.docs[index]
                                                .data() as Map<String, dynamic>;
                                            PostModel postDetail =
                                                PostModel.fromJson(
                                                    data,
                                                    snapshot
                                                        .data!.docs[index].id);

                                            return Card(
                                              child: SizedBox(
                                                height: 350,
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      leading: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: SizedBox(
                                                          height: 50,
                                                          width: 50,
                                                          child:
                                                              // ignore: unnecessary_null_comparison
                                                              postDetail.userImageUrl ==
                                                                      ""
                                                                  ? Container(
                                                                      color: Colors
                                                                          .grey,
                                                                    )
                                                                  : Image
                                                                      .network(
                                                                      postDetail
                                                                          .userImageUrl,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                        ),
                                                      ),
                                                      title: Text(
                                                          postDetail.username),
                                                      subtitle: Text(postDetail
                                                          .datetimepost),
                                                    ),
                                                    Expanded(
                                                        child: postDetail
                                                                    .postImageUrl ==
                                                                ""
                                                            ? Container(
                                                                color:
                                                                    Colors.grey,
                                                              )
                                                            : Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        image:
                                                                            DecorationImage(
                                                                  image:
                                                                      NetworkImage(
                                                                    postDetail
                                                                        .postImageUrl,
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )),
                                                              )),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon:
                                                                    const Icon(
                                                                  MdiIcons
                                                                      .thumbUp,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            const Text(
                                                              "Like",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
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
                                                                  Get.to(CommentsBoxScreen(
                                                                      postdetail:
                                                                          postDetail,
                                                                      userdetail:
                                                                          detail));
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  MdiIcons
                                                                      .comment,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            const Text(
                                                              "Comments",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon:
                                                                    const Icon(
                                                                  MdiIcons
                                                                      .share,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            const Text(
                                                              "Share",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
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
                                        )
                                      : const Center(
                                          child: Text("No Posts"),
                                        )),
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
