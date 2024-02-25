// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import 'package:studentjo/widgets/widget_text.dart';

class WidgetButton extends StatelessWidget {
  const WidgetButton({
    Key? key,
    required this.data,
    required this.pressFunc,
    this.color,
  }) : super(key: key);

  final String data;
  final Function() pressFunc;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GFButton(
      onPressed: pressFunc,
      text: data,
      color: color ?? GFColors.PRIMARY,
    );
  }
}
