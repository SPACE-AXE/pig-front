import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appfront/Screen/Card/services/card_service.dart';
import 'package:appfront/userData.dart';

Future<bool> registerCard(BuildContext context, WidgetRef ref,
    String cardNumber, String month, String year) async {
  final data = ref.read(userDataProvider);
  final accessToken = await data.storage!.read(key: "accessToken");
  final refreshToken = await data.storage!.read(key: "refreshToken");

  final success = await CardService.registerCard(
    cardNumber,
    month,
    year,
    accessToken!,
    refreshToken!,
  );

  if (success) {
    _showDialog(context, "카드 등록", "카드 등록에 성공했습니다.", true);
    return true;
  } else {
    _showDialog(context, "Error", "카드 등록에 실패했습니다.", false);
    return false;
  }
}

void _showDialog(
    BuildContext context, String title, String content, bool success) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
          ),
        ],
      );
    },
  );
}
