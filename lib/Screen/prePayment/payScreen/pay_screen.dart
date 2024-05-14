import 'package:appfront/Screen/prePayment/payScreen/widget/info_row.dart';
import 'package:appfront/Screen/prePayment/payScreen/widget/park_conatiner.dart';
import 'package:appfront/Screen/prePayment/payScreen/widget/pay_container.dart';
import 'package:appfront/Screen/prePayment/payScreen/widget/term_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PayScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const PayScreen({super.key, required this.data});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  String date = '';

  @override
  void initState() {
    super.initState();

    DateTime original = DateTime.parse(widget.data['entryTime']);
    setState(() {
      date = DateFormat('yyyy.MM.dd. HH:MM').format(original);
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(date);
    return Scaffold(
      appBar: AppBar(title: const Text("사전결제")),
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date),
              const SizedBox(height: 15),
              ParkContainer(data: widget.data),
              const SizedBox(height: 15),
              PayContainer(data: widget.data),
              const SizedBox(height: 15),
              TermContainer(data: widget.data),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Text(
                  "위 결제 내용을 확인하였으며, \n회원 본인은 개인정보 이용,제공 및 결제에 동의합니다.",
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text("결제하기")))
            ],
          ),
        ),
      ),
    );
  }
}
