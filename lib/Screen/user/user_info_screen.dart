import 'package:appfront/Screen/Car/car_screen.dart';
import 'package:appfront/Screen/user/widget/slider_widget.dart';
import 'package:appfront/userData.dart';
import 'package:appfront/Screen/usedDetail/used_detail_screen.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("나의 정보")),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xff39c5bb),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  return Column(
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
                        child: const Text(
                          "프로필",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "이름",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "${ref.read(userDataProvider).name}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "전화번호",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "전화번호",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "이메일",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "${ref.read(userDataProvider).email}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "차량정보",
                            style: TextStyle(fontSize: 20),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff39c5bb),
                              elevation: 5,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CarScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "확인하기",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Consumer(
              builder: (context, ref, child) {
                final data = ref.read(userDataProvider);
                debugPrint("${data.accessToken}");
                return MyCarouselSlider(
                  userData: data,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
