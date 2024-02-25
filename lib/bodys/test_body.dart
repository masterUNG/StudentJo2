import 'package:flutter/material.dart';
import 'package:studentjo/widgets/widget_text.dart';

class TestBody extends StatelessWidget {
  const TestBody({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetText(data: 'This is Test');
  }
}