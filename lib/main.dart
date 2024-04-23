import 'package:flutter/material.dart';
import 'package:appfront/Screen/Auth/Login/login_screen.dart';

void main() {
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
      ),
    );
  }

  AppBar _buildAppBar() {
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

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                child: const Text('로그인 해주세요.'),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Color(0xFF39c5bb),
                    minimumSize: Size(double.infinity, 100)),
              );
            },
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Color(0xFF39c5bb),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          'lib/assets/images/park icon.png',
                          fit: BoxFit.scaleDown,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Image Button 2'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Color(0xFF39c5bb),
                    minimumSize: Size(double.infinity, 200),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Image Button 3'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Color(0xFF39c5bb),
              minimumSize: Size(double.infinity, 100),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Button 2'),
                  style: ElevatedButton.styleFrom(
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
                  onPressed: () {},
                  child: const Text('Button 3'),
                  style: ElevatedButton.styleFrom(
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
}
