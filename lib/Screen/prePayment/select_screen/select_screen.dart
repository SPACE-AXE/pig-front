import 'dart:convert';

import 'package:appfront/Screen/Auth/Login/login_screen.dart';
import 'package:appfront/Screen/prePayment/payScreen/pay_screen.dart';
import 'package:appfront/Screen/prePayment/select_screen/widget/enter_btn.dart';
import 'package:appfront/Screen/prePayment/select_screen/widget/product_container.dart';
import 'package:appfront/main.dart';
import 'package:appfront/userData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SelectScreen extends StatefulWidget {
  UserData userData;
  SelectScreen({super.key, required this.userData});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  late Map<String, dynamic> data;
  int selectedId = 0;
  bool isLoading = true;
  bool isEmpty = false;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void updateId(int value) {
    setState(() {
      selectedId = value;
    });
  }

  // dynamic dataGetter(int value) {
  //   final tmp = data.where((element) => element['id'] == value).toList();
  //   return tmp[0];
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(userDataProvider);
      getData();
      return Scaffold(
        appBar: AppBar(
          title: const Text("사전결제"),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : isEmpty
                ? const Center(
                    child: Text("결제가 필요한 데이터가 없습니다"),
                  )
                : PayScreen(data: data),
      );
    });
  }

  Column makeProductList(List<dynamic> data) {
    List<Widget> containers = [];
    for (var product in data) {
      debugPrint("123$product");
      product['paymentTime'] == null
          ? {
              containers.add(Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  PayScreen(data: product),
                  // ProductContainer(
                  //   data: product,
                  //   selectedId: selectedId,
                  //   updateId: updateId,
                  // ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              )),
              containers.add(
                SizedBox(
                    height: 40, width: MediaQuery.of(context).size.width * 0.9),
              )
            }
          : debugPrint("widget.data: ${product['paymentTime']}");
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: containers,
    );
  }

  void getData() async {
    String url = 'https://api.parkchargego.link/api/v1/parking-transaction';
    Uri uri = Uri.parse(url);
    final accessToken = await storage.read(key: "accessToken");
    final refreshToken = await storage.read(key: "refreshToken");
    await http.get(uri, headers: {
      'Cookie': 'access-token=$accessToken; refresh-token=$refreshToken',
    }).then((value) {
      dynamic response = json.decode(value.body);
      if (isLoading) {
        if (response.runtimeType == List) {
          setState(() {
            isLoading = false;
          });
          List<dynamic> tmp = [];
          response.map((e) {
            debugPrint('$e');
            if (e['isPaid'] == false) {
              tmp.add(e);
            }
          }).toList();
          if (tmp.isEmpty) {
            setState(() {
              isEmpty = true;
            });
          } else {
            debugPrint("tmp: ${tmp[0]}");
            setState(() {
              data = tmp[0];
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
      }
    });
  }
}
