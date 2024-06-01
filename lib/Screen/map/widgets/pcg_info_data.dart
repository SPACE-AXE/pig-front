import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PcgInfoData extends StatefulWidget {
  final dynamic info;
  const PcgInfoData({super.key, required this.info});

  @override
  State<PcgInfoData> createState() => _PcgInfoDataState();
}

class _PcgInfoDataState extends State<PcgInfoData> {
  @override
  void initState() {
    super.initState();
  }

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
                widget.info['address'],
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
                "연락처",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                widget.info['phone'].toString(),
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "주차 구획 수",
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
                    DataColumn(label: Text('일반 구역')),
                    DataColumn(label: Text('장애인 구역')),
                    DataColumn(label: Text('총계')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text("${widget.info['disabilitySpace']}")),
                      DataCell(Text("${widget.info['carSpace']}")),
                      DataCell(Text("${widget.info['totalSpace']}")),
                    ]),
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
                  columns: const [
                    DataColumn(
                      label: Text('기본 1분'),
                    ),
                    DataColumn(label: Text('추가 1분')),
                    DataColumn(label: Text('1일 주차')),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(
                        Text("0 원"),
                      ),
                      DataCell(Text("100 원")),
                      DataCell(Text("10,000 원")),
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
