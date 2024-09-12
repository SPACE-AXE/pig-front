import 'package:flutter/material.dart';
import 'package:appfront/Screen/Card/widgets/card_add_form.dart';

class CardAddScreen extends StatelessWidget {
  const CardAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("카드 등록"),
        centerTitle: true,
      ),
      body: const Center(
        child: CardAddForm(), // 폼 위젯을 따로 분리하여 호출
      ),
    );
  }
}
