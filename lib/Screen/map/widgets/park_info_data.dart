import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ParkInfoData extends StatefulWidget {
  final dynamic info;
  const ParkInfoData({super.key, required this.info});

  @override
  State<ParkInfoData> createState() => _ParkInfoDataState();
}

class _ParkInfoDataState extends State<ParkInfoData> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.info['name'],
            style: const TextStyle(fontSize: 30),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.info['addr'],
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.info['addr']));
                },
                icon: const Icon(Icons.copy),
                color: Colors.black.withOpacity(0.5),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "주차 구획 수",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                widget.info['space'],
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "장애인 주차 구역 여부",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                widget.info['disabled'],
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "시간",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DataTable(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff39c5bb)),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  columns: const [
                    DataColumn(label: Text('평일')),
                    DataColumn(label: Text('토요일')),
                    DataColumn(label: Text('주말,공휴일')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(
                          Text("${widget.info['time']['weekdayOpenAt']} ~")),
                      DataCell(Text("${widget.info['time']['satOpenAt']} ~")),
                      DataCell(
                          Text("${widget.info['time']['holidayOpenAt']} ~")),
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text("${widget.info['time']['weekdayCloseAt']}")),
                      DataCell(Text("${widget.info['time']['satCloseAt']}")),
                      DataCell(
                          Text("${widget.info['time']['holidayCloseAt']}")),
                    ])
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "가격",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DataTable(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff39c5bb)),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  columns: [
                    DataColumn(
                      label: widget.info['price']['baseTime'] == '0' ||
                              widget.info['price']['baseTime'] == ''
                          ? const Text("자료없음")
                          : Text('기본 ${widget.info['price']['baseTime']}분'),
                    ),
                    DataColumn(
                        label: widget.info['price']['unitTime'] == '0' ||
                                widget.info['price']['unitTime'] == ''
                            ? const Text("자료없음")
                            : Text('추가 ${widget.info['price']['unitTime']}분')),
                    const DataColumn(label: Text('1일 주차')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(
                        widget.info['price']['basePrice'] != ''
                            ? Text('${widget.info['price']['basePrice']}원')
                            : const Text("자료없음"),
                      ),
                      DataCell(widget.info['price']['unitPrice'] != ''
                          ? Text('${widget.info['price']['unitPrice']}원')
                          : const Text("자료없음")),
                      DataCell(widget.info['price']['dayPrice'] != ''
                          ? Text('${widget.info['price']['dayPrice']}원')
                          : const Text("자료없음")),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
