// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String name;
  final String detail;
  final String urlVideo;
  final String urlThumnall;
  final bool show;
  final Timestamp timestamp;
  final String uidTeacher;
  

  VideoModel({
    required this.name,
    required this.detail,
    required this.urlVideo,
    required this.urlThumnall,
    required this.show,
    required this.timestamp,
    required this.uidTeacher,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'detail': detail,
      'urlVideo': urlVideo,
      'urlThumnall': urlThumnall,
      'show': show,
      'timestamp': timestamp,
      'uidTeacher': uidTeacher,
    };
  }

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
       name: (map['name'] ?? '') as String,
      detail: (map['detail'] ?? '') as String,
      urlVideo: (map['urlVideo'] ?? '') as String,
      urlThumnall: (map['urlThumnall'] ?? '') as String,
      show: (map['show'] ?? false) as bool,
      timestamp: (map['timestamp'] ?? Timestamp(0, 0)),
      uidTeacher: (map['uidTeacher'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoModel.fromJson(String source) =>
      VideoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
