import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appfront/main.dart';
import 'package:appfront/userData.dart';

class CardAddScreen extends ConsumerStatefulWidget {
  @override
  _CardAddScreenState createState() => _CardAddScreenState();
}

class _CardAddScreenState extends ConsumerState<CardAddScreen> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  Future<void> registerCard() async {
    String apiUrl = "https://api.parkchargego.link/api/v1/payment/card";
    try {
      final data = ref.read(userDataProvider);
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Cookie':
              'access-token=${data.accessToken}; refresh-token=${data.refreshToken}',
        },
        body: jsonEncode({
          "number": cardNumberController.text,
          "expiryMonth": monthController.text,
          "expiryYear": yearController.text,
        }),
      );
      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("카드 등록"),
              content: Text("카드 등록에 성공했습니다."),
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
              content: Text("카드 등록에 실패했습니다. : ${response.body}"),
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
      print("카드 등록에 실패했습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("카드 등록"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                decoration: InputDecoration(
                  hintText: "0000 0000 0000 0000",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff39c5bb)),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: monthController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: InputDecoration(
                        hintText: "MM",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff39c5bb)),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: yearController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      decoration: InputDecoration(
                        hintText: "YY",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff39c5bb)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: registerCard,
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xff39c5bb)),
              child: Text('등록 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
