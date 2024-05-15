import 'package:flutter/material.dart';

class TermContainer extends StatelessWidget {
  final Map<String, dynamic> data;
  const TermContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ExpansionTile(
            title: const Text("대충약관"),
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                child: const Text(
                    "제공받는자: 탐나몰\n목적: 판매자와 구매자의 거래의 원활한 진행, 본인 의사의 확인, 고객 상담 및 불만처리, 상품과 경품배송을 위한 배송지 확인 등\n항목: ID, 성명, 전화번호, 휴대전화번호, 배송지 주소, 이메일주소(선택시), 통관고유부호(선택시), 생년월일(선택시), 공동현관 출입번호(선택시)\n보유기간: 구매 서비스 종료 후 1개월\n동의를 거부하실 수 있습니다. 단, 동의하지 않으실 경우 구매가 제한될 수 있습니다."),
              )
            ],
          ),
          ExpansionTile(
            title: const Text("대충약관"),
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                child: const Text(
                    "제공받는자: 탐나몰\n목적: 판매자와 구매자의 거래의 원활한 진행, 본인 의사의 확인, 고객 상담 및 불만처리, 상품과 경품배송을 위한 배송지 확인 등\n항목: ID, 성명, 전화번호, 휴대전화번호, 배송지 주소, 이메일주소(선택시), 통관고유부호(선택시), 생년월일(선택시), 공동현관 출입번호(선택시)\n보유기간: 구매 서비스 종료 후 1개월\n동의를 거부하실 수 있습니다. 단, 동의하지 않으실 경우 구매가 제한될 수 있습니다."),
              )
            ],
          ),
        ],
      ),
    );
  }
}
