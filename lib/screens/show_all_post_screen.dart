import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_project/controller/post_controller.dart';
import 'package:getx_project/models/post_model.dart';

import 'package:getx_project/screens/chats/rooms.dart';

import 'package:getx_project/screens/comment_screen.dart';
import 'package:getx_project/screens/create_post_screen.dart';
import 'package:getx_project/screens/sign_in.dart';

import 'package:getx_project/screens/user_profile_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/user_model_meta_data.dart';

class AllPostScreen extends StatefulWidget {
  const AllPostScreen({
    super.key,
  });

  @override
  State<AllPostScreen> createState() => _AllPostScreenState();
}

class _AllPostScreenState extends State<AllPostScreen> {
  // late final UserModelFireBase dataOfUser;

  final auth = FirebaseAuth.instance;
  CollectionReference userReference =
      FirebaseFirestore.instance.collection("users");
  CollectionReference postsReference =
      FirebaseFirestore.instance.collection("posts");
  User? user = FirebaseAuth.instance.currentUser;
  Future<UserProfileModel> getdata() async {
    DocumentSnapshot ref = await userReference.doc(user!.uid).get();
    // ignore: unused_local_variable
    UserProfileModel data = UserProfileModel.fromDocumentSnapshot(ref);

    return data;
  }

  getUserData() async {
    CollectionReference userReference =
        FirebaseFirestore.instance.collection("users");
    // ignore: unused_local_variable
    DocumentSnapshot ref = await userReference.doc(user!.uid).get();
  }

  late final userID;

  @override
  void initState() {
    super.initState();
    // ignore: unused_local_variable
    var res = getdata();
  }

  getUser() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userID = currentUser.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getdata(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: FutureBuilder(
                  future: userReference.doc(userID).get(),
                  builder: (context, snapshot) {
                    UserProfileModel detail =
                        UserProfileModel.fromDocumentSnapshot(snapshot.data!);
                    return Center(
                      child: TextButton(
                          onPressed: () {
                            CreatePostScreen(
                              userDetail: detail,
                            );
                          },
                          child: const Text("New post")),
                    );
                  }),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            // UserProfileModel data = snapshot.data!;
            UserProfileModel userdetail = snapshot.data!;

            return GetBuilder<CreatePostControllerFirebase>(
                init: CreatePostControllerFirebase(),
                builder: (_) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: DefaultTabController(
                      length: 4,
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
                                              Get.offAll(const RoomsPage());
                                            },
                                            icon: const Icon(Icons.chat)),
                                      ),
                                      Tab(
                                        icon: IconButton(
                                            onPressed: () {
                                              Get.offAll(CreatePostScreen(
                                                  userDetail: userdetail));

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
                                                    userdetail.firstName == null
                                                        ? Container(
                                                            color: Colors.grey,
                                                          )
                                                        : Image.network(
                                                            userdetail
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
                                  auth.signOut().then((value) =>
                                      Get.offAll(const SignInScreen()));
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
                                                                  CommentsBoxScreen(
                                                                postdetail:
                                                                    postDetail,
                                                                userdetail:
                                                                    userdetail,
                                                              ));
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
                          backgroundColor: Colors.amber,
                          onPressed: () {},
                          child: const Icon(
                            MdiIcons.bookEdit,
                          ),
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
