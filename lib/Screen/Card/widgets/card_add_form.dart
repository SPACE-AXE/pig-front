import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appfront/Screen/Card/utils/card_add_utils.dart';

class CardAddForm extends ConsumerStatefulWidget {
  const CardAddForm({super.key});

  @override
  _CardAddFormState createState() => _CardAddFormState();
}

class _CardAddFormState extends ConsumerState<CardAddForm> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  Future<void> _registerCard() async {
    final success = await registerCard(
      context,
      ref,
      cardNumberController.text,
      monthController.text,
      yearController.text,
    );

    if (success) {
      Navigator.of(context).pop(); // 다이얼로그 닫기
      Navigator.of(context).pop(); // 카드 등록 페이지 닫기
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            decoration: const InputDecoration(
              hintText: "0000 0000 0000 0000",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff39c5bb)),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: monthController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: const InputDecoration(
                    hintText: "MM",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff39c5bb)),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: const InputDecoration(
                    hintText: "YY",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff39c5bb)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _registerCard,
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xff39c5bb)),
          child: const Text('등록 완료'),
        ),
      ],
    );
  }
}
