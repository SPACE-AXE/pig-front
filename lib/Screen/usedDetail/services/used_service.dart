import 'dart:convert';
import 'package:http/http.dart' as http;

class UsedService {
  static const String apiUrl =
      "https://api.parkchargego.link/api/v1/parking-transaction";

  static Future<List<dynamic>?> fetchUsedData(
      String accessToken, String refreshToken) async {
    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken'
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('이용 기록 조회 실패: $e');
    }
    return null;
  }
}
