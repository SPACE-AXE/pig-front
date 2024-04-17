import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  const CustomFormField(
      {super.key, required this.controller, required this.text});

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "필수 입력값입니다.";
        }
        return null;
      },
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.text,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff39c5bb),
          ),
        ),
      ),
    );
  }
}
