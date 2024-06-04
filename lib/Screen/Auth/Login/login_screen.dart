// ignore_for_file: avoid_unnecessary_containers

import 'package:appfront/Screen/Auth/login/widgets/id_pwd.dart';
import 'package:appfront/Screen/Auth/login/widgets/login_btn.dart';
import 'package:appfront/Screen/Auth/login/widgets/three_btn.dart';
import 'package:appfront/main.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idPwdFormKey = GlobalKey<FormState>();

  String id = '';
  String pwd = '';

  void updateId(String value) {
    setState(() {
      id = value;
    });
  }

  void updatePwd(String value) {
    setState(() {
      pwd = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainApp()),
              (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Transform.scale(
                  scale: 0.8,
                  alignment: Alignment.center,
                  child: Image.asset('lib/assets/images/title3.png',
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              IdAndPwd(
                idPwdFormKey: idPwdFormKey,
                updateId: updateId,
                updatePwd: updatePwd,
              ),
              LoginBtn(
                idPwdFormKey: idPwdFormKey,
                id: id,
                pwd: pwd,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              const ThreeBtn(),
            ],
          ),
        ),
      ),
    );
  }
}
