import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentjo/states/video_player_mobile.dart';
import 'package:studentjo/utility/app_controller.dart';
import 'package:studentjo/utility/app_dialog.dart';
import 'package:studentjo/utility/app_service.dart';
import 'package:studentjo/widgets/widget_button.dart';
import 'package:studentjo/widgets/widget_image_network.dart';
import 'package:studentjo/widgets/widget_text.dart';
import 'package:studentjo/widgets/widget_text_full.dart';

class VideoBody extends StatefulWidget {
  const VideoBody({super.key});

  @override
  State<VideoBody> createState() => _VideoBodyState();
}

class _VideoBodyState extends State<VideoBody> {
  AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    AppService().processReadAllVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return appController.videoModels.isEmpty
          ? const SizedBox()
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appController.videoModels.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 4 / 5,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  AppDialog().normalDialog(
                      title: appController.videoModels[index].name,
                      iconWidget: WidgetImageNetwork(
                          urlImage:
                              appController.videoModels[index].urlThumnall),
                      contentWidget: WidgetTextFull(
                          data: appController.videoModels[index].detail),
                      firstActionWidget: WidgetButton(
                        data: 'Watch Video',
                        pressFunc: () {
                          Get.back();
                          Get.to(VideoPlayerMobile(
                              videoModel: appController.videoModels[index], docIdVideo: appController.docIdVideos[index],));
                        },
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetImageNetwork(
                          urlImage:
                              appController.videoModels[index].urlThumnall),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: WidgetText(
                            data: appController.videoModels[index].name),
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
