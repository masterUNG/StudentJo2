import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentjo/models/answer_student_model.dart';
import 'package:studentjo/models/question_teacher_model.dart';
import 'package:studentjo/models/user_model.dart';
import 'package:studentjo/models/video_model.dart';
import 'package:studentjo/state_web/check_otp_web.dart';
import 'package:studentjo/state_web/main_home_web.dart';
import 'package:studentjo/states/check_otp.dart';
import 'package:studentjo/states/main_home.dart';
import 'package:studentjo/utility/app_controller.dart';
import 'package:studentjo/utility/app_dialog.dart';
import 'package:studentjo/widgets/widget_button.dart';
import 'package:studentjo/widgets/widget_form.dart';
import 'package:studentjo/widgets/widget_image_asset.dart';
import 'package:studentjo/widgets/widget_text.dart';

class AppService {
  AppController appController = Get.put(AppController());
  var user = FirebaseAuth.instance.currentUser;

  Future<void> processSentSms({
    required String phoneNumber,
    bool? web,
  }) async {
    bool fromWeb = web ?? false;

    String phone = '+66 ${phoneNumber.substring(1)}';

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 90),
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {
        print('##8jan Error ---> $error');
      },
      codeSent: (verificationId, forceResendingToken) {
        print(
            '##9nov นี่คือ verifyId ที่ได้จาก firebase ----> $verificationId');

        Get.snackbar('Check OTP', 'Sent SMS to $phone');

        if (fromWeb) {
          //Web Stutus
          Get.offAll(CheckOtpWeb(
            verifyID: verificationId,
            phoneNumber: phoneNumber,
          ));
        } else {
          //Mobile Status
          Get.offAll(CheckOtp(
            verifyID: verificationId,
            phoneNumber: phoneNumber,
          ));
        }
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future<void> checkOtp({
    required String otp,
    required String verifyId,
    required String phoneNumber,
    bool? web,
  }) async {
    bool fromWeb = web ?? false;

    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
            verificationId: verifyId, smsCode: otp))
        .then((value) async {
      String uid = value.user!.uid;
      print('uid ที่ login อยู่ ----> $uid, ค่าของ fromWeb --> $fromWeb');

      if (fromWeb) {
        //web

        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .get()
            .then((value) {
          UserModel userModel = UserModel.fromMap(value.data()!);
          appController.currentUserModels.add(userModel);

          print(
              '##23nov ขนาดของ current ที่ otpCheck ---> ${appController.currentUserModels.length}');

          if (userModel.teacher!) {
            //Teacher

            Get.offAll(const MainHomeWeb());
          } else {
            //Student
            AppDialog().normalDialog(
                title: 'คุณไม่ใช่คุณครู',
                contentWidget: WidgetText(
                    data:
                        '${userModel.displayName} เป็น นักเรียน ไม่ใช่คุณครู กรุณา Login ที่ มือถือเท่านั้น'),
                actionWidget: WidgetButton(
                  data: 'รับทราบ',
                  pressFunc: () {
                    Get.back();
                    Get.offAllNamed('/authenWeb');
                  },
                ));
          }
        });
      } else {
        //mobile

        await FirebaseFirestore.instance
            .collection('user')
            .where('phoneNumber', isEqualTo: phoneNumber)
            .get()
            .then((value) {
          if (value.docs.isEmpty) {
            // นี่คือการ login ครัังแรก

            TextEditingController textEditingController =
                TextEditingController();

            AppDialog().normalDialog(
                title: 'คุณเริ่มใช้งานครั้งแรก',
                iconWidget: const WidgetImageAsset(
                  path: 'images/phone.png',
                  size: 150,
                ),
                contentWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const WidgetText(data: 'เราขอ DisplayName ด้วย คะ'),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: WidgetForm(
                        hintText: 'Display Name',
                        textEditingController: textEditingController,
                      ),
                    ),
                    WidgetText(
                        data: 'ไม่เช่นนั้นเราจะเรียกคณว่า Khun$phoneNumber'),
                  ],
                ),
                actionWidget: WidgetButton(
                  data: 'Register',
                  pressFunc: () async {
                    String displayName = textEditingController.text.isEmpty
                        ? 'Khun$phoneNumber'
                        : textEditingController.text;

                    UserModel userModel = UserModel(
                        uid: uid,
                        displayName: displayName,
                        phoneNumber: phoneNumber,
                        teacher: false);

                    await FirebaseFirestore.instance
                        .collection('user')
                        .doc(uid)
                        .set(userModel.toMap())
                        .then((value) {
                      Get.offAll(const MainHome());
                      Get.snackbar(
                          'Register Success', 'Welcome $displayName to My App');
                    });
                  },
                ));
          } else {
            Get.offAll(const MainHome());
          }
        });
      }
    }).catchError((onError) {
      Get.snackbar(onError.code, onError.message,
          backgroundColor: Colors.red, colorText: Colors.white);
    });
  }

  String findThumnalVideo({required String urlVideo}) {
    var strings1 = urlVideo.split('/');

    var strings2 = strings1.last.split('?');

    String urlThumnal = 'https://img.youtube.com/vi/${strings2[0]}/0.jpg';

    print('urlThumnal ----> $urlThumnal');

    return urlThumnal;
  }

  String findIdVideo({required String urlVideo}) {
    var strings1 = urlVideo.split('/');
    var strings2 = strings1.last.split('?');

    return strings2[0];
  }

  Future<void> readVideoTeacher() async {
    await FirebaseFirestore.instance
        .collection('video')
        .where('uidTeacher', isEqualTo: user!.uid)
        .get()
        .then((value) {
      if (appController.videoModels.isNotEmpty) {
        appController.videoModels.clear();
        appController.docIdVideos.clear();
      }

      if (value.docs.isNotEmpty) {
        for (var element in value.docs) {
          VideoModel videoModel = VideoModel.fromMap(element.data());

          appController.videoModels.add(videoModel);

          appController.docIdVideos.add(element.id);
        }
      }
    });
  }

  Future<void> findCurrentUserModels() async {
    var user = await FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((value) {
      if (value.data() != null) {
        UserModel userModel = UserModel.fromMap(value.data()!);
        print('##23nov currentUserModel ---> ${userModel.toMap()}');
        appController.currentUserModels.add(userModel);
        print(
            '##23nov ขนาดของ currentUserModel ที่ findCurrent ---> ${appController.currentUserModels.length}');
      }
    });
  }

  Future<void> processReadAllVideo() async {
    await FirebaseFirestore.instance
        .collection('video')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      if (appController.videoModels.isNotEmpty) {
        appController.videoModels.clear();
      }

      for (var element in value.docs) {
        VideoModel videoModel = VideoModel.fromMap(element.data());

        if (videoModel.show) {
          appController.videoModels.add(videoModel);
          appController.docIdVideos.add(element.id);
        }
      }
    });
  }

  Future<void> findTeacherUserModel({required String docId}) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(docId)
        .get()
        .then((value) {
      UserModel userModel = UserModel.fromMap(value.data()!);
      appController.teacherUserModels.add(userModel);
    });
  }

  Future<void> processInsertQuestion(
      {required QuestionTeacherModel questionTeacherModel,
      required String docVideo}) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('video')
        .doc(docVideo)
        .collection('question')
        .doc();

    await documentReference.set(questionTeacherModel.toMap()).then((value) {
      String docIdQuestion = documentReference.id;
      print('Insert Question Success docIdQuestion ---> $docIdQuestion');

      appController.docIdQuestions.add(docIdQuestion);
      appController.qurestionTescherModels.add(questionTeacherModel);
    });
  }

  Future<void> readQuestionByDocVideo({required String docIdVideo}) async {
    FirebaseFirestore.instance
        .collection('video')
        .doc(docIdVideo)
        .collection('question')
        .where('active', isEqualTo: true)
        .snapshots()
        .listen((event) {
      if (appController.qurestionTescherModels.isNotEmpty) {
        appController.qurestionTescherModels.clear();
        appController.docIdQuestions.clear();

        appController.yesNoAnswers.clear();
        appController.yesNoAnswers.add(null);

        appController.showAnswer.value = '';
        appController.showWeight.value = '';
      }

      if (event.docs.isNotEmpty) {
        event.docs.forEach((element) {
          QuestionTeacherModel questionTeacherModel =
              QuestionTeacherModel.fromMap(element.data());

          appController.qurestionTescherModels.add(questionTeacherModel);

          appController.docIdQuestions.add(element.id);
        });
      }
    });
  }

  Future<void> processAnswerQuestion({
    required String docIdVideo,
    required String docIdQuestion,
    required QuestionTeacherModel questionTeacherModel,
  }) async {
    print('docIdVideo ---> $docIdVideo');
    print('docIdQuestion ---> $docIdQuestion');

    Map<String, dynamic> mapQuestionTeacherModel = questionTeacherModel.toMap();
    var uidStudents = questionTeacherModel.uidStudent;
    uidStudents.add(appController.currentUserModels.last.uid);
    mapQuestionTeacherModel['uidStudent'] = uidStudents;

    await FirebaseFirestore.instance
        .collection('video')
        .doc(docIdVideo)
        .collection('question')
        .doc(docIdQuestion)
        .update(mapQuestionTeacherModel)
        .then((value) {
      Get.snackbar('ตอบคำถาม สำเร็จ', 'ขอบคุณที่ ตอบคำถาม');

      findListAnswer(docIdQuestion: docIdQuestion);
    });
  }

  bool checkStudentTest({required QuestionTeacherModel questionTeacherModel}) {
    bool pass = true; // true --> ยังไม่เคยทำข้อสอบข้อนี้

    var uidStudents = questionTeacherModel.uidStudent;
    if (uidStudents.isNotEmpty) {
      if (uidStudents.contains(appController.currentUserModels.last.uid)) {
        pass = false;
      }
    }
    return true;
  }

  Future<void> processInsertAnswerStudent(
      {required AnswerStudentModel answerStudentModel}) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(appController.currentUserModels.last.uid)
        .collection('answer')
        .doc()
        .set(answerStudentModel.toMap());
  }

  Future<void> findMyStudent({required String docIdVideo}) async {
    FirebaseFirestore.instance
        .collection('user')
        .where('teacher', isEqualTo: false)
        .snapshots()
        .listen((value) {
      //Start
      if (appController.studentUserModels.isNotEmpty) {
        appController.studentUserModels.clear();
        appController.listAnswerStudentModels.clear();
      }

      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          UserModel studentModel = UserModel.fromMap(element.data());
          appController.studentUserModels.add(studentModel);

          FirebaseFirestore.instance
              .collection('user')
              .doc(element.id)
              .collection('answer')
              .where('docIdVideo', isEqualTo: docIdVideo)
              .snapshots()
              .listen((value) {
            var answerStudentModels = <AnswerStudentModel>[];

            if (value.docs.isNotEmpty) {
              value.docs.forEach((element) {
                AnswerStudentModel answerStudentModel =
                    AnswerStudentModel.fromMap(element.data());
                answerStudentModels.add(answerStudentModel);
              });
              print('##2jan work at have data');
              appController.listAnswerStudentModels.add(answerStudentModels);
            } else {
              print('##2jan work at no have data');
              appController.listAnswerStudentModels.add([]);
            }
          });
        });
      }
      //end
    });
  }

  Future<void> findListAnswer({required String docIdQuestion}) async {
    print('##4jan docIdQuestion ----> $docIdQuestion');

    print(
        '##4jan appController.currentUserModels ---> ${appController.currentUserModels.length}');

    await FirebaseFirestore.instance
        .collection('user')
        .doc(appController.currentUserModels.last.uid)
        .collection('answer')
        .orderBy('timestamp')
        // .where('docIdQuestion', isEqualTo: docIdQuestion)
        .get()
        .then((value) {
      print('##4jan value ---> ${value.docs.length}');

      if (appController.listAnswerStudentMobileModels.isNotEmpty) {
        appController.listAnswerStudentMobileModels.clear();
      }

      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          AnswerStudentModel answerStudentModel =
              AnswerStudentModel.fromMap(element.data());

          if (answerStudentModel.docIdQuestion == docIdQuestion) {
            appController.listAnswerStudentMobileModels.add(answerStudentModel);
          }
        });
      }
    });
  }

  bool checkNumber({required String string}) {
    try {
      int.parse(string);
      return false;
    } catch (e) {
      return true;
    }
  }

  Future<void> processEditQuestion({
    required String docIdVideo,
    required String docIdQuestion,
    required Map<String, dynamic> mapQuestion,
  }) async {
    FirebaseFirestore.instance
        .collection('video')
        .doc(docIdVideo)
        .collection('question')
        .doc(docIdQuestion)
        .update(mapQuestion);
  }

  Future<void> insertFirstAnswer(
      {required AnswerStudentModel answerStudentModel}) async {
    var user = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .collection('answer')
        .doc()
        .set(answerStudentModel.toMap());
  }
}
