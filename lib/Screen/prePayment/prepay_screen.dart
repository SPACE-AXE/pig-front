import 'dart:convert';

import 'package:appfront/Screen/Auth/Login/login_screen.dart';
import 'package:appfront/Screen/prePayment/widget/product_container.dart';
import 'package:appfront/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PrePaymentScreen extends StatefulWidget {
  const PrePaymentScreen({super.key});

  @override
  State<PrePaymentScreen> createState() => _PrePaymentScreenState();
}

class _PrePaymentScreenState extends State<PrePaymentScreen> {
  late List<dynamic> data;
  bool isLoading = true;
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    String url = 'https://api.parkchargego.link/parking-transaction';

    Uri uri = Uri.parse(url);

    http.get(uri, headers: {
      'Cookie':
          'access-token=${userData.accessToken}; refresh-token=${userData.refreshToken}',
    }).then((value) {
      dynamic response = json.decode(value.body);
      if (response.runtimeType == List) {
        setState(() {
          isLoading = false;
        });
        List<dynamic> tmp = response;
        if (tmp.isEmpty) {
          debugPrint("tmp: $tmp");
          setState(() {
            isEmpty = true;
          });
        } else {
          setState(() {
            data = tmp;
            debugPrint("12321312321321312: $data");
            debugPrint("data: $data");
          });
        }
      } else {
        if (response['statusCode'] == 403 || response['statusCode'] == 401) {
          Fluttertoast.showToast(
            msg: '로그인이 필요한 기능입니다.',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: const Color(0xff39c5bb),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg: "알 수 없는 오류가 발생했습니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xff39c5bb),
            textColor: Colors.white,
            fontSize: 16,
          );
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("사전결제 스크린")),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : isEmpty
                ? const Center(
                    child: Text("결제가 필요한 데이터가 없습니다"),
                  )
                : makeProductList(data));
  }

  Column makeProductList(List<dynamic> data) {
    List<Widget> containers = [];
    for (var product in data) {
      containers.add(Row(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          ProductContainer(data: product),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ));
      containers.add(
        SizedBox(height: 40, width: MediaQuery.of(context).size.width * 0.9),
      );
    }
    containers.add(Row(
      children: [
        const Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        ProductContainer(data: data[0]),
        const Expanded(
          flex: 1,
          child: SizedBox(),
        ),
      ],
    ));
    print("$data");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: containers,
    );
  }
}
