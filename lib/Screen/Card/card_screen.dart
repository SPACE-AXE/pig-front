import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appfront/Screen/Card/card_add_screen.dart';
import 'package:appfront/userData.dart';
import 'package:appfront/main.dart';

class CardScreen extends ConsumerStatefulWidget {
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends ConsumerState<CardScreen> {
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
      final data = ref.read(userDataProvider);
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Cookie':
              'access-token=${data.accessToken}; refresh-token=${data.refreshToken}'
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          cardNumber = data['number'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Card fetch failed: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteCard() async {
    String apiUrl = "https://api.parkchargego.link/payment/card";
    try {
      final data = ref.read(userDataProvider);
      var response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Cookie':
              'access-token=${data.accessToken}; refresh-token=${data.refreshToken}'
        },
      );
      if (response.statusCode == 200) {
        print("카드를 삭제했습니다.");
        setState(() {
          cardNumber = null;
        });
      } else {
        print("카드 삭제에 실패하였습니다. : ${response.body}");
      }
    } catch (e) {
      print('카드 삭제에 실패하였습니다. : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("카드 관리"),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : cardNumber == null
                ? ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CardAddScreen()),
                      );
                      fetchCard();
                    },
                    child: Text('카드 등록'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF39c5bb),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xFF39c5bb),
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('등록된 카드\n$cardNumber',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            )),
                        SizedBox(height: 20),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: deleteCard,
                          child: Text('카드 삭제'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF39c5bb),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
