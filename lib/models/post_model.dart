class PostModel {
  PostModel({
    required this.username,
    required this.posttext,
    required this.datetimepost,
    required this.id,
    required this.uid,
    required this.userImageUrl,
    required this.postImageUrl,
  });
  late final String username;
  late final String posttext;
  late final String datetimepost;
  late final String id;
  late final String uid;
  late final String userImageUrl;
  late final String postImageUrl;
  PostModel.fromJson(Map<String, dynamic> doc, String docId) {
    username = doc['username'] ?? "";
    posttext = doc['posttext'] ?? "";
    datetimepost = doc['datetimepost'] ?? "";
    uid = doc['uid'] ?? "";
    userImageUrl = doc['userImageUrl'] ?? "";
    postImageUrl = doc['postImageUrl'] ?? "";
    id = docId;
  }

  Map<String, dynamic> toJson() {
    // ignore: no_leading_underscores_for_local_identifiers
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['posttext'] = posttext;
    _data['datetimepost'] = datetimepost;
    _data['uid'] = uid;
    _data['id'] = id;
    _data['userImageUrl'] = userImageUrl;
    _data['postImageUrl'] = postImageUrl;
    return _data;
  }
}
