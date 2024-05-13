import 'dart:math';
import 'package:appfront/Screen/map/map_screen.dart';
import 'package:flutter/material.dart';

import 'package:appfront/userData.dart';
import 'package:appfront/Screen/Auth/Login/login_screen.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:appfront/QRScreen.dart';
import 'package:appfront/Screen/prePayment/prepay_screen.dart';
import 'package:appfront/Screen/Card/card_screen.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: "etuftq1yhk");
  runApp(const ProviderScope(child: MainApp()));
}

UserData userData = UserData();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _buildAppBar(),
        body: MainBody(context: context),
        floatingActionButton: const DraggableFloatingActionButton(),
      ),
    );
  }

  AppBar _buildAppBar() {
    //AppBar 레이아웃
    return AppBar(
      backgroundColor: const Color(0xFFE9FDFB),
      leading: Container(
        alignment: Alignment.center,
        child: Transform.scale(
          scale: 2,
          alignment: Alignment.centerLeft,
          child: Image.asset('lib/assets/images/title2.png', fit: BoxFit.cover),
        ),
      ),
      title: const Text('', style: TextStyle(color: Colors.transparent)),
      actions: <Widget>[
        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            );
          },
        ),
      ],
      elevation: 0,
    );
  }
}

class MainBody extends StatefulWidget {
  final BuildContext context;
  const MainBody({super.key, required this.context});

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        // 유저 정보 버튼
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Builder(
            builder: (BuildContext newContext) {
              return ElevatedButton(
                  onPressed: () {
                    userData.name == null
                        ? Navigator.push(
                            newContext,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          ).then((returnedUserData) {
                            setState(() {
                              userData = returnedUserData;
                            });
                          })
                        : null;
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: const Color(0xFF39c5bb),
                      minimumSize: const Size(double.infinity, 100)),
                  child: userData.name == null
                      ? const Text('로그인 해주세요.')
                      : Text('${userData.name} 님 어서오세요.'));
            },
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(widget.context).size.width * 0.45,
                  height: MediaQuery.of(widget.context).size.width * 0.45,
                  margin: const EdgeInsets.only(right: 10),
                  child: Builder(
                    builder: (BuildContext newContext) {
                      return ElevatedButton(
                        // 주차장 버튼
                        onPressed: () {
                          Navigator.push(
                              newContext,
                              MaterialPageRoute(
                                  builder: (context) => const MapScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: const Color(0xFF39c5bb),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'lib/assets/images/park icon.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  )),
              const SizedBox(width: 5),
              SizedBox(
                width: MediaQuery.of(widget.context).size.width * 0.45,
                height: MediaQuery.of(widget.context).size.width * 0.45,
                child: ElevatedButton(
                  // 이용 내역 버튼
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: const Color(0xFF39c5bb),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'lib/assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            //설명 버튼
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color(0xFF39c5bb),
              minimumSize: const Size(double.infinity, 100),
            ),
            child: const Text('박차고에 대해 알고 싶어요!'),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Builder(builder: (BuildContext newContext) {
                return ElevatedButton(
                  // 카드 관리
                  onPressed: () {
                    Navigator.push(newContext,
                        MaterialPageRoute(builder: (context) => CardScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: const Color(0xFF39c5bb),
                    minimumSize: const Size(double.infinity, 100),
                  ),
                  child: const Text('카드 관리'),
                );
              })),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  // 임시 userData test 버튼
                  onPressed: () {
                    debugPrint(
                        "${userData.id}, ${userData.username}, ${userData.nickname}, ${userData.name}");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: const Color(0xFF39c5bb),
                    minimumSize: const Size(double.infinity, 100),
                  ),
                  child: const Text('userData test'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DraggableFloatingActionButton extends StatefulWidget {
  const DraggableFloatingActionButton({super.key});

  @override
  _DraggableFloatingActionButtonState createState() =>
      _DraggableFloatingActionButtonState();
}

class _DraggableFloatingActionButtonState
    extends State<DraggableFloatingActionButton> {
  Offset position = const Offset(0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const double FabSize = 30;
    final double initialLeft = (screenSize.width / 2 - FabSize / 2);
    final double initialTop = screenSize.height - FabSize * 2;
    position = Offset(initialLeft, initialTop);
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Draggable(
            axis: Axis.horizontal,
            feedback: FloatingActionButton(
              onPressed: () {},
              backgroundColor: const Color(0xFF39c5bb),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(FabSize)),
              child: const Icon(Icons.local_atm),
            ),
            childWhenDragging: Container(),
            onDragEnd: (details) {
              setState(() {
                position = Offset(details.offset.dx, initialTop);
                checkDragDirection(details.offset);
              });
            },
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.local_atm),
            ),
          ),
        )
      ],
    );
  }

  void checkDragDirection(Offset offset) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    debugPrint("x, y ${offset.dx}, ${offset.dy}"); // 버튼 옮겼을 때 위치 출력
    debugPrint(// 가로 중앙값, 좌, 우 적용값
        "${MediaQuery.of(context).size.width / 2}, ${MediaQuery.of(context).size.width / 2 + 150}, ${MediaQuery.of(context).size.width / 2 - 150}");
    if (offset.dx > MediaQuery.of(context).size.width / 2 + 150) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const PrePaymentScreen()));
    } else if (offset.dx < MediaQuery.of(context).size.width / 2 - 150) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => QRScreen()));
    }
    position = Offset(screenWidth / 2 - 24, screenHeight - 56);
  }
}
