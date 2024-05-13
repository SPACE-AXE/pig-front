import 'package:flutter/material.dart';

import 'package:appfront/Screen/Card/card_add_screen.dart';
import 'package:appfront/main.dart';

class CardScreen extends StatefulWidget {
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Card Management")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CardAddScreen()),
                );
              },
              child: Text('카드 추가'),
            ),
          ],
        ),
      ),
    );
  }
}
