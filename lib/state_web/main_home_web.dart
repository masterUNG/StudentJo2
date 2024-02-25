import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentjo/state_web/add_new_video.dart';
import 'package:studentjo/state_web/video_player_web.dart';
import 'package:studentjo/utility/app_constant.dart';
import 'package:studentjo/utility/app_controller.dart';
import 'package:studentjo/utility/app_dialog.dart';
import 'package:studentjo/utility/app_service.dart';
import 'package:studentjo/widgets/widget_button.dart';
import 'package:studentjo/widgets/widget_form.dart';
import 'package:studentjo/widgets/widget_icon_button.dart';
import 'package:studentjo/widgets/widget_image_network.dart';
import 'package:studentjo/widgets/widget_text.dart';

class MainHomeWeb extends StatefulWidget {
  const MainHomeWeb({super.key});

  @override
  State<MainHomeWeb> createState() => _MainHomeWebState();
}

class _MainHomeWebState extends State<MainHomeWeb> {
  AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();

    AppService().readVideoTeacher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          return appController.videoModels.isEmpty
              ? const SizedBox()
              : ListView.builder(
                  itemCount: appController.videoModels.length,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 800,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            displayImage(index),
                            displayText(index),
                            iconShow(index),
                            iconPlay(index),
                            iconEdit(index),
                            iconDelete(index),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        }),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 96, right: 32),
        child: WidgetButton(
          data: 'เพิ่ม วีดีโอ',
          pressFunc: () {
            Get.to(const AddNewVideo())?.then((value) {
              AppService().readVideoTeacher();
            });
          },
        ),
      ),
    );
  }

  WidgetIconButton iconDelete(int index) {
    return WidgetIconButton(
                              iconData: Icons.delete_forever,
                              pressFunc: () {
                                AppDialog().normalDialog(
                                    title: 'ลบวีดีโอ ',
                                    iconWidget: WidgetImageNetwork(
                                      urlImage: appController
                                          .videoModels[index].urlThumnall,
                                      width: 180,
                                      height: 150,
                                    ),
                                    contentWidget: const WidgetText(
                                        data: 'โปรดยืนยัน การลบวีดีโอ'),
                                    firstActionWidget: WidgetButton(
                                        data: 'ยืนยัน',
                                        pressFunc: () async {
                                          var user = FirebaseAuth
                                              .instance.currentUser;

                                          await FirebaseFirestore.instance
                                              .collection('video')
                                              .doc(appController
                                                  .docIdVideos[index])
                                              .delete()
                                              .then((value) {
                                            Get.back();
                                            AppService().readVideoTeacher();
                                          });
                                        }));
                              });
  }

  WidgetIconButton iconEdit(int index) {
    return WidgetIconButton(
        iconData: Icons.edit,
        pressFunc: () {
          TextEditingController nameController = TextEditingController();

          nameController.text = appController.videoModels[index].name;

          TextEditingController detailController = TextEditingController();

          detailController.text = appController.videoModels[index].detail;

          AppDialog().normalDialog(
            title: 'แก้ไข',
            iconWidget: WidgetImageNetwork(
              urlImage: appController.videoModels[index].urlThumnall,
              width: 180,
              height: 150,
            ),
            contentWidget: SizedBox(
              width: 250,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WidgetForm(
                    labelWidget: const WidgetText(data: 'ชื่อวีดีโอ ;'),
                    textEditingController: nameController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  WidgetForm(
                    labelWidget: const WidgetText(data: 'รายละเอียดวีดีโอ :'),
                    textEditingController: detailController,
                  ),
                ],
              ),
            ),
            firstActionWidget: WidgetButton(
              data: 'แก้ไข',
              pressFunc: () async {
                Map<String, dynamic> map =
                    appController.videoModels[index].toMap();

                map['name'] = nameController.text;
                map['detail'] = detailController.text;

                var user = FirebaseAuth.instance.currentUser;

                await FirebaseFirestore.instance
                    .collection('video')
                    .doc(appController.docIdVideos[index])
                    .update(map)
                    .then((value) {
                  Get.back();
                  AppService().readVideoTeacher();
                });
              },
            ),
          );
        });
  }

  WidgetIconButton iconPlay(int index) {
    return WidgetIconButton(
        iconData: Icons.videocam,
        pressFunc: () {
          Get.to(VideoPlayerWeb(
            videoModel: appController.videoModels[index], docVideo: appController.docIdVideos[index],
          ));
        });
  }

  WidgetIconButton iconShow(int index) {
    return WidgetIconButton(
      iconData: Icons.smart_display,
      color: appController.videoModels[index].show ? Colors.green : Colors.red,
      pressFunc: () async {
        Map<String, dynamic> map = appController.videoModels[index].toMap();

        map['show'] = !map['show'];

        var user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection('video')
            .doc(appController.docIdVideos[index])
            .update(map)
            .then((value) {
          AppService().readVideoTeacher();
        });
      },
    );
  }

  Padding displayText(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 400,
            child: WidgetText(
              data: appController.videoModels[index].name,
              textStyle: AppConstant().h2Style(),
            ),
          ),
          SizedBox(
            width: 400,
            child: WidgetText(data: appController.videoModels[index].detail),
          ),
        ],
      ),
    );
  }

  WidgetImageNetwork displayImage(int index) {
    return WidgetImageNetwork(
      urlImage: appController.videoModels[index].urlThumnall,
      width: 180,
      height: 150,
    );
  }
}
