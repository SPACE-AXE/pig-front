import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:appfront/main.dart';
import 'package:appfront/userData.dart';

class CardAddScreen extends StatefulWidget {
  @override
  _CardAddScreenState createState() => _CardAddScreenState();
}

class _CardAddScreenState extends State<CardAddScreen> {
  TextEditingController cardNumberController = TextEditingController();
  DateTime? expiryDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: expiryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != expiryDate) {
      setState(() {
        expiryDate = picked;
      });
    }
  }

  Future<void> registerCard() async {
    debugPrint(
        "${cardNumberController.text}\n${expiryDate?.year.toString().substring(2)}\n${expiryDate?.month.toString().padLeft(2, '0')}");
    String apiUrl = "https://api.parkchargego.link/payment/card";

    var requestBody = jsonEncode({
      "number": cardNumberController.text,
      "expiryYear": expiryDate?.year.toString().substring(2),
      "expiryMonth": expiryDate?.month.toString().padLeft(2, '0')
    });

    // JSON 요청 본문 출력
    debugPrint("Request Body: $requestBody");
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Cookie':
              'access-token=${userData.accessToken}; refresh-token=${userData.refreshToken}',
        },
        body: jsonEncode({
          "number": cardNumberController.text,
          "expiryYear": expiryDate?.year.toString().substring(2),
          "expiryMonth": expiryDate?.month.toString().padLeft(2, '0')
        }),
      );
      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");
      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Card registered successfully."),
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to register card: ${response.body}"),
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
      print("카드 등록 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Card Add Screen")),
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
                    LengthLimitingTextInputFormatter(16)
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "카드 번호는 필수 요소 입니다.";
                    } else if (value.length != 16) {
                      return "카드 번호는 16자리여야 합니다.";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "카드 번호",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff39c5bb),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    expiryDate == null
                        ? "유효 기간"
                        : "유효기간: ${expiryDate!.year.toString().padLeft(4, '0')}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}",
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff39c5bb),
                ),
                child: Text('등록 완료'),
              ),
            ],
          ),
        ));
  }
}
