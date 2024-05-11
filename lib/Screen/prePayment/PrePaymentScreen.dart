import 'dart:convert';

import 'package:appfront/Screen/Auth/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PrePaymentScreen extends StatefulWidget {
  const PrePaymentScreen({super.key});

  @override
  State<PrePaymentScreen> createState() => _PrePaymentScreenState();
}

class _PrePaymentScreenState extends State<PrePaymentScreen> {
  late List<Map<String, dynamic>> data;
  @override
  void initState() {
    super.initState();

    String url = 'https://api.parkchargego.link/parking-transaction';

    Uri uri = Uri.parse(url);

    http.get(uri).then((value) {
      var response = json.decode(value.body);
      if (response['statusCode'] == 403) {
        Fluttertoast.showToast(
          msg: '로그인이 필요한 기능입니다.',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xff39c5bb),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("사전결제 스크린")),
      body: const Center(child: Text("사전결제 스크린입니다")),
    );
  }
}
