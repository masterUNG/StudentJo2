import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentjo/models/video_model.dart';
import 'package:studentjo/utility/app_controller.dart';
import 'package:studentjo/utility/app_service.dart';
import 'package:studentjo/widgets/widget_button.dart';
import 'package:studentjo/widgets/widget_form.dart';
import 'package:studentjo/widgets/widget_icon_button.dart';
import 'package:studentjo/widgets/widget_image_asset.dart';
import 'package:studentjo/widgets/widget_image_network.dart';
import 'package:studentjo/widgets/widget_text.dart';

class AddNewVideo extends StatefulWidget {
  const AddNewVideo({super.key});

  @override
  State<AddNewVideo> createState() => _AddNewVideoState();
}

class _AddNewVideoState extends State<AddNewVideo> {
  final keyForm = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController urlVideoController = TextEditingController();

  AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    if (appController.urlThumnals.isNotEmpty) {
      appController.urlThumnals.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WidgetText(data: 'เพิ่มวีดีโอ'),
      ),
      body: Form(
        key: keyForm,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 64),
              width: 520,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return appController.urlThumnals.isEmpty
                        ? const WidgetImageAsset(
                            path: 'images/video.png',
                            size: 250,
                          )
                        : WidgetImageNetwork(
                            urlImage: appController.urlThumnals.last,
                            width: 250,
                          );
                  }),
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    width: 250,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WidgetForm(
                          textEditingController: nameController,
                          labelWidget: const WidgetText(data: 'ชื่อวีดีโอ'),
                          validateFunc: (p0) {
                            if (p0?.isEmpty ?? true) {
                              return 'โปรดกรอก ชื่อวีดีโอ';
                            } else {
                              return null;
                            }
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          child: WidgetForm(
                            textEditingController: detailController,
                            labelWidget: const WidgetText(data: 'รายละเอียด'),
                            validateFunc: (p0) {
                              if (p0?.isEmpty ?? true) {
                                return 'โปรดกรอก รายละเอียดวีดีโอ';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        WidgetForm(
                          textEditingController: urlVideoController,
                          labelWidget: const WidgetText(data: 'ลิ้งค์ วีดีโอ'),
                          validateFunc: (p0) {
                            if (p0?.isEmpty ?? true) {
                              return 'โปรดกรอก ลิ้งค์วีดีโอ';
                            } else {
                              return null;
                            }
                          },
                          subfixWidget: WidgetIconButton(
                            iconData: Icons.check_box,
                            pressFunc: () {
                              if (urlVideoController.text.isNotEmpty) {
                                appController.urlThumnals.add(AppService()
                                    .findThumnalVideo(
                                        urlVideo: urlVideoController.text));
                              } else {
                                Get.snackbar('ลิ้งค์วีดีโอ ?',
                                    'โปรดกรอก ลิ้งค์วีดีโอ ก่อนทดสอบ',
                                    backgroundColor: Colors.red.shade700,
                                    colorText: Colors.white);
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          width: 250,
                          child: WidgetButton(
                            data: 'บันทึกวีดีโอ',
                            pressFunc: () async {
                              if (keyForm.currentState!.validate()) {
                                if (appController.urlThumnals.isNotEmpty) {
                                  //Process Save

                                  var user = FirebaseAuth.instance.currentUser;

                                  VideoModel videoModel = VideoModel(
                                      name: nameController.text,
                                      detail: detailController.text,
                                      urlVideo: urlVideoController.text,
                                      urlThumnall:
                                          appController.urlThumnals.last,
                                      show: false,
                                      timestamp:
                                          Timestamp.fromDate(DateTime.now()),
                                      uidTeacher: user!.uid);

                                  await FirebaseFirestore.instance
                                      .collection('video')
                                      .doc()
                                      .set(videoModel.toMap())
                                      .then((value) {
                                    Get.back();

                                    Get.snackbar('Save Success', 'ThangYou');
                                  });
                                } else {
                                  Get.snackbar('เช็ค Thumnall',
                                      'กรุณาเช็คภาพวีดีโอ โดยคลิกที่ เครื่องหมายถูก');
                                }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
