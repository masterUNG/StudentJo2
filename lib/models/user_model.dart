import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String uid;
  final String displayName;
  final String phoneNumber;
  final bool? teacher;
  UserModel({
    required this.uid,
    required this.displayName,
    required this.phoneNumber,
    this.teacher,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'teacher': teacher,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: (map['uid'] ?? '') as String,
      displayName: (map['displayName'] ?? '') as String,
      phoneNumber: (map['phoneNumber'] ?? '') as String,
      teacher: (map['teacher'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
