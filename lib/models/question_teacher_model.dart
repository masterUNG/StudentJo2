// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionTeacherModel {
  final String numberAnswer;
  final String question;
  final String textAnswer;
  final String typeAnswer;
  final bool yesNoAnswer;
  final Timestamp timestamp;
  final int status;
  final List<String> uidStudent;
  final int weight;
  final bool active;
  final bool allowAnswer;

  QuestionTeacherModel({
    required this.numberAnswer,
    required this.question,
    required this.textAnswer,
    required this.typeAnswer,
    required this.yesNoAnswer,
    required this.timestamp,
    required this.status,
    required this.uidStudent,
    required this.weight,
    required this.active,
    required this.allowAnswer,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'numberAnswer': numberAnswer,
      'question': question,
      'textAnswer': textAnswer,
      'typeAnswer': typeAnswer,
      'yesNoAnswer': yesNoAnswer,
      'timestamp': timestamp,
      'status': status,
      'uidStudent': uidStudent,
      'weight': weight,
      'active': active,
      'allowAnswer': allowAnswer,
    };
  }

  factory QuestionTeacherModel.fromMap(Map<String, dynamic> map) {
    return QuestionTeacherModel(
      numberAnswer: (map['numberAnswer'] ?? '') as String,
      question: (map['question'] ?? '') as String,
      textAnswer: (map['textAnswer'] ?? '') as String,
      typeAnswer: (map['typeAnswer'] ?? '') as String,
      yesNoAnswer: (map['yesNoAnswer'] ?? false) as bool,
      timestamp: (map['timestamp'] ?? Timestamp(0, 0) ),
      status: (map['status'] ?? 0) as int,
      uidStudent: List<String>.from(map['uidStudent'] ?? []),
      weight: (map['weight'] ?? 0) as int,
      active: (map['active'] ?? false) as bool,
      allowAnswer: (map['allowAnswer'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionTeacherModel.fromJson(String source) =>
      QuestionTeacherModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
