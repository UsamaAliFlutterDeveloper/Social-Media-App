import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  UserProfileModel({
    required this.id,
    required this.createdAt,
    required this.firstName,
    required this.lastSeen,
    required this.updatedAt,
    required this.metadata,
    required this.profileImageUrl,
    required this.coverImageUrl,
  });
  late final String id;

  late final Timestamp createdAt;
  late final String firstName;
  late final Timestamp lastSeen;
  late final Timestamp updatedAt;
  late final Metadata metadata;
  late final String profileImageUrl;
  late final String coverImageUrl;

  UserProfileModel.fromJson(Map<String, dynamic> json, String docId) {
    id = docId;
    createdAt = json['createdAt'] ?? "";
    firstName = json['firstName'] ?? "";
    lastSeen = json['lastSeen'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    profileImageUrl = json['profileImageUrl'] ??
        "https://e7.pngegg.com/pngimages/178/595/png-clipart-user-profile-computer-icons-login-user-avatars-monochrome-black-thumbnail.png";
    coverImageUrl = json['coverImageUrl'] ??
        "https://e7.pngegg.com/pngimages/178/595/png-clipart-user-profile-computer-icons-login-user-avatars-monochrome-black-thumbnail.png";

    metadata = Metadata.fromJson(json['metadata'] ?? {});
  }
  UserProfileModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    createdAt = json['createdAt'] ?? "";
    firstName = json['firstName'] ?? "";

    lastSeen = json['lastSeen'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    profileImageUrl = json['profileImageUrl'] ??
        "https://e7.pngegg.com/pngimages/178/595/png-clipart-user-profile-computer-icons-login-user-avatars-monochrome-black-thumbnail.png";
    coverImageUrl = json['coverImageUrl'] ??
        "https://e7.pngegg.com/pngimages/178/595/png-clipart-user-profile-computer-icons-login-user-avatars-monochrome-black-thumbnail.png";

    metadata = Metadata.fromJson(json['metadata']);
  }
  Map<String, dynamic> toJson() {
    // ignore: no_leading_underscores_for_local_identifiers
    final _data = <String, dynamic>{};
    _data['createdAt'] = createdAt;
    _data['firstName'] = firstName;

    _data['profileImageUrl'] = profileImageUrl;
    _data['coverImageUrl'] = coverImageUrl;
    _data['lastSeen'] = lastSeen;
    _data['updatedAt'] = updatedAt;
    _data['metadata'] = metadata.toJson();
    return _data;
  }
}

class Metadata {
  Metadata({
    // required this.address,
    // required this.profileImageUrl,
    // required this.dob,
    // required this.gender,
    // required this.lat,
    // required this.lng,
    required this.phone,
    required this.email,
    required this.uid,
  });
  // late final String address;
  // late final String profileImageUrl;
  // late final String dob;
  // late final String gender;
  // late final String lat;
  // late final String lng;
  late final String phone;
  late final String email;
  late final String uid;

  Metadata.fromJson(Map<String, dynamic> json) {
    // address = json['address']??"";
    // profileImageUrl = json['profileImage'] ??
    // "https://e7.pngegg.com/pngimages/178/595/png-clipart-user-profile-computer-icons-login-user-avatars-monochrome-black-thumbnail.png";
    // dob = json['dob']??"";
    // gender = json['gender']??"";
    // lat = json['lat']??"";
    // lng = json['lng']??"";
    phone = json['phone'] ?? "";
    email = json['email'] ?? "";
    uid = json['uid'] ?? "";
  }

  Map<String, dynamic> toJson() {
    // ignore: no_leading_underscores_for_local_identifiers
    final _data = <String, dynamic>{};
    // _data['address'] = address;
    // _data['profileImageUrl'] = profileImageUrl;
    // _data['dob'] = dob;
    // _data['gender'] = gender;
    // _data['lat'] = lat;
    // _data['lng'] = lng;
    _data['phone'] = phone;
    _data['email'] = email;
    _data['uid'] = uid;
    return _data;
  }
}
