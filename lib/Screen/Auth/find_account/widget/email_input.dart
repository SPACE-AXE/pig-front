import 'package:flutter/material.dart';

class EmailInput extends StatefulWidget {
  final bool emailCheck;
  final TextEditingController _email;
  final Function(String) setEmailFlag;
  const EmailInput({
    super.key,
    required TextEditingController email,
    required this.emailCheck,
    required this.setEmailFlag,
  }) : _email = email;

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        style: const TextStyle(fontFamily: 'Maple'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "필수 입력값입니다.";
          } else if (!widget.emailCheck) {
            return "이메일 형식에 맞지 않습니다.";
          }

          return null;
        },
        controller: widget._email,
        decoration: const InputDecoration(
          hintText: "이메일",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff39c5bb),
            ),
          ),
        ),
        onChanged: (value) {
          widget.setEmailFlag(value);
        },
      ),
    );
  }
}
