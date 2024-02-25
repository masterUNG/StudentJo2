// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:studentjo/models/question_teacher_model.dart';
import 'package:studentjo/models/video_model.dart';
import 'package:studentjo/utility/app_constant.dart';
import 'package:studentjo/utility/app_controller.dart';
import 'package:studentjo/utility/app_service.dart';
import 'package:studentjo/widgets/widget_button.dart';
import 'package:studentjo/widgets/widget_form.dart';
import 'package:studentjo/widgets/widget_text.dart';
import 'package:studentjo/widgets/widget_text_full.dart';

class VideoPlayerWeb extends StatefulWidget {
  const VideoPlayerWeb({
    Key? key,
    required this.videoModel,
    required this.docVideo,
  }) : super(key: key);

  final VideoModel videoModel;
  final String docVideo;

  @override
  State<VideoPlayerWeb> createState() => _VideoPlayerWebState();
}

class _VideoPlayerWebState extends State<VideoPlayerWeb> {
  String? initialVideoId;

  YoutubePlayerController? youtubePlayerController;

  AppController appController = Get.put(AppController());

  final formKey = GlobalKey<FormState>();

  TextEditingController questionController = TextEditingController();
  TextEditingController descripNumberController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();

    appController.chooseTypeAnswers.clear();
    appController.chooseTypeAnswers.add(null);

    appController.yesNoAnswers.clear();
    appController.yesNoAnswers.add(null);

    setUpVideo();
    AppService().findCurrentUserModels();

