// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetForm extends StatelessWidget {
  const WidgetForm({
    super.key,
    this.hintText,
    this.textInputType,
    this.textEditingController,
    this.labelWidget,
    this.subfixWidget,
    this.validateFunc,
  });

  final String? hintText;
  final TextInputType? textInputType;
  final TextEditingController? textEditingController;
  final Widget? labelWidget;
  final Widget? subfixWidget;
  final String? Function(String?)? validateFunc;

  @override
  Widget build(BuildContext context) {
    return TextFormField(validator: validateFunc,
      controller: textEditingController,
      keyboardType: textInputType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        border: InputBorder.none,
        hintText: hintText,
        label: labelWidget,
        suffixIcon: subfixWidget,
      ),
    );
  }
}
