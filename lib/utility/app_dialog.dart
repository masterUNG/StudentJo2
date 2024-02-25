import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentjo/widgets/widget_button.dart';
import 'package:studentjo/widgets/widget_text.dart';
import 'package:studentjo/widgets/widget_text_full.dart';

class AppDialog {
  void normalDialog({
    required String title,
    Widget? iconWidget,
    Widget? contentWidget,
    Widget? actionWidget,
    Widget? firstActionWidget,
  }) {
    Get.dialog(
      AlertDialog(backgroundColor: Colors.white,
        icon: iconWidget,
        title: WidgetTextFull(data: title),
        content: contentWidget,
        actions: [
          firstActionWidget ?? const SizedBox(),
          actionWidget ??
              WidgetButton(
                data: firstActionWidget == null ? 'OK' : 'Cancel',
                pressFunc: () => Get.back(),
              )
        ],
        scrollable: true,
      ),
      barrierDismissible: false,
    );
  }
}
