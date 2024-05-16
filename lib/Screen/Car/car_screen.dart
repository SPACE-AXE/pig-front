import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appfront/Screen/Car/car_add_screen.dart';
import 'package:appfront/userData.dart';
import 'package:appfront/main.dart';

class CarScreen extends ConsumerStatefulWidget {
  @override
  _CarScreenState createState() => _CarScreenState();
}

class _CarScreenState extends ConsumerState<CarScreen> {
  bool isLoading = true;
  List<Map<String, String>> cars = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = ref.read(userDataProvider);
      fetchCars(data.accessToken!, data.refreshToken!);
    });
  }

  Future<void> fetchCars(String accessToken, String refreshToken) async {
    String apiUrl = "https://api.parkchargego.link/car";
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
      print('차량 조회 실패: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteCar(String carId) async {
    final data = ref.read(userDataProvider);
    String apiUrl = "https://api.parkchargego.link/car/$carId";
    try {
      var response = await http.delete(Uri.parse(apiUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'access-token=${data.accessToken}; refresh-token=${data.refreshToken}'
      });
      if (response.statusCode == 200) {
        print("차량 삭제 성공");
        await fetchCars(data.accessToken!, data.refreshToken!);
      } else {
        print("차량 삭제 실패: ${response.body}");
      }
    } catch (e) {
      print('차량 삭제 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Car Management")),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : cars.isEmpty
                ? ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CarAddScreen()),
                      );
                      final data = ref.read(userDataProvider);
                      fetchCars(data.accessToken!, data.refreshToken!);
                    },
                    child: Text('차량 추가'),
                  )
                : ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('차량 번호: ${cars[index]['carNum']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await deleteCar(cars[index]['id']!);
                          },
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CarAddScreen()),
          );
          final data = ref.read(userDataProvider);
          fetchCars(data.accessToken!, data.refreshToken!);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
