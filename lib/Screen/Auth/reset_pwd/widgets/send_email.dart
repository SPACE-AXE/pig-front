import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendEmailContainer extends StatefulWidget {
  final Function() setFlag;
  const SendEmailContainer({super.key, required this.setFlag});

  @override
  State<SendEmailContainer> createState() => _SendEmailContainerState();
}

class _SendEmailContainerState extends State<SendEmailContainer> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final RegExp _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool emailCheck = true;
  String email = '';
  String name = '';
  String username = '';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "필수 입력값입니다.";
                  } else if (!emailCheck) {
                    return "이메일 형식에 맞지 않습니다.";
                  }

                  return null;
                },
                controller: _email,
                decoration: const InputDecoration(
                  hintText: "초기화 메일을 받을 이메일",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff39c5bb),
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (!_emailRegExp.hasMatch(value)) {
                    setState(() {
                      emailCheck = false;
                    });
                  } else {
                    setState(() {
                      emailCheck = true;
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "필수 입력값입니다.";
                  }
                  return null;
                },
                controller: _username,
                decoration: const InputDecoration(
                  hintText: "아이디",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff39c5bb),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 10),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    email = _email.text;
                    username = _username.text;
                  });
                  Map<String, dynamic> userData = {
                    'email': email,
                    'username': username,
                  };
                  findUserName(userData);
                }
              },
              child: const Text(
                "비밀번호 재설정",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void findUserName(Map<String, dynamic> userData) async {
    String url =
        'https://api.parkchargego.link/api/v1/auth/send-password-reset-email';
    Uri uri = Uri.parse(url);
    http.Response response = await http.post(uri, body: userData);
    debugPrint("${response.statusCode}");
    debugPrint(response.body);
    widget.setFlag();
  }
}
