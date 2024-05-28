import 'package:flutter/material.dart';

class NameInput extends StatefulWidget {
  final TextEditingController _name;
  const NameInput({
    super.key,
    required TextEditingController name,
  }) : _name = name;

  @override
  State<NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "필수 입력값입니다.";
          }
          return null;
        },
        controller: widget._name,
        decoration: const InputDecoration(
          hintText: "이름",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff39c5bb),
            ),
          ),
        ),
      ),
    );
  }
}
