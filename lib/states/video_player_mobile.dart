// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentjo/models/answer_student_model.dart';
import 'package:studentjo/utility/app_dialog.dart';
import 'package:studentjo/widgets/widget_button.dart';
import 'package:studentjo/widgets/widget_form.dart';
import 'package:studentjo/widgets/widget_icon_button.dart';
import 'package:studentjo/widgets/widget_text.dart';
import 'package:studentjo/widgets/widget_text_rich.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:studentjo/models/video_model.dart';
import 'package:studentjo/utility/app_constant.dart';
import 'package:studentjo/utility/app_controller.dart';
import 'package:studentjo/utility/app_service.dart';
import 'package:studentjo/widgets/widget_text_full.dart';

class VideoPlayerMobile extends StatefulWidget {
  const VideoPlayerMobile({
    super.key,
    required this.videoModel,
    required this.docIdVideo,
  });

  final VideoModel videoModel;
  final String docIdVideo;

  @override
  State<VideoPlayerMobile> createState() => _VideoPlayerMobileState();
}

class _VideoPlayerMobileState extends State<VideoPlayerMobile> {
  String? initialVideoId;

  YoutubePlayerController? youtubePlayerController;

  AppController appController = Get.put(AppController());

  TextEditingController numberAnswerController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    setUpVideo();

    //หาให้ได้ว่า ขอมูลของคุณครูทีี่สอน วีดีโอนี่
    AppService().findTeacherUserModel(docId: widget.videoModel.uidTeacher);

