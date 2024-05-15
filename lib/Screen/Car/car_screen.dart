import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:appfront/Screen/Car/car_add_screen.dart';
import 'package:appfront/userData.dart';
import 'package:appfront/main.dart';

class CarScreen extends StatefulWidget {
  @override
  _CarScreenState createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  bool isLoading = true;
  List<Map<String, String>> cars = [];

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars() async {
    String apiUrl = "https://api.parkchargego.link/car";
    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Cookie':
              'access-token=${userData.accessToken}; refresh-token=${userData.refreshToken}'
        },
      );
      debugPrint("Response headers: ${response.headers}");
      debugPrint("Response Body: ${response.body}");
      debugPrint("Response statusCode: ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['id'] != null && jsonResponse['carNum'] != null) {
          setState(() {
            cars = [
              {
                'id': jsonResponse['id'].toString(),
                'carNum': jsonResponse['carNum'].toString()
              }
            ];
            isLoading = false;
            debugPrint("1번");
          });
        } else {
          setState(() {
            isLoading = false;
            cars = [];
            debugPrint("2번");
          });
        }
      } else {
        setState(() {
          isLoading = false;
          debugPrint("3번");
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
    String apiUrl = "https://api.parkchargego.link/car/${carId}";
    debugPrint("https://api.parkchargego.link/car/${carId}");
    try {
      var response = await http.delete(Uri.parse(apiUrl), headers: {
        'Content-Type': 'application/json',
        'Cookie':
            'access-token=${userData.accessToken}; refresh-token=${userData.refreshToken}'
      });
      if (response.statusCode == 200) {
        print("차량 삭제 성공");
        await fetchCars();
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
                      fetchCars();
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
                          onPressed: () => deleteCar(cars[index]['id']!),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: cars.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarAddScreen()),
                );
                fetchCars();
              },
              child: Icon(Icons.add),
            ),
    );
  }
}
