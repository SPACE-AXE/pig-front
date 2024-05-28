import 'package:appfront/Screen/Auth/reset_pwd/widgets/reset_pwd.dart';
import 'package:appfront/Screen/Auth/reset_pwd/widgets/send_email.dart';
import 'package:flutter/material.dart';

class ResetPwdScreen extends StatefulWidget {
  const ResetPwdScreen({super.key});

  @override
  State<ResetPwdScreen> createState() => _ResetPwdScreenState();
}

class _ResetPwdScreenState extends State<ResetPwdScreen> {
  bool isEmailSend = false;

  void setFlag() {
    setState(() {
      isEmailSend = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("비밀번호 재설정"),
        centerTitle: true,
      ),
      body: isEmailSend
          ? const ResetPwdContainer()
          : SendEmailContainer(setFlag: setFlag),
    );
  }
}
