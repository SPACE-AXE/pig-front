import 'package:appfront/Screen/prePayment/payScreen/widget/info_row.dart';
import 'package:flutter/material.dart';

class ParkContainer extends StatelessWidget {
  final Map<String, dynamic> data;
  const ParkContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xff39c5bb),
          width: 3,
        ),
      ),
      child: Column(
        children: [
          InfoRow(title: "주차장 이름", value: data['park']['name']),
          InfoRow(title: "주차장 연락처", value: data['park']['phone']),
          InfoRow(title: "주차장 주소", value: data['park']['address']),
        ],
      ),
    );
  }
}
