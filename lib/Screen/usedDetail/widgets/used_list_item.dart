import 'package:flutter/material.dart';
import 'package:appfront/Screen/usedDetail/utils/used_formatter.dart';

class UsedListItem extends StatelessWidget {
  final dynamic item;

  const UsedListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF39c5bb),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: item['exitTime'] == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('주차중', style: TextStyle(fontSize: 14)),
                Text('차량 번호: ${formatValue(item['carNum'])}',
                    style: const TextStyle(fontSize: 14)),
                Text('입차 시간: ${formatDateTime(item['entryTime'])}',
                    style: const TextStyle(fontSize: 14)),
              ],
            )
          : (item['totalAmount'] == null) && (item['exitTime'] != null)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('회차 처리됨', style: TextStyle(fontSize: 14)),
                    Text('차량 번호: ${formatValue(item['carNum'])}',
                        style: const TextStyle(fontSize: 14)),
                    Text('입차 시간: ${formatDateTime(item['entryTime'])}',
                        style: const TextStyle(fontSize: 14)),
                    Text('출차 시간: ${formatDateTime(item['exitTime'])}',
                        style: const TextStyle(fontSize: 14)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('차량 번호: ${formatValue(item['carNum'])}',
                        style: const TextStyle(fontSize: 14)),
                    Text(
                        '결제 여부: ${item['isPaid'] == true ? '결제 완료' : '결제 미완료'}',
                        style: const TextStyle(fontSize: 14)),
                    Text('입차 시간: ${formatDateTime(item['entryTime'])}',
                        style: const TextStyle(fontSize: 14)),
                    Text('출차 시간: ${formatDateTime(item['exitTime'])}',
                        style: const TextStyle(fontSize: 14)),
                    if (item['chargeStartTime'] != null)
                      Text(
                          '충전 시작 시간: ${formatDateTime(item['chargeStartTime'])}',
                          style: const TextStyle(fontSize: 14)),
                    if (item['chargeTime'] != null)
                      Text('충전 시간: ${(item['chargeTime'] / 60).toString()} 분',
                          style: const TextStyle(fontSize: 14)),
                    Text('결제 시간: ${formatDateTime(item['paymentTime'])}',
                        style: const TextStyle(fontSize: 14)),
                    if (item['chargeAmount'] != null)
                      Text('충전 요금: ${formatValue(item['chargeAmount'])}원',
                          style: const TextStyle(fontSize: 14)),
                    if (item['parkingAmount'] != null)
                      Text('주차 요금: ${formatValue(item['parkingAmount'])}원',
                          style: const TextStyle(fontSize: 14)),
                    if (item['totalAmount'] != null)
                      Text('합계: ${formatValue(item['totalAmount'])}원',
                          style: const TextStyle(fontSize: 14)),
                  ],
                ),
    );
  }
}
