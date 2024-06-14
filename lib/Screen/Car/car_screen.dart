import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appfront/Screen/Car/car_add_screen.dart';
import 'package:appfront/userData.dart';

class CarScreen extends ConsumerStatefulWidget {
  const CarScreen({super.key});

  @override
  _CarScreenState createState() => _CarScreenState();
}

class _CarScreenState extends ConsumerState<CarScreen> {
  bool isLoading = true;
  List<Map<String, String>> cars = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = ref.read(userDataProvider);
      final accessToken = await data.storage!.read(key: "accessToken");
      final refreshToken = await data.storage!.read(key: "refreshToken");
      fetchCars(accessToken!, refreshToken!);
    });
  }

  Future<void> fetchCars(String accessToken, String refreshToken) async {
    String apiUrl = "https://api.parkchargego.link/api/v1/car";
    try {
      var response = await http.get(Uri.parse(apiUrl), headers: {
        'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken'
      });
      debugPrint("Response headers: ${response.headers}");
      debugPrint("Response Body: ${response.body}");
      debugPrint("Response statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as List;
        setState(() {
          cars = jsonResponse.map((car) {
            return {
              'id': car['id'].toString(),
              'carNum': car['carNum'].toString()
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('차량 조회 실패');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteCar(String carId) async {
    final data = ref.read(userDataProvider);
    final accessToken = await data.storage!.read(key: "accessToken");
    final refreshToken = await data.storage!.read(key: "refreshToken");
    String apiUrl = "https://api.parkchargego.link/api/v1/car/$carId";
    try {
      var response = await http.delete(Uri.parse(apiUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken'
      });
      if (response.statusCode == 200) {
        print("차량 삭제 성공");
        await fetchCars(accessToken!, refreshToken!);
      } else {
        print("차량 삭제 실패");
      }
    } catch (e) {
      print('차량 삭제 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("차량 관리"),
          centerTitle: true,
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : cars.isEmpty
                  ? null
                  : ListView.builder(
                      itemCount: cars.length,
                      itemBuilder: (context, index) {
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '차량 번호: ${cars[index]['carNum']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.blueGrey),
                                onPressed: () async {
                                  await deleteCar(cars[index]['id']!);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CarAddScreen()),
            );
            final data = ref.read(userDataProvider);
            final accessToken = await data.storage!.read(key: "accessToken");
            final refreshToken = await data.storage!.read(key: "refreshToken");
            fetchCars(accessToken!, refreshToken!);
          },
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF39c5bb),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: const Icon(Icons.add),
        ));
  }
}
