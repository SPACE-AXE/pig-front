import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appfront/Screen/Car/services/car_add_service.dart';
import 'package:appfront/userData.dart';

class CarAddScreen extends ConsumerStatefulWidget {
  const CarAddScreen({super.key});

  @override
  _CarAddScreenState createState() => _CarAddScreenState();
}

class _CarAddScreenState extends ConsumerState<CarAddScreen> {
  TextEditingController carNumberController = TextEditingController();

  Future<void> registerCar() async {
    String carNum = carNumberController.text;

    if (carNum.isEmpty) {
      _showDialog("Error", "차량 번호는 필수 요소입니다.");
      return;
    }

    final data = ref.read(userDataProvider);
    final accessToken = await data.storage!.read(key: "accessToken");
    final refreshToken = await data.storage!.read(key: "refreshToken");

    final response =
        await CarService.registerCar(carNum, accessToken!, refreshToken!);

    if (response == 201) {
      _showDialog("Success", "차량 등록 성공.", onSuccess: true);
    } else if (response == 409) {
      _showDialog("Error", "이미 등록된 차량 번호입니다.");
    } else {
      _showDialog("Error", "차량 등록 실패");
    }
  }

  void _showDialog(String title, String content, {bool onSuccess = false}) {
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
                Navigator.of(context).pop();
                if (onSuccess) Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("차량 등록"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: carNumberController,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[ㄱ-ㅎㅏ-ㅣ0-9a-zA-Z가-힣]+')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "차량 번호는 필수 요소입니다.";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "차량 번호 입력 (예: 25머2452)",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff39c5bb),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerCar,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xff39c5bb),
              ),
              child: const Text('등록 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
