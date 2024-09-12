import 'dart:convert';
import 'package:http/http.dart' as http;

class CarService {
  static const String apiUrl = "https://api.parkchargego.link/api/v1/car";

  static Future<int?> registerCar(
      String carNum, String accessToken, String refreshToken) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken'
        },
        body: jsonEncode({"carNum": carNum}),
      );
      return response.statusCode;
    } catch (e) {
      print("차량 등록 실패: $e");
      return null;
    }
  }
}
