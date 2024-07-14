import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:appfront/userData.dart';

class UsedScreen extends ConsumerStatefulWidget {
  const UsedScreen({super.key});

  @override
  _UsedScreenState createState() => _UsedScreenState();
}

class _UsedScreenState extends ConsumerState<UsedScreen> {
  bool isLoading = true;
  List<dynamic> jsonResponse = [];
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = ref.read(userDataProvider);
      final accessToken = await storage.read(key: "accessToken");
      final refreshToken = await storage.read(key: "refreshToken");
      fetchused(accessToken!, refreshToken!);
    });
  }

  Future<void> fetchused(String accessToken, String refreshToken) async {
    String apiUrl = "https://api.parkchargego.link/api/v1/parking-transaction";
    try {
      var response = await http.get(Uri.parse(apiUrl), headers: {
        'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken'
      });

      if (response.statusCode == 200) {
        setState(() {
          jsonResponse = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('이용 기록 조회 실패');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDateTime(dynamic dateTime) {
    if (dateTime == null || dateTime.toString().isEmpty) return '';
    try {
      final parsedDate = DateTime.parse(dateTime.toString());
      final formatter = DateFormat('yyyy년 MM월 dd일 HH시 mm분');
      return formatter.format(parsedDate);
    } catch (e) {
      return dateTime.toString();
    }
  }

  String formatValue(dynamic value) {
    return value?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("이용 내역"),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : jsonResponse.isEmpty
                ? const Text('이용 내역이 없습니다.')
                : ListView.builder(
                    itemCount: jsonResponse.length,
                    itemBuilder: (context, index) {
                      final item = jsonResponse[index];
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF39c5bb),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: item['exitTime'] == null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    const Text(
                                      '주차중',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      '차량 번호: ${formatValue(item['carNum'])}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      '입차 시간: ${formatDateTime(item['entryTime'])}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ])
                            : (item['totalAmount'] == null) &&
                                    (item['exitTime'] != null)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        const Text(
                                          '회차 처리됨',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          '차량 번호: ${formatValue(item['carNum'])}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          '입차 시간: ${formatDateTime(item['entryTime'])}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          '출차 시간: ${formatDateTime(item['exitTime'])}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ])
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '차량 번호: ${formatValue(item['carNum'])}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        '결제 여부: ${item['isPaid'] == true ? '결제 완료' : '결제 미완료'}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        '입차 시간: ${formatDateTime(item['entryTime'])}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        '출차 시간: ${formatDateTime(item['exitTime'])}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      if (item['chargeStartTime'] != null &&
                                          item['chargeStartTime']
                                              .toString()
                                              .isNotEmpty)
                                        Text(
                                          '충전 시작 시간: ${formatDateTime(item['chargeStartTime'])}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      if (item['chargeTime'] != null &&
                                          item['chargeTime']
                                              .toString()
                                              .isNotEmpty)
                                        Text(
                                          '충전 시간: ${(item['chargeTime'] / 60).toString()} 분',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      Text(
                                        '결제 시간: ${formatDateTime(item['paymentTime'])}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      if (item['chargeAmount'] != null &&
                                          item['chargeAmount']
                                              .toString()
                                              .isNotEmpty)
                                        Text(
                                          '충전 요금: ${formatValue(item['chargeAmount'])}원',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      if (item['parkingAmount'] != null &&
                                          item['parkingAmount']
                                              .toString()
                                              .isNotEmpty)
                                        Text(
                                          '주차 요금: ${formatValue(item['parkingAmount'])}원',
                                          style: const TextStyle(fontSize: 14),
                                        )
                                      else
                                        const Text(
                                          '충전 요금: 0원',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      if (item['totalAmount'] != null &&
                                          item['totalAmount']
                                              .toString()
                                              .isNotEmpty)
                                        Text(
                                          '합계: ${formatValue(item['totalAmount'])}원',
                                          style: const TextStyle(fontSize: 14),
                                        )
                                      else
                                        const Text(
                                          '총 요금: 0원',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                    ],
                                  ),
                      );
                    },
                  ),
      ),
    );
  }
}
