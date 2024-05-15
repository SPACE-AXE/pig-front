import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:appfront/Screen/Card/card_add_screen.dart';
import 'package:appfront/userData.dart';
import 'package:appfront/main.dart';

class CardScreen extends StatefulWidget {
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  bool isLoading = true;
  String? cardNumber;

  @override
  void initState() {
    super.initState();
    fetchCard();
  }

  Future<void> fetchCard() async {
    String apiUrl = "https://api.parkchargego.link/payment/card";
    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Cookie': 'access-token=${userData.accessToken}; refresh-token=${userData.refreshToken}'
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          cardNumber = data['number']; // 예시로 카드 번호를 받는다고 가정
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('카드 조회 실패: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteCard() async {
    String apiUrl = "https://api.parkchargego.link/payment/card";
    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Cookie': 'access-token=${userData.accessToken}; refresh-token=${userData.refreshToken}'
        },
      );
      if (response.statusCode == 200) {
        print("카드 삭제 성공");
        setState(() {
          cardNumber = null;
        });
      } else {
        print("카드 삭제 실패: ${response.body}");
      }
    } catch (e) {
      print('카드 삭제 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Card Management")),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : cardNumber == null
                ? ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CardAddScreen()),
                      );
                      fetchCard();
                    },
                    child: Text('카드 추가'),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('카드 번호: $cardNumber'),
                      ElevatedButton(
                        onPressed: deleteCard,
                        child: Text('카드 삭제'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF39c5bb),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
