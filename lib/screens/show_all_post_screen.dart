import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_project/controller/create_post_controller.dart';
import 'package:getx_project/models/post_model.dart';

import 'package:getx_project/screens/comment_screen.dart';
import 'package:getx_project/screens/sign_in.dart';

import 'package:getx_project/screens/user_profile_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../Models/user_model.dart';
import 'chat/rooms.dart';

class AllPostScreen extends StatefulWidget {
  const AllPostScreen({
    super.key,
  });

  @override
  State<AllPostScreen> createState() => _AllPostScreenState();
}

class _AllPostScreenState extends State<AllPostScreen> {
  final auth = FirebaseAuth.instance;
  CollectionReference userReference =
      FirebaseFirestore.instance.collection("users");
  CollectionReference postsReference =
      FirebaseFirestore.instance.collection("posts");
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
            UserModelFireBase detail = snapshot.data!;
            return GetBuilder<CreatePostControllerFirebase>(
                init: CreatePostControllerFirebase(),
                builder: (_) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: DefaultTabController(
                      length: 3,
                      child: Scaffold(
                        appBar: AppBar(
                          backgroundColor: const Color(0xfffbbb04),
                          bottom: PreferredSize(
                            preferredSize: const Size.fromHeight(90.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  TabBar(
                                    tabs: [
                                      Tab(
                                        icon: IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.home)),
                                      ),
                                      Tab(
                                        icon: IconButton(
                                            onPressed: () {
                                              Get.to(const UserProfileScreen());
                                            },
                                            icon: const Icon(Icons.person)),
                                      ),
                                      Tab(
                                        icon: IconButton(
                                            onPressed: () {
                                              Get.to(const RoomsPage());
                                            },
                                            icon: const Icon(Icons.post_add)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child:
                                                    // ignore: unnecessary_null_comparison
                                                    detail.profileImageUrl ==
                                                            null
                                                        ? Container(
                                                            color: Colors.grey,
                                                          )
                                                        : Image.network(
                                                            detail
                                                                .profileImageUrl,
                                                            fit: BoxFit.cover,
                                                          ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                            vertical: 15.0,
                                                            horizontal: 15),
                                                    fillColor:
                                                        const Color.fromARGB(
                                                            255, 241, 240, 240),
                                                    filled: true,
                                                    hintText:
                                                        "    What's on your mind, Usama?",
                                                    border: InputBorder.none,
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                50),
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 1.3,
                                                                color: Colors
                                                                    .grey)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(50),
                                                        borderSide: const BorderSide(color: Colors.grey, width: 1.3))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          title: const Text(
                            'New Feed',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white),
                          ),
                          actions: [
                            IconButton(
                                onPressed: () {
                                  auth.signOut().then(
                                      (value) => Get.to(const SignInScreen()));
                                },
                                icon: const Icon(Icons.logout))
                          ],
                        ),
                        body: TabBarView(
                          children: [
                            FutureBuilder<QuerySnapshot>(
                              future: postsReference.get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasData) {
                                  if (snapshot.data != null) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        Map<String, dynamic> doc =
                                            snapshot.data!.docs[index].data()
                                                as Map<String, dynamic>;
                                        String docId =
                                            snapshot.data!.docs[index].id;
                                        PostModel postDetail =
                                            PostModel.fromJson(doc, docId);
                                        return Card(
                                          child: SizedBox(
                                            height: 350,
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child:
                                                          // ignore: unnecessary_null_comparison
                                                          postDetail.userImageUrl ==
                                                                  null
                                                              ? Container(
                                                                  color: Colors
                                                                      .grey,
                                                                )
                                                              : Image.network(
                                                                  postDetail
                                                                      .userImageUrl,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                    ),
                                                  ),
                                                  title:
                                                      Text(postDetail.username),
                                                  subtitle: Text(
                                                      postDetail.datetimepost),
                                                ),
                                                Expanded(
                                                    child:
                                                        // ignore: unnecessary_null_comparison
                                                        postDetail.postImageUrl ==
                                                                null
                                                            ? Container(
                                                                color:
                                                                    Colors.grey,
                                                              )
                                                            : Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        image:
                                                                            DecorationImage(
                                                                  image: NetworkImage(
                                                                      postDetail
                                                                          .postImageUrl),
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
                                                            onPressed: () {},
                                                            icon: const Icon(
                                                              MdiIcons.thumbUp,
                                                              color:
                                                                  Colors.grey,
                                                            )),
                                                        const Text(
                                                          "Like",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
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
                                                              color:
                                                                  Colors.grey,
                                                            )),
                                                        const Text(
                                                          "Comments",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
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
                                                              color:
                                                                  Colors.grey,
                                                            )),
                                                        const Text(
                                                          "Share",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
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
                                    );
                                  }
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                            const Icon(Icons.directions_transit),
                            const Icon(Icons.directions_bike),
                          ],
                        ),
                        floatingActionButton: FloatingActionButton(
                          onPressed: () {},
                          child: const Icon(MdiIcons.bookEdit),
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
