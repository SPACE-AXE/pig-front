import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appfront/Screen/Card/card_add_screen.dart';
import 'package:appfront/userData.dart';

class CardScreen extends ConsumerStatefulWidget {
  const CardScreen({super.key});

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
    String apiUrl = "https://api.parkchargego.link/api/v1/payment/card";
    try {
      final data = ref.read(userDataProvider);
      final accessToken = await data.storage!.read(key: "accessToken");
      final refreshToken = await data.storage!.read(key: "refreshToken");
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken'
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
      print('카드 조회에 실패했습니다.');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteCard() async {
    String apiUrl = "https://api.parkchargego.link/api/v1/payment/card";
    try {
      final data = ref.read(userDataProvider);
      final accessToken = await data.storage!.read(key: "accessToken");
      final refreshToken = await data.storage!.read(key: "refreshToken");
      var response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken'
        },
      );
      if (response.statusCode == 200) {
        print("카드를 삭제했습니다.");
        setState(() {
          cardNumber = null;
        });
      } else {
        print("카드 삭제에 실패하였습니다.");
      }
    } catch (e) {
      print('카드 삭제에 실패하였습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("카드 관리"),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : cardNumber == null
                ? ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CardAddScreen()),
                      );
                      fetchCard();
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF39c5bb),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                    child: const Text('카드 등록'),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF39c5bb),
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
                        const SizedBox(height: 20),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: deleteCard,
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF39c5bb),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          child: const Text('카드 삭제'),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
