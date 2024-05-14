import 'dart:convert';

import 'package:appfront/Screen/Auth/Login/login_screen.dart';
import 'package:appfront/Screen/prePayment/select_screen/widget/enter_btn.dart';
import 'package:appfront/Screen/prePayment/select_screen/widget/product_container.dart';
import 'package:appfront/main.dart';
import 'package:appfront/userData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SelectScreen extends StatefulWidget {
  UserData userData;
  SelectScreen({super.key, required this.userData});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  late List<dynamic> data;
  int selectedId = 0;
  bool isLoading = true;
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
  }

  void updateId(int value) {
    setState(() {
      selectedId = value;
    });
    debugPrint("$selectedId");
  }

  dynamic dataGetter(int value) {
    final tmp = data.where((element) => element['id'] == value).toList();
    debugPrint("tmp: $tmp");
    return tmp[0];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(userDataProvider);
      getData();
      return Scaffold(
        appBar: AppBar(title: const Text("사전결제")),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : isEmpty
                ? const Center(
                    child: Text("결제가 필요한 데이터가 없습니다"),
                  )
                : makeProductList(data),
        floatingActionButton: EnterBtn(
          dataGetter: dataGetter,
          selectedId: selectedId,
        ),
      );
    });
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
          ProductContainer(
            data: product,
            selectedId: selectedId,
            updateId: updateId,
          ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: containers,
    );
  }

  void getData() async {
    String url = 'http://localhost:3000/parking-transaction';
    Uri uri = Uri.parse(url);
    await http.get(uri, headers: {
      'Cookie':
          'access-token=${widget.userData.accessToken}; refresh-token=${widget.userData.refreshToken}',
    }).then((value) {
      dynamic response = json.decode(value.body);
      if (isLoading) {
        if (response.runtimeType == List) {
          setState(() {
            isLoading = false;
          });
          List<dynamic> tmp = response;
          if (tmp.isEmpty) {
            setState(() {
              isEmpty = true;
            });
          } else {
            setState(() {
              data = tmp;
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
