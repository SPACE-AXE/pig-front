import 'dart:convert';
import 'package:http/http.dart' as http;

class CarService {
  static const String apiUrl = "https://api.parkchargego.link/api/v1/car";

  static Future<List<Map<String, String>>?> fetchCars(
      String accessToken, String refreshToken) async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken',
      });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as List;
        return jsonResponse
            .map((car) => {
                  'id': car['id'].toString(),
                  'carNum': car['carNum'].toString(),
                })
            .toList();
      }
    } catch (e) {
      print('차량 조회 실패: $e');
    }
    return null;
  }

  static Future<void> deleteCar(
      String carId, String accessToken, String refreshToken) async {
    final apiUrlWithId = "$apiUrl/$carId";
    try {
      final response = await http.delete(Uri.parse(apiUrlWithId), headers: {
        'Content-Type': 'application/json',
        'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken',
      });
      if (response.statusCode != 200) {
        print("차량 삭제 실패");
      }
    } catch (e) {
      print('차량 삭제 실패: $e');
    }
  }
}
