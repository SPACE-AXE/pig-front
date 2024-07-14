import 'dart:convert';
import 'package:appfront/userData.dart';
import 'package:appfront/Screen/usedDetail/used_detail_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyCarouselSlider extends StatefulWidget {
  UserData userData;
  MyCarouselSlider({super.key, required this.userData});

  @override
  State<MyCarouselSlider> createState() => _MyCarouselSliderState();
}

class _MyCarouselSliderState extends State<MyCarouselSlider> {
  late List<dynamic> data;
  int selectedId = 0;
  bool isLoading = true;
  bool isEmpty = false;
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: isEmpty
                ? const Center(
                    child: Text(
                      "이용 기록이 없습니다.",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      CarouselSlider(
                        carouselController: _controller,
                        items: data.map(
                          (value) {
                            final time = DateFormat('yyyy.MM.dd. HH:mm')
                                .format(DateTime.parse(value['entryTime']));
                            return Builder(
                              builder: (context) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xff39c5bb),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Color(0xff39c5bb),
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "이용기록",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const UsedScreen(), // UsedScreen으로 이동
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "결제 시간",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  DateFormat(
                                                          'yyyy.MM.dd. HH:mm')
                                                      .format(DateTime.parse(
                                                          value[
                                                              'paymentTime'])),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "주차 비용",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  value['parkingAmount'] != null
                                                      ? "${value['parkingAmount']}"
                                                      : "0",
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "충전 비용",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  "${value['chargeAmount'] ?? "0"}",
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "총액",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Text(
                                                  value['totalAmount'] != null
                                                      ? "${value['totalAmount']}"
                                                      : '0',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(
                              () {
                                _current = index;
                              },
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: data.asMap().entries.map(
                            (entry) {
                              return GestureDetector(
                                onTap: () =>
                                    _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 5,
                                  height: 10,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(
                                        _current == entry.key ? 0.9 : 0.4),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      )
                    ],
                  ),
          );
  }

  void getData() async {
    String url = 'https://api.parkchargego.link/api/v1/parking-transaction';
    Uri uri = Uri.parse(url);
    const storage = FlutterSecureStorage();

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
          List<dynamic> tmp = response;
          debugPrint("tmp:$response");
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
