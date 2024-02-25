import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentjo/utility/app_service.dart';
import 'package:studentjo/widgets/widget_button.dart';
import 'package:studentjo/widgets/widget_form.dart';
import 'package:studentjo/widgets/widget_image_asset.dart';

class Authen extends StatefulWidget {
  const Authen({super.key});

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          children: [
            displayImage(),
            phoneForm(),
            sentButton(),
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
                    .processSentSms(phoneNumber: textEditingController.text);
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
        size: 250,
      ),
    );
  }
}
