import 'dart:math';
import 'dart:ui';
import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:appfront/Screen/Auth/Login/login_screen.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/widgets.dart';
import 'package:appfront/QRScreen.dart';
import 'package:appfront/PrePaymentScreen.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await DesktopWindow.setWindowSize(const Size(360, 800));
  //await DesktopWindow.setMinWindowSize(const Size(360, 800));
  //await DesktopWindow.setMaxWindowSize(const Size(360, 800));
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(context),
        floatingActionButton: DraggableFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

Widget _buildBody(BuildContext context) {
  //버튼 요소들
  double buttonSize = MediaQuery.of(context).size.width * 0.45;

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
                Navigator.push(
                    newContext,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Color(0xFF39c5bb),
                  minimumSize: Size(double.infinity, 100)),
              child: const Text('로그인 해주세요.'),
            );
          },
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: buttonSize,
              height: buttonSize,
              margin: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                // 주차장 버튼
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Color(0xFF39c5bb),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'lib/assets/images/park icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Container(
              width: buttonSize,
              height: buttonSize,
              child: ElevatedButton(
                // 이용 내역 버튼
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Color(0xFF39c5bb),
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
        SizedBox(height: 10),
        ElevatedButton(
          //설명 버튼
          onPressed: () {},
          child: const Text('박차고에 대해 알고 싶어요!'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Color(0xFF39c5bb),
            minimumSize: Size(double.infinity, 100),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                // QR 버튼
                onPressed: () {},
                child: const Text('Button 2'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Color(0xFF39c5bb),
                  minimumSize: Size(double.infinity, 100),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                // 사전 결제 버튼
                onPressed: () {},
                child: const Text('Button 3'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Color(0xFF39c5bb),
                  minimumSize: Size(double.infinity, 100),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class DraggableFloatingActionButton extends StatefulWidget {
  @override
  _DraggableFloatingActionButtonState createState() =>
      _DraggableFloatingActionButtonState();
}

class _DraggableFloatingActionButtonState
    extends State<DraggableFloatingActionButton> {
  Offset position = Offset(100, 500);

  @override
  void initState() {
    super.initState();
    position = Offset(100, 500);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.navigation),
        ),
        feedback: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.navigation),
          backgroundColor: Color(0xFF39c5bb),
        ),
        childWhenDragging: Container(),
        onDragEnd: (details) {
          setState(() {
            position = details.offset;
            checkDragDirection(details.offset);
          });
        },
      ),
    );
  }

  void checkDragDirection(Offset offset) {
    debugPrint("x, y ${offset.dx}, ${offset.dy}");
    if (offset.dx > MediaQuery.of(context).size.width / 2 + 100) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => PrePaymentScreen()));
    } else if (offset.dx < MediaQuery.of(context).size.width / 2 - 100) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => QRScreen()));
    }
  }
}
