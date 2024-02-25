// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetTextFull extends StatelessWidget {
  const WidgetTextFull({
    super.key,
    required this.data,
    this.textStyle,
  });

  final String data;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: textStyle,
     
    );
  }
}
