import 'dart:convert';

import 'package:appfront/Screen/map/map_screen.dart';
import 'package:appfront/Screen/user/user_info_screen.dart';
import 'package:appfront/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appfront/userData.dart';
import 'package:appfront/Screen/Auth/Login/login_screen.dart';
import 'package:appfront/QRScreen.dart';
import 'package:appfront/Screen/prePayment/select_screen/select_screen.dart';
import 'package:appfront/Screen/Card/card_screen.dart';
import 'package:appfront/Screen/Car/car_screen.dart';
import 'package:appfront/Screen/usedDetail/used_detail_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: "etuftq1yhk");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const ProviderScope(child: MainApp()));
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _buildAppBar(),
        endDrawer: const MyDrawer(),
        body: Stack(
          children: [
            MainBody(context: context),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'lib/assets/images/indicator.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: const DraggableFloatingActionButton(),
      ),
      theme: ThemeData(fontFamily: 'BMJUA'),
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
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      ],
      elevation: 0,
    );
  }
}

class MainBody extends ConsumerStatefulWidget {
  final BuildContext context;
  const MainBody({super.key, required this.context});

  @override
  ConsumerState<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends ConsumerState<MainBody> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserLogin(ref);
      _asyncMethod();
    });
  }

  _asyncMethod() async {}
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
              return Consumer(
                builder: (_, ref, __) {
                  final data = ref.watch(userDataProvider);
                  return ElevatedButton(
                      onPressed: () {
                        data.name == null
                            ? Navigator.push(
                                newContext,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              ).then((value) => debugPrint("${data.id}"))
                            : Navigator.push(
                                newContext,
                                MaterialPageRoute(
                                  builder: (context) => const UserInfoScreen(),
                                ),
                              );
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          foregroundColor: const Color(0xFFFFFFFF),
                          textStyle: const TextStyle(
                            fontFamily: 'BMJUA',
                            fontSize: 30,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: const Color(0xFF39c5bb),
                          minimumSize: const Size(double.infinity, 100)),
                      child: data.name == null
                          ? const Text('로그인 해주세요.')
                          : Text('${data.name} 님 어서오세요.'));
                },
              );
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
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontFamily: 'BMJUA',
                            fontSize: 20,
                          ),
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
                  child: Consumer(
                    builder: (context, ref, _) {
                      return ElevatedButton(
                        // 이용 내역 버튼
                        onPressed: () {
                          final data = ref.watch(userDataProvider);
                          if (data.id == null) {
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UsedScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontFamily: 'BMJUA',
                            fontSize: 20,
                          ),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: const Color(0xFF39c5bb),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'lib/assets/images/list.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ))
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            //설명 버튼
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontFamily: 'BMJUA',
                fontSize: 20,
              ),
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
              Expanded(child: Consumer(builder: (context, ref, _) {
                return ElevatedButton(
                  // 카드 관리
                  onPressed: () {
                    final data = ref.watch(userDataProvider);
                    if (data.id == null) {
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CardScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontFamily: 'BMJUA',
                      fontSize: 20,
                    ),
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
                child: Consumer(
                  builder: (context, ref, _) {
                    return ElevatedButton(
                      // 차량 관리
                      onPressed: () {
                        final data = ref.watch(userDataProvider);
                        if (data.id == null) {
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CarScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontFamily: 'BMJUA',
                          fontSize: 20,
                        ),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: const Color(0xFF39c5bb),
                        minimumSize: const Size(double.infinity, 100),
                      ),
                      child: const Text('차량 관리'),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DraggableFloatingActionButton extends ConsumerStatefulWidget {
  const DraggableFloatingActionButton({super.key});

  @override
  _DraggableFloatingActionButtonState createState() =>
      _DraggableFloatingActionButtonState();
}

class _DraggableFloatingActionButtonState
    extends ConsumerState<DraggableFloatingActionButton> {
  Offset position = const Offset(0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const double FabSize = 30;
    final double initialLeft = (screenSize.width / 2 - FabSize / 2 + 5);
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
              backgroundColor: const Color(0xFF39c5bb),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(FabSize)),
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
        "${MediaQuery.of(context).size.width / 2 - 30}, ${MediaQuery.of(context).size.width / 2 + 75 - 30}, ${MediaQuery.of(context).size.width / 2 - 75 - 30}");
    if (offset.dx > MediaQuery.of(context).size.width / 2 + 75 - 30) {
      final data = ref.watch(userDataProvider);
      if (data.id == null) {
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SelectScreen(
              userData: data,
            ),
          ),
        );
      }
    } else if (offset.dx < MediaQuery.of(context).size.width / 2 - 75 - 30) {
      final data = ref.watch(userDataProvider);
      if (data.id == null) {
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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const QRScreen()));
      }
    }
    position = Offset(screenWidth / 2 - 24, screenHeight - 56);
  }
}

Future<bool> checkUserLogin(WidgetRef ref) async {
  const storage = FlutterSecureStorage();

  try {
    final accessToken = await storage.read(key: "accessToken");
    final refreshToken = await storage.read(key: "refreshToken");
    if (accessToken == null && refreshToken == null) {
      Fluttertoast.showToast(
        msg: "로그아웃되었습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xff39c5bb),
        textColor: Colors.white,
        fontSize: 16,
      );
      return false;
    }

    String url = "https://api.parkchargego.link/api/v2/auth/validate";
    Uri uri = Uri.parse(url);
    http.Response response = await http.post(uri, headers: {
      'access-token': accessToken!,
      'refresh-token': refreshToken!
    });

    var json = jsonDecode(response.body);
    ref.read(userDataProvider).updateUserData(UserData.fromJson(json));
    debugPrint("${response.headers}");
    return true;
  } catch (e) {
    Fluttertoast.showToast(
      msg: "로그아웃되었습니다",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xff39c5bb),
      textColor: Colors.white,
      fontSize: 16,
    );
    return false;
  }
}