    // refreshMyStudent();
  }

  Future<void> refreshMyStudent() async {
    await Future.delayed(const Duration(seconds: 5), () {
      AppService().findMyStudent(docIdVideo: widget.docVideo);
      refreshMyStudent();
    });
  }

  @override
  void dispose() {
    if (youtubePlayerController != null) {
      youtubePlayerController!.pauseVideo();
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(data: widget.videoModel.name),
      ),
      body: Obx(() {
        return appController.currentUserModels.isEmpty
            ? const SizedBox()
            : ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 800,
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              displayVideo(),
                              displayNameTeacher(),
                              questionForm(),
                              weightForm(),
                              radioChooseType(),
                              sendButton(),
                              navigatorAnswer(),
                              titleListStudent(),
                              // listViewStudent(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
      }),
    );
  }

  Widget navigatorAnswer() {
    return appController.displayAfterSend.value
        ? appController.displayStop.value
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WidgetButton(
                    data: 'หยุดตอบคำถาม',
                    color: GFColors.WARNING,
                    pressFunc: () {
                      Map<String, dynamic> mapQuestion =
                          appController.qurestionTescherModels.last.toMap();

                      mapQuestion['allowAnswer'] = false;

                      AppService().processEditQuestion(
                        docIdVideo: widget.docVideo,
                        docIdQuestion: appController.docIdQuestions.last,
                        mapQuestion: mapQuestion,
                      );

                      appController.displayStop.value = false;
                    },
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  WidgetButton(
                    data: 'เฉลยคำตอบ',
                    pressFunc: () {},
                    color: GFColors.DANGER,
                  )
                ],
              )
            : WidgetButton(
                data: 'เริ่มตอบคำถาม',
                pressFunc: () {
                  Map<String, dynamic> mapQuestion =
                      appController.qurestionTescherModels.last.toMap();

                  mapQuestion['allowAnswer'] = true;

                  AppService().processEditQuestion(
                    docIdVideo: widget.docVideo,
                    docIdQuestion: appController.docIdQuestions.last,
                    mapQuestion: mapQuestion,
                  );

                  appController.displayStop.value = true;
                },
                color: GFColors.SUCCESS,
              )
        : const SizedBox();
  }

  Widget listViewStudent() {
    return appController.studentUserModels.isEmpty
        ? const SizedBox()
        : ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: appController.studentUserModels.length,
            itemBuilder: (context, index) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetText(
                  data: appController.studentUserModels[index].displayName,
                  textStyle: AppConstant().h3Style(fontWeight: FontWeight.bold),
                ),

                //start
                Obx(() {
                  print(
                      '##4jan appController.listAnswerStudentModels.length ===>> ${appController.listAnswerStudentModels.length}');
                  return appController.listAnswerStudentModels.isEmpty
                      ? const SizedBox()
                      : Container(
                          width: 800,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(border: Border.all()),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: appController
                                .listAnswerStudentModels[index].length,
                            itemBuilder: (context, index2) => Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WidgetText(
                                    data:
                                        'คำถาม : ${appController.listAnswerStudentModels[index][index2].mapQuestion['question']}'),
                                WidgetText(
                                    data:
                                        'ชนิดของคำตอบ : ${appController.listAnswerStudentModels[index][index2].mapQuestion['typeAnswer']}'),
                                const Divider(
                                  color: Colors.black,
                                ),
                                WidgetText(
                                    data:
                                        'คำตอบ : '),
                              ],
                            ),
                          ));
                }),
                //end
              ],
            ),
          );
  }

  Container titleListStudent() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: WidgetText(
        data: 'รายชื่อนักเรียน',
        textStyle: AppConstant().h2Style(),
      ),
    );
  }

  Widget sendButton() {
    return appController.chooseTypeAnswers.last == null
        ? const SizedBox()
        : appController.displayAfterSend.value
            ? const SizedBox()
            : Container(
                margin: const EdgeInsets.symmetric(vertical: 32),
                child: WidgetButton(
                  data: 'ส่งคำถาม',
                  pressFunc: () {
                    if (formKey.currentState!.validate()) {
                      if (appController.chooseTypeAnswers.last ==
                          AppConstant.typeAnswers[0]) {
                        //YesNoQuestion

                        QuestionTeacherModel questionTeacherModel =
                            QuestionTeacherModel(
                          numberAnswer: '',
                          question: questionController.text,
                          textAnswer: '',
                          typeAnswer: appController.chooseTypeAnswers.last!,
                          yesNoAnswer: false,
                          timestamp: Timestamp.fromDate(DateTime.now()),
                          status: 0,
                          uidStudent: [],
                          weight: int.parse(weightController.text.trim()),
                          active: true,
                          allowAnswer: false,
                        );

                        AppService()
                            .processInsertQuestion(
                                questionTeacherModel: questionTeacherModel,
                                docVideo: widget.docVideo)
                            .then((value) {
                          appController.displayAfterSend.value = true;
                        });
                      } else {
                        //Number

                        QuestionTeacherModel questionTeacherModel =
                            QuestionTeacherModel(
                          numberAnswer: '',
                          question: questionController.text,
                          textAnswer: '',
                          typeAnswer: appController.chooseTypeAnswers.last!,
                          yesNoAnswer: false,
                          timestamp: Timestamp.fromDate(DateTime.now()),
                          status: 0,
                          uidStudent: [],
                          weight: int.parse(weightController.text.trim()),
                          active: true,
                          allowAnswer: false,
                        );

                        AppService()
                            .processInsertQuestion(
                                questionTeacherModel: questionTeacherModel,
                                docVideo: widget.docVideo)
                            .then((value) {
                          appController.displayAfterSend.value = true;
                        });
                      }
                    }
                  },
                ),
              );
  }

  Widget answerPath() {
    return appController.chooseTypeAnswers.last == null
        ? const SizedBox()
        : appController.chooseTypeAnswers.last == AppConstant.typeAnswers[0]
            ? trueFalseDropDown()
            : WidgetForm(
                textEditingController: descripNumberController,
                labelWidget: const WidgetTextFull(data: 'Answer'),
              );
  }

  WidgetForm questionForm() {
    return WidgetForm(
      validateFunc: (p0) {
        if (p0?.isEmpty ?? true) {
          return 'Please Fill Answer';
        } else {
          return null;
        }
      },
      textEditingController: questionController,
      labelWidget: const WidgetTextFull(data: 'Question'),
    );
  }

  Widget weightForm() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: WidgetForm(
        validateFunc: (p0) {
          if (p0?.isEmpty ?? true) {
            return 'Please Fill Weight';
          } else if (AppService().checkNumber(string: p0!)) {
            return 'ค่า Weight ต้องเป็นตัวเลข ที่เป็นจำนวนเต็ม';
          } else {
            return null;
          }
        },
        textEditingController: weightController,
        labelWidget: const WidgetTextFull(data: 'Weight'),
      ),
    );
  }

  Padding displayNameTeacher() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: WidgetText(
        data: appController.currentUserModels.last.displayName,
        textStyle: AppConstant().h2Style(),
      ),
    );
  }

  Widget trueFalseDropDown() {
    var answer = <bool>[true, false];

    return DropdownButton(
      hint: const WidgetText(data: 'โปรดเลือกคำตอบถูก/ผิด'),
      value: appController.yesNoAnswers.last,
      items: answer
          .map(
            (e) => DropdownMenuItem(
              child: WidgetText(
                data: e.toString(),
              ),
              value: e,
            ),
          )
          .toList(),
      onChanged: (value) {
        appController.yesNoAnswers.add(value);
      },
    );
  }

  Row radioChooseType() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: RadioListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: WidgetTextFull(data: AppConstant.typeAnswers[0]),
            value: AppConstant.typeAnswers[0],
            groupValue: appController.chooseTypeAnswers.last,
            onChanged: (value) {
              appController.chooseTypeAnswers.add(value);
            },
          ),
        ),
        SizedBox(
          width: 250,
          child: RadioListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: WidgetTextFull(data: AppConstant.typeAnswers[1]),
            value: AppConstant.typeAnswers[1],
            groupValue: appController.chooseTypeAnswers.last,
            onChanged: (value) {
              appController.chooseTypeAnswers.add(value);
            },
          ),
        ),
      ],
    );
  }

  Widget displayVideo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 480,
          child: YoutubePlayer(
            controller: youtubePlayerController!,
            aspectRatio: 16 / 9,
          ),
        ),
      ],
    );
  }

  void clearData() {
    Get.snackbar('Insert Question Success', 'Thankyou Insert Question');

    appController.chooseTypeAnswers.clear();
    appController.chooseTypeAnswers.add(null);

    appController.yesNoAnswers.clear();
    appController.yesNoAnswers.add(null);

    questionController.clear();
    descripNumberController.clear();
  }
}
