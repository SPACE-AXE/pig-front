import 'dart:convert';

import 'package:appfront/Screen/prePayment/payScreen/widget/info_row.dart';
import 'package:appfront/Screen/prePayment/payScreen/widget/park_conatiner.dart';
import 'package:appfront/Screen/prePayment/payScreen/widget/pay_container.dart';
import 'package:appfront/Screen/prePayment/payScreen/widget/term_container.dart';
import 'package:appfront/Screen/prePayment/select_screen/select_screen.dart';
import 'package:appfront/main.dart';
import 'package:appfront/userData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PayScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const PayScreen({super.key, required this.data});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  int timeDiff = 0;
  String date = '';

  @override
  void initState() {
    super.initState();

    DateTime original = DateTime.parse(widget.data['entryTime']);
    DateTime now = DateTime.now();
    Duration difference = now.difference(original);
    debugPrint("data: ${widget.data}");
    setState(() {
      date = DateFormat('yyyy.MM.dd. HH:MM').format(original);
      timeDiff = difference.inMinutes;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(date);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date),
                // const SizedBox(height: 15),
                // ParkContainer(data: widget.data),
                const SizedBox(height: 15),
                PayContainer(data: widget.data),
                const SizedBox(height: 15),
                TermContainer(data: widget.data),
                const SizedBox(height: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Text(
                    "위 결제 내용을 확인하였으며, \n회원 본인은 개인정보 이용,제공 및 결제에 동의합니다.",
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Consumer(
                    builder: (context, ref, child) {
                      return ElevatedButton(
                          onPressed: () async {
                            final data = ref.read(userDataProvider);
                            timeDiff < 1
                                ? null
                                : payment(data.accessToken!, data.refreshToken!,
                                    widget.data['paymentId']);
                          },
                          child: const Text("결제하기"));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void payment(
      String accessToken, String refreshToken, String paymentId) async {
    String url = 'https://api.parkchargego.link/api/v1/payment';
    Uri uri = Uri.parse(url);

    http.Response response = await http.post(uri, headers: {
      'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken',
    }, body: {
      "paymentId": paymentId
    });
    final res = json.decode(response.body);
    debugPrint("123$res");
    if (res['status'] == 'PAID') {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("결제 성공"),
            content: const Text("정상적으로 결제가 완료되었습니다."),
            actions: [
              Consumer(
                builder: (context, ref, child) {
                  final data = ref.read(userDataProvider);
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectScreen(
                                  userData: data,
                                )),
                        (route) => false,
                      );
                    },
                    child: const Text("이전"),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainApp()),
                    (route) => false,
                  );
                },
                child: const Text("메인"),
              ),
            ],
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("결제 실패"),
            content: const Text("결제에 실패하였습니다.\n정상적인 카드가 등록되어있는지 확인하여 주십시오."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainApp()),
                    (route) => false,
                  );
                },
                child: const Text("메인으로"),
              ),
            ],
          );
        },
      );
    }
  }
}
