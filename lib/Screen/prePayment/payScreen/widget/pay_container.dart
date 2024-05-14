import 'package:appfront/Screen/prePayment/payScreen/widget/info_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PayContainer extends StatefulWidget {
  final Map<String, dynamic> data;
  const PayContainer({super.key, required this.data});

  @override
  State<PayContainer> createState() => _PayContainerState();
}

class _PayContainerState extends State<PayContainer> {
  int timeDiff = 0;

  String entryDate = '';

  @override
  void initState() {
    super.initState();
    DateTime dataTime = DateTime.parse(widget.data['entryTime']);
    DateTime now = DateTime.now();

    Duration difference = now.difference(dataTime);
    setState(() {
      entryDate = DateFormat('yyyy.MM.dd. HH:MM').format(dataTime);
      timeDiff = difference.inMinutes;
    });
  }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.data['carNum']}",
            style: const TextStyle(fontSize: 20),
          ),
          InfoRow(title: "입차 시간", value: entryDate),
          InfoRow(title: "주차 시간", value: timeDiff.toString()),
          InfoRow(title: "주차 금액", value: widget.data['amount'] ?? "null"),
          InfoRow(title: "충전량", value: widget.data['chargeAmount'] ?? "null"),
          InfoRow(
              title: "충전 금액",
              value: widget.data['chargeAmount'] == null
                  ? "null"
                  : {int.parse(widget.data['chargeAmount']) * 1000}.toString()),
          InfoRow(
              title: "총액",
              value: widget.data['chargeAmount'] == null
                  ? "null"
                  : {
                      int.parse(widget.data['chargeAmount']) * 1000 +
                          int.parse(widget.data['Amount'])
                    }.toString()),
        ],
      ),
    );
  }
}
