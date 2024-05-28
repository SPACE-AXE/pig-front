import 'dart:convert';
import 'dart:math';

import 'package:appfront/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

class _LoginBtnState extends ConsumerState<LoginBtn> {
  bool easterEgg = false;
  int counter = 10;
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
          if (easterEgg) {
            setState(() {
              counter--;
              Fluttertoast.showToast(
                msg: '$counter',
                gravity: ToastGravity.BOTTOM,
                backgroundColor: const Color(0xff39c5bb),
                timeInSecForIosWeb: 3,
              );
            });
          }
          if (counter == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const zz(),
              ),
            );
          }
          if (widget.idPwdFormKey.currentState!.validate()) {
            Map<String, dynamic> userData = {
              'username': widget.id,
              'password': widget.pwd,
            };
            logIn(userData);
          }
        },
        onLongPress: () {
          setState(() {
            easterEgg = true;
          });
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
    String url = 'https://api.parkchargego.link/api/v1/auth/login';
    Uri uri = Uri.parse(url);
    http.Response response = await http.post(uri, body: userData);

    String accessToken = '';
    String refreshToken = '';

    List<String> cookies = response.headers['set-cookie']!.split(',');

    for (String cookie in cookies) {
      if (cookie.contains('access-token')) {
        accessToken = cookie.split('=')[1].split(';')[0];
      } else if (cookie.contains('refresh-token')) {
        refreshToken = cookie.split('=')[1].split(';')[0];
      }
    }
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      Map<String, dynamic> json = {
        ...res,
        "accessToken": accessToken,
        "refreshToken": refreshToken,
      };
      ref.read(userDataProvider).updateUserData(UserData.fromJson(json));
      Navigator.pop(context);
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

class zz extends StatefulWidget {
  const zz({super.key});

  @override
  State<zz> createState() => _zzState();
}

class _zzState extends State<zz> {
  int imgnum = 1 + Random().nextInt(63);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Image.asset(
                    'lib/Screen/Auth/Login/widgets/img/$imgnum.jpg'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    imgnum = 1 + Random().nextInt(63);
                  });
                },
                child: const Text(
                  "다음 랜덤 이미지",
                  style: TextStyle(fontSize: 15),
                ),
              )
            ],
          ),
        ));
  }
}
