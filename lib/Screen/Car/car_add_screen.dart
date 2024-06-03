import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appfront/main.dart';
import 'package:appfront/userData.dart';

class CarAddScreen extends ConsumerStatefulWidget {
  const CarAddScreen({super.key});

  @override
  _CarAddScreenState createState() => _CarAddScreenState();
}

class _CarAddScreenState extends ConsumerState<CarAddScreen> {
  TextEditingController carNumberController = TextEditingController();

  Future<void> registerCar() async {
    String apiUrl = "https://api.parkchargego.link/api/v1/car";
    String carNum = carNumberController.text;

    if (carNum.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("차량 번호는 필수 요소입니다."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    debugPrint("Request Body: $carNum");
    try {
      final data = ref.read(userDataProvider);
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Cookie':
              'access-token=${data.accessToken}; refresh-token=${data.refreshToken}'
        },
        body: jsonEncode({"carNum": carNum}),
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("차량 등록 성공."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 409) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("이미 등록된 차량 번호입니다."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("차량 등록 실패"),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("차량 등록 실패");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("차량 등록 실패"),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("차량 등록"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: carNumberController,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[ㄱ-ㅎㅏ-ㅣ0-9a-zA-Z가-힣]+')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "차량 번호는 필수 요소입니다.";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "차량 번호 입력 (예: 25머2452)",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff39c5bb),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerCar,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xff39c5bb),
              ),
              child: const Text('등록 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
