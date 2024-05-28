import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ResetPwdContainer extends StatefulWidget {
  const ResetPwdContainer({super.key});

  @override
  State<ResetPwdContainer> createState() => _ResetPwdContainerState();
}

class _ResetPwdContainerState extends State<ResetPwdContainer> {
  final _pwdKey = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _token = TextEditingController();
  bool pwdCheckFlag = false;
  String password = '';
  String token = '';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _pwdKey,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(),
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "필수 입력값입니다.";
                  }
                  return null;
                },
                controller: _token,
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: "토큰",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff39c5bb),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(),
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "필수 입력값입니다.";
                  }
                  return null;
                },
                controller: _password,
                maxLength: 13,
                obscureText: true,
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: "비밀번호",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff39c5bb),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(),
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "필수 입력값입니다.";
                  }
                  if (value != _password.text) {
                    return "비밀번호가 일치하지 않습니다.";
                  }
                  return null;
                },
                maxLength: 13,
                obscureText: true,
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: "비밀번호 확인",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff39c5bb),
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (_pwdKey.currentState!.validate()) {
                    pwdCheckFlag = true;
                  } else {
                    pwdCheckFlag = false;
                  }
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 10),
              ),
              onPressed: () {
                if (_pwdKey.currentState!.validate()) {
                  if (pwdCheckFlag) {
                    _pwdKey.currentState!.validate();
                    debugPrint("$pwdCheckFlag");
                    setState(() {
                      password = _password.text;
                      token = _token.text;
                    });
                    Map<String, dynamic> userData = {
                      'token': token,
                      'password': password,
                    };
                    resetPwd(userData);
                  } else {
                    Fluttertoast.showToast(
                      msg: "아이디 중복확인이 필요합니다.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color(0xff39c5bb),
                      textColor: Colors.white,
                      fontSize: 16,
                    );
                  }
                }
              },
              child: const Text(
                "비밀번호 초기화",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetPwd(Map<String, dynamic> userData) async {
    String url = 'https://api.parkchargego.link/api/v1/auth/reset-password';
    Uri uri = Uri.parse(url);
    http.Response response = await http.patch(uri, body: userData);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      debugPrint("${response.statusCode}");
      Navigator.pop(context);
    } else {
      debugPrint(response.body);
    }
  }
}
