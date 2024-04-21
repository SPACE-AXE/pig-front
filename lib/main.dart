import 'package:appfront/Screen/Auth/login/login_screen.dart';
import 'package:appfront/Screen/Auth/map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: "etuftq1yhk");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4),
              const GoToLogin(),
              const GoToMap(),
            ],
          ),
        ),
      ),
    );
  }
}

class GoToMap extends StatelessWidget {
  const GoToMap({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MapScreen()));
      },
      child: const Text("go to map"),
    );
  }
}

class GoToLogin extends StatelessWidget {
  const GoToLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()))
      },
      child: const Text("go to login"),
    );
  }
}
