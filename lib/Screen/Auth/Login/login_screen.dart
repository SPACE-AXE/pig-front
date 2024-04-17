// ignore_for_file: avoid_unnecessary_containers

import 'package:appfront/Screen/Auth/login/widgets/id_pwd.dart';
import 'package:appfront/Screen/Auth/login/widgets/login_btn.dart';
import 'package:appfront/Screen/Auth/login/widgets/three_btn.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            IdAndPwd(
              updateId: updateId,
              updatePwd: updatePwd,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            LoginBtn(
              id: id,
              pwd: pwd,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            const ThreeBtn(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
