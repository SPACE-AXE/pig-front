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
      child: const Column(
        children: [
          ExpansionTile(title: Text("대충약관")),
          ExpansionTile(title: Text("대충약관")),
        ],
      ),
    );
  }
}
