import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appfront/userData.dart';

class LoginBtn extends ConsumerStatefulWidget {
  final GlobalKey<FormState> idPwdFormKey;
  final String id;
  final String pwd;
  const LoginBtn({
    super.key,
    required this.id,
    required this.pwd,
    required this.idPwdFormKey,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginBtnState();
}

final userDataProvider = ChangeNotifierProvider<UserData>((ref) {
  return UserData();
});

class _LoginBtnState extends ConsumerState<LoginBtn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff39c5bb),
          elevation: 5,
        ),
        onPressed: () {
          if (widget.idPwdFormKey.currentState!.validate()) {
            Map<String, dynamic> userData = {
              'username': widget.id,
              'password': widget.pwd,
            };
            logIn(userData);
          }
        },
        child: const Text(
          "로그인",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void logIn(Map<String, dynamic> userData) async {
    String url = 'https://api.parkchargego.link/auth/login';
    Uri uri = Uri.parse(url);
    http.Response response = await http.post(uri, body: userData);
    debugPrint("${userData}");
    debugPrint("${response.statusCode}");
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      UserData userData = UserData.fromJson(json);
      ref.read(userDataProvider.notifier).updateUserData(userData);
      Navigator.pop(context, json);
      Fluttertoast.showToast(
        msg: "로그인이 완료되었습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xff39c5bb),
        textColor: Colors.white,
        fontSize: 16,
      );
    } else {
      Fluttertoast.showToast(
        msg: '아이디 혹은 비밀번호가 맞지 않습니다.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xff39c5bb),
      );
    }
  }
}
