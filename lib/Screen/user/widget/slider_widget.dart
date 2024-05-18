import 'dart:convert';

import 'package:appfront/userData.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
            height: MediaQuery.of(context).size.height * 0.3,
            child: Stack(children: [
              CarouselSlider(
                carouselController: _controller,
                items: data.map(
                  (e) {
                    final time = DateFormat('yyyy.MM.dd. HH:MM')
                        .format(DateTime.parse(e['entryTime']));
                    return Builder(
                      builder: (context) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff39c5bb),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
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
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Text("!23"),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${e['park']['name']}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    time,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "주차 비용",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "123",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "충전비용",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "123",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "총액",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "123",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: data.asMap().entries.map(
                    (entry) {
                      print("$entry");
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black
                                .withOpacity(_current == entry.key ? 0.9 : 0.4),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              )
            ]),
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
          debugPrint("$tmp");
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
