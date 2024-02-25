// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import 'package:studentjo/utility/app_service.dart';
import 'package:studentjo/widgets/widget_image_asset.dart';

class CheckOtpWeb extends StatelessWidget {
  const CheckOtpWeb({
    Key? key,
    required this.verifyID,
    required this.phoneNumber,
  }) : super(key: key);

  final String verifyID;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          const SizedBox(
            height: 32,
          ),
          displayImage(),
          const SizedBox(
            height: 16,
          ),
          otpField(),
        ],
      )),
    );
  }

  Row otpField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OTPTextField(
          length: 6,
          otpFieldStyle: OtpFieldStyle(backgroundColor: Colors.grey.shade300),
          fieldStyle: FieldStyle.box,
          width: 250,
          onCompleted: (value) {
            String otp = value;
            print('otp ที่ได้มา ---> $otp');

            AppService().checkOtp(otp: otp, verifyId: verifyID, phoneNumber: phoneNumber, web: true);
          },
        ),
      ],
    );
  }

  WidgetImageAsset displayImage() {
    return WidgetImageAsset(
      path: 'images/otp.png',
      size: 250,
    );
  }
}
