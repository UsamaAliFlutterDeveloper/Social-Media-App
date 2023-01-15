import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModel {
  late final String id;
  late final String commentText;
  late final String uid;
  late final String profileImageUrl;
  late final String postId;
  late final String dateTime;
  late final int commentsCount;
  late final String userName;

  // default constructor
  CommentsModel({
    required this.uid,
    required this.id,
    required this.commentText,
    required this.profileImageUrl,
    required this.postId,
    required this.dateTime,
    required this.commentsCount,
    required this.userName,
  });

  // for post creation
  CommentsModel.withoutId({
    required this.uid,
    required this.commentText,
    required this.profileImageUrl,
    required this.postId,
    required this.dateTime,
    required this.userName,
  });
  // when we read data from firebase this will be used for converting DocumentSnapshot to model object
  CommentsModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    uid = documentSnapshot['uid'] ?? "";
    commentText = documentSnapshot["commentText"];
    postId = documentSnapshot["postId"] ?? "";
    profileImageUrl = documentSnapshot["profileImageUrl"] ?? "";
    commentsCount = documentSnapshot["commentsCount"] ?? 0;
    dateTime = documentSnapshot["dateTime"] ?? DateTime.now().toString();
    userName = documentSnapshot["userName"];
  }

  // this will be used to convert CommentsModel.withoutId to Map<String,dynamic>
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['commentText'] = commentText;
    data['postId'] = postId;
    data['profileImageUrl'] = profileImageUrl;
    data['dateTime'] = dateTime;
    data['userName'] = userName;
    return data;
  }
}
