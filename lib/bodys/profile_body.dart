import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentjo/utility/app_dialog.dart';
import 'package:studentjo/widgets/widget_button.dart';
import 'package:studentjo/widgets/widget_image_asset.dart';
import 'package:studentjo/widgets/widget_text.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetText(data: 'This is Profile'),
        WidgetButton(
          data: 'SignOut',
          pressFunc: () {
            AppDialog().normalDialog(
                title: 'Confirm SignOut',
                iconWidget: const WidgetImageAsset(
                  path: 'images/name.png',
                  size: 200,
                ),
                firstActionWidget: WidgetButton(
                  data: 'Confirm SignOut',
                  pressFunc: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Get.offAllNamed('/authen');
                    });
                  },
                ));
          },
        )
      ],
    );
  }
}
