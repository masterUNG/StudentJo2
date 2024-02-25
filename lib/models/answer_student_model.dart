// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerStudentModel {
  final int score;
  final List<String> answers;
  final List<String> weights;
  final String docIdVideo;
  final String docIdQuestion;
  final Timestamp timestamp;
  final Map<String, dynamic> mapQuestion;
  AnswerStudentModel({
    required this.score,
    required this.answers,
    required this.weights,
    required this.docIdVideo,
    required this.docIdQuestion,
    required this.timestamp,
    required this.mapQuestion,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'score': score,
      'answers': answers,
      'weights': weights,
      'docIdVideo': docIdVideo,
      'docIdQuestion': docIdQuestion,
      'timestamp': timestamp,
      'mapQuestion': mapQuestion,
    };
  }

  factory AnswerStudentModel.fromMap(Map<String, dynamic> map) {
    return AnswerStudentModel(
      score: (map['score'] ?? 0) as int,
      answers: List<String>.from((map['answers'] ?? const <String>[]) as List<String>),
      weights: List<String>.from((map['weights'] ?? const <String>[]) as List<String>),
      docIdVideo: (map['docIdVideo'] ?? '') as String,
      docIdQuestion: (map['docIdQuestion'] ?? '') as String,
      timestamp: (map['timestamp'] ?? Timestamp(0, 0)),
      mapQuestion: Map<String, dynamic>.from(map['mapQuestion'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory AnswerStudentModel.fromJson(String source) => AnswerStudentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
