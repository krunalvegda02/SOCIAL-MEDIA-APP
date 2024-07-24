// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class text_form_field extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPassword;
  final String hintText;
  final TextInputType textInputType;

  const text_form_field(
      {super.key,
      required this.textEditingController,
      this.isPassword = false,
      required this.hintText,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    final inputborder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));

    return TextField(
      keyboardType: textInputType,
      controller: textEditingController,
      obscureText: isPassword,
      decoration: InputDecoration(
        border: inputborder,
        focusedBorder: inputborder,
        enabledBorder: inputborder,
        filled: true,
        contentPadding: const EdgeInsets.all(9),
        hintText: hintText,
      ),
    );
  }
}
