// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:studentjo/utility/app_constant.dart';

class WidgetTextRich extends StatelessWidget {
  const WidgetTextRich({
    super.key,
    required this.head,
    required this.tail,
  });

  final String head;
  final String tail;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: head,
        style: AppConstant()
            .h3Style(color: Colors.indigo, fontWeight: FontWeight.w700),
        children: [
          TextSpan(
              text: ' : ',
              style: AppConstant()
                  .h3Style(color: Colors.indigo, fontWeight: FontWeight.w700)),
          TextSpan(text: tail, style: AppConstant().h3Style()),
        ],
      ),
    );
  }
}
