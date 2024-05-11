import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardAddScreen extends StatefulWidget {
  @override
  _CardAddScreenState createState() => _CardAddScreenState();
}

class _CardAddScreenState extends State<CardAddScreen> {
  DateTime? expiryDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: expiryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != expiryDate) {
      setState(() {
        expiryDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Card Add Screen")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16)
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "필수 입력값입니다.";
                    } else if (value.length != 16) {
                      return "카드 번호는 16자리여야 합니다.";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "카드 번호",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff39c5bb),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3)
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "필수 입력값입니다.";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "CVC 번호",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff39c5bb),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    expiryDate == null
                        ? "유효 기간 선택"
                        : "유효 기간: ${expiryDate!.year.toString().padLeft(4, '0')}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}",
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // API 호출 또는 다음 화면으로 이동하는 로직 추가
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xff39c5bb), // 'primary' 대신 'backgroundColor' 사용
                ),
                child: Text('확인'),
              ),
            ],
          ),
        ));
  }
}
