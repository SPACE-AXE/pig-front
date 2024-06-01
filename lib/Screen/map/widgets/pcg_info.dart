import 'dart:convert';

import 'package:appfront/Screen/map/widgets/park_info_data.dart';
import 'package:appfront/Screen/map/widgets/pcg_info_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class PcgInfo extends StatefulWidget {
  final String name;
  final dynamic tmp;
  const PcgInfo({super.key, required this.name, required this.tmp});

  @override
  State<PcgInfo> createState() => _PcgInfoState();
}

class _PcgInfoState extends State<PcgInfo> {
  @override
  void initState() {
    super.initState();
    debugPrint("qwe${widget.tmp}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25.0), // 상단 모서리를 둥글게 만듭니다.
          ),
          border: Border.all(color: const Color(0xff39c5bb), width: 1),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: widget.tmp == null ? null : PcgInfoData(info: widget.tmp));
  }
}
