import 'package:appfront/Screen/Car/car_screen.dart';
import 'package:appfront/Screen/Card/card_screen.dart';
import 'package:appfront/Screen/user/user_info_screen.dart';
import 'package:appfront/userData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:appfront/Screen/usedDetail/used_detail_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Drawer(
          child: ListView(
            children: [
              Container(
                height: 100, // 원하는 높이로 설정합니다.
                decoration: const BoxDecoration(),
                child: const Center(
                  child: Text(
                    'Custom Header',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  return ListTile(
                    title: const Text('나의 정보'),
                    onTap: () {
                      ref.read(userDataProvider).name == null
                          ? Fluttertoast.showToast(
                              msg: "로그인이 필요한 기능입니다.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: const Color(0xff39c5bb),
                              textColor: Colors.white,
                              fontSize: 16,
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserInfoScreen(),
                              ),
                            );
                    },
                  );
                },
              ),
              ListTile(
                title: Text('이용 기록'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsedScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('차량 등록'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('카드 등록'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardScreen(),
                    ),
                  );
                },
              ),
              const ListTile(
                title: Text('고객 문의'),
              ),
              const ListTile(
                title: Text('이용 약관'),
              ),
              const ListTile(
                title: Text('환경 설정'),
              ),
              ListTile(
                title: const Text('로그아웃'),
                onTap: () {
                  ref.read(userDataProvider).id == null
                      ? null
                      : {
                          Fluttertoast.showToast(
                            msg: "로그아웃되었습니다.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: const Color(0xff39c5bb),
                            textColor: Colors.white,
                            fontSize: 16,
                          ),
                          ref.read(userDataProvider).deleteUserData(),
                          Navigator.pop(context)
                        };
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
