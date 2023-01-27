import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getx_project/models/comments_model.dart';
import 'package:getx_project/models/post_model.dart';

import 'package:getx_project/models/user_model_meta_data.dart';

import '../controller/create_comments_controller.dart';

// ignore: must_be_immutable
class CommentsBoxScreen extends StatefulWidget {
  final PostModel postdetail;
  final UserProfileModel userdetail;
  CommentsBoxScreen({
    Key? key,
    required this.postdetail,
    required this.userdetail,
  }) : super(key: key);

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  State<CommentsBoxScreen> createState() => _CommentsBoxScreenState();
}

class _CommentsBoxScreenState extends State<CommentsBoxScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  CollectionReference commentReference =
      FirebaseFirestore.instance.collection("comment");

  CollectionReference postReference =
      FirebaseFirestore.instance.collection("posts");

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: commentReference
            .where("postid", isEqualTo: widget.postdetail.id)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            ///------------With Model--------------------------///
            return Scaffold(
              appBar: AppBar(
                title: const Text("Comment Page"),
                backgroundColor: Colors.amber,
              ),
              // ignore: avoid_unnecessary_containers
              body: Container(
                child: GetBuilder<CreateCommentController>(
                  init: CreateCommentController(),
                  initState: (_) {},
                  builder: (_) {
                    return CommentBox(
                      userImage: CommentBox.commentImageParser(
                          imageURLorPath: widget.userdetail.profileImageUrl),
                      labelText: 'Write a comment...',
                      errorText: 'Comment cannot be blank',
                      withBorder: false,
                      sendButtonMethod: () {
                        if (formKey.currentState!.validate()) {
                          // ignore: avoid_print
                          print(commentController.text);

                          // setState(() {
                          //   var value = {
                          //     'name': widget.userdetail.name,
                          //     'pic': widget.userdetail.profileImageUrl,
                          //     'message': _.commenttextcontroller,
                          //     'date': '2021-01-01 12:00:00'
                          //   };
                          //   // filedata.insert(0, value);
                          // });
                          _.addCommentToFirestore(
                              commenttext: _.commenttextcontroller.text,
                              profileImageUrl:
                                  widget.userdetail.profileImageUrl,
                              username: widget.userdetail.firstName,
                              postid: widget.postdetail.id,
                              datetimepost: widget.postdetail.datetimepost);

                          _.commenttextcontroller.clear();
                          FocusScope.of(context).unfocus();
                        } else {
                          // ignore: avoid_print
                          print("Not validated");
                        }
                      },
                      formKey: formKey,
                      commentController: _.commenttextcontroller,
                      backgroundColor: Colors.amber,
                      textColor: Colors.white,
                      sendWidget: const Icon(Icons.send_sharp,
                          size: 30, color: Colors.white),
                      child: ListView.builder(
                          shrinkWrap: true,
                          //  scrollDirection: Axis.vertical,
                          physics: const ScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> doc =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            String docId = snapshot.data!.docs[index].id;
                            CommentModel commentsdetail =
                                CommentModel.fromJson(doc, docId);
                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                              child: ListTile(
                                leading: GestureDetector(
                                  onTap: () async {
                                    // Display the image in large form.
                                    // ignore: avoid_print
                                    print("Comment Clicked");
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    decoration: const BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            CommentBox.commentImageParser(
                                                imageURLorPath: commentsdetail
                                                    .userImageUrl)),
                                  ),
                                ),
                                title: Text(
                                  widget.userdetail.firstName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(commentsdetail.commenttext),
                                trailing: Text(commentsdetail.datetimecomment,
                                    style: const TextStyle(fontSize: 10)),
                              ),
                            );
                          }),
                    );
                  },
                ),
              ),
            );
          }
          return const Text("Loading");
        });
  }
}
