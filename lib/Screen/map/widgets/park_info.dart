import 'dart:convert';

import 'package:appfront/Screen/map/widgets/park_info_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ParkInfo extends StatefulWidget {
  final String name;
  const ParkInfo({super.key, required this.name});

  @override
  State<ParkInfo> createState() => _ParkInfoState();
}

class _ParkInfoState extends State<ParkInfo> {
  dynamic info;

  @override
  void initState() {
    super.initState();
    String url = 'https://api.parkchargego.link/map/park?name=${widget.name}';
    print(url);
    Uri uri = Uri.parse(url);

    http.get(uri).then((response) {
      setState(() {
        info = json.decode(response.body);
        print(info);
      });
    });
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
        child: info == null ? null : InfoData(info: info));
  }
}
