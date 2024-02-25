import 'package:flutter/material.dart';

class AppConstant {
  static var iconsDatas = <IconData>[
    Icons.check_box_outline_blank,
    Icons.check_box_outlined,
    Icons.disabled_by_default_outlined,
  ];

  static var typeAnswers = <String>[
    'True/False',
    'Number',
  ];

  TextStyle h1Style() => const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
      );
  TextStyle h2Style() => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      );
  TextStyle h3Style({Color? color, FontWeight? fontWeight}) => TextStyle(
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color,
      );
}
