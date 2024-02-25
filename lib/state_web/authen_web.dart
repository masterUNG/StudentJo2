import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentjo/utility/app_constant.dart';
import 'package:studentjo/utility/app_service.dart';
import 'package:studentjo/widgets/widget_button.dart';
import 'package:studentjo/widgets/widget_form.dart';
import 'package:studentjo/widgets/widget_image_asset.dart';
import 'package:studentjo/widgets/widget_text.dart';

class AuthenWeb extends StatefulWidget {
  const AuthenWeb({super.key});

  @override
  State<AuthenWeb> createState() => _AuthenWebState();
}

class _AuthenWebState extends State<AuthenWeb> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(margin: const EdgeInsets.only(top: 64),
              width: 550,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  displayImage(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetText(
                        data: 'ลงชื่อเข้าใช้งาน สำหรับคุณครู',
                        textStyle: AppConstant().h2Style(),
                      ),
                      phoneForm(),
                      sentButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Row sentButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          width: 250,
          child: WidgetButton(
            data: 'Sent Phone',
            pressFunc: () {
              if (textEditingController.text.isEmpty) {
                // Have Space
                Get.snackbar('Have Space', 'Please Fill Phone Number');
              } else {
                // No Space
                AppService()
                    .processSentSms(phoneNumber: textEditingController.text, web: true);
              }
            },
          ),
        ),
      ],
    );
  }

  Row phoneForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          child: WidgetForm(
            textEditingController: textEditingController,
            hintText: 'Phone Number',
            textInputType: TextInputType.phone,
          ),
        ),
      ],
    );
  }

  Container displayImage() {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      child: const WidgetImageAsset(
        path: 'images/phone.png',
        size: 230,
      ),
    );
  }
}
