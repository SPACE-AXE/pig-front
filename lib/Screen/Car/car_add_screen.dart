import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appfront/main.dart';
import 'package:appfront/userData.dart';

class CarAddScreen extends ConsumerStatefulWidget {
  @override
  _CarAddScreenState createState() => _CarAddScreenState();
}

class _CarAddScreenState extends ConsumerState<CarAddScreen> {
  TextEditingController carNumberController = TextEditingController();

  Future<void> registerCar() async {
    String apiUrl = "https://api.parkchargego.link/car";
    String carNum = carNumberController.text;

    if (carNum.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("차량 번호는 필수 요소입니다."),
            actions: [
              TextButton(
                child: Text("OK"),
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
              title: Text("Success"),
              content: Text("차량 등록 성공."),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
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
              title: Text("Error"),
              content: Text("차량 등록 실패: ${response.body}"),
              actions: [
                TextButton(
                  child: Text("OK"),
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
      print("차량 등록 실패: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("차량 등록 실패: $e"),
            actions: [
              TextButton(
                child: Text("OK"),
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
        title: Text("차량 등록"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: carNumberController,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9가-힣]+')),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerCar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff39c5bb),
              ),
              child: Text('등록 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
