import 'dart:convert';
import 'package:http/http.dart' as http;

class CardService {
  static const String apiUrl = "https://api.parkchargego.link/api/v1/payment/card";

  static Future<String?> fetchCard(String accessToken, String refreshToken) async {
    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['number'];
      }
    } catch (e) {
      print('카드 조회 실패: $e');
    }
    return null;
  }

  static Future<bool> registerCard(
      String cardNumber, String month, String year, String accessToken, String refreshToken) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken',
        },
        body: jsonEncode({
          "number": cardNumber,
          "expiryMonth": month,
          "expiryYear": year,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print("카드 등록 실패: $e");
      return false;
    }
  }

  static Future<bool> deleteCard(String accessToken, String refreshToken) async {
    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print("카드 삭제 실패: $e");
      return false;
    }
  }
}