    //หาข้อมูลของนักเรียนที่เรียนอยู่ตอนนี้
    AppService().findCurrentUserModels().then((value) {
      //หาโจทย์ ที่คุณครูส่งมา (active --> true)
      AppService().readQuestionByDocVideo(docIdVideo: widget.docIdVideo);
    });
  }

  @override
  void dispose() {
    youtubePlayerController!.pauseVideo();
    super.dispose();
  }

  void setUpVideo() {
    initialVideoId =
        AppService().findIdVideo(urlVideo: widget.videoModel.urlVideo);

    youtubePlayerController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
      ),
    );
    youtubePlayerController!.loadVideoById(videoId: initialVideoId!);
  }

  Widget displayVideo() {
    return YoutubePlayer(
      controller: youtubePlayerController!,
      aspectRatio: 16 / 9,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WidgetTextFull(data: 'Watch Video'),
      ),
      body: Obx(() {
        print(
            '##4jan จำนวน List Answer  --->  ${appController.listAnswerStudentMobileModels.length}');
        return Form(
          key: formKey,
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: ListView(
              children: [
                displayVideo(),
                displayTeacher(),
                listQuestion(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Container listQuestion() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
      decoration: BoxDecoration(border: Border.all()),
      child: appController.qurestionTescherModels.isEmpty
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WidgetText(data: 'ยังไม่มีคำถาม'),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetText(
                  data: 'คำถาม',
                  textStyle: AppConstant().h2Style(),
                ),
                WidgetTextFull(
                    data: appController.qurestionTescherModels.last.question),
                WidgetTextRich(
                    head: 'ชนิดของทำตอบ',
                    tail: appController.qurestionTescherModels.last.typeAnswer),
                appController.qurestionTescherModels.last.allowAnswer
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(border: Border.all()),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WidgetText(
                                  data: 'ส่งคำตอบ',
                                  textStyle: AppConstant()
                                      .h3Style(fontWeight: FontWeight.bold),
                                ),
                                appController.qurestionTescherModels.last
                                            .typeAnswer ==
                                        AppConstant.typeAnswers[0]
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                child: RadioListTile(
                                                  value: true,
                                                  groupValue: appController
                                                      .yesNoAnswers.last,
                                                  onChanged: (value) {
                                                    appController.yesNoAnswers
                                                        .add(value);
                                                  },
                                                  title: const WidgetText(
                                                      data: 'ถูก'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 120,
                                                child: RadioListTile(
                                                  value: false,
                                                  groupValue: appController
                                                      .yesNoAnswers.last,
                                                  onChanged: (value) {
                                                    appController.yesNoAnswers
                                                        .add(value);
                                                  },
                                                  title: const WidgetText(
                                                      data: 'ผิด'),
                                                ),
                                              ),
                                            ],
                                          ),
                                          displayWeightAnswer()
                                        ],
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          WidgetForm(
                                            textEditingController:
                                                numberAnswerController,
                                            validateFunc: (p0) {
                                              if (p0?.isEmpty ?? true) {
                                                return 'กรุณากรอกตัวเลขด้วย คะ';
                                              } else {
                                                return null;
                                              }
                                            },
                                            hintText: 'ใสแต่ตัวเลขเท่านั้น',
                                            textInputType: TextInputType.number,
                                          ),
                                          displayWeightAnswer(),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          appController.displaySumAnswer.value
                              ? Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: Column(
                                    children: [
                                      WidgetText(
                                        data: 'ส่วนของคำตอบ',
                                        textStyle: AppConstant().h3Style(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          WidgetTextRich(
                                              head: 'คำตอบ',
                                              tail: appController
                                                  .showAnswer.value),
                                          WidgetTextRich(
                                              head: 'Weight',
                                              tail: appController
                                                  .showWeight.value),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
    );
  }

  Widget displayWeightAnswer() => Container(
        margin: const EdgeInsets.only(top: 16),
        child: WidgetForm(
          textEditingController: weightController,
          validateFunc: (p0) {
            if (p0?.isEmpty ?? true) {
              return 'กรุณากรอก Weight ด้วยคะ';
            } else {
              return null;
            }
          },
          labelWidget: const WidgetText(data: 'Weight :'),
          textInputType: TextInputType.number,
          subfixWidget: WidgetButton(
            data: 'ส่งคำตอบ',
            pressFunc: () {
              if (formKey.currentState!.validate()) {
                if (appController.qurestionTescherModels.last.typeAnswer ==
                    AppConstant.typeAnswers[0]) {
                  //TrueFasle

                  print('trueFalse');

                  if (appController.yesNoAnswers.last == null) {
                    // No True Fasle
                    AppDialog().normalDialog(
                      title: 'ไม่มีคำตอบถูก/ผิด',
                      contentWidget:
                          const WidgetText(data: 'โปรดเลือกคำตอบ ถูก ผิด ด้วย'),
                    );
                  } else {
                    // OK for True False

                    var answers = <String>[];
                    answers.add(appController.yesNoAnswers.last.toString());

                    var weights = <String>[];
                    weights.add(weightController.text);

                    Map<String, dynamic> mapQuestion =
                        appController.qurestionTescherModels.last.toMap();

                    AnswerStudentModel answerStudentModel = AnswerStudentModel(
                        score: 0,
                        answers: answers,
                        weights: weights,
                        docIdVideo: widget.docIdVideo,
                        docIdQuestion: appController.docIdQuestions.last,
                        timestamp: Timestamp.fromDate(DateTime.now()),
                        mapQuestion: mapQuestion);

                    AppService().insertFirstAnswer(answerStudentModel: answerStudentModel);

                    appController.showAnswer.value =
                        appController.yesNoAnswers.last.toString();
                    appController.showWeight.value = weightController.text;
                    appController.displaySumAnswer.value = true;
                  }
                } else {
                  //OK Number
                  appController.showAnswer.value = numberAnswerController.text;
                  appController.showWeight.value = weightController.text;
                  appController.displaySumAnswer.value = true;
                }
              }
            },
          ),
        ),
      );

  SingleChildRenderObjectWidget displayTeacher() {
    return appController.teacherUserModels.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: WidgetTextFull(
              data: appController.teacherUserModels.last.displayName,
              textStyle: AppConstant().h2Style(),
            ),
          );
  }
}
