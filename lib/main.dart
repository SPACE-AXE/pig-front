import 'package:appfront/Screen/Login/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4),
            const GoToLogin()
          ],
        )),
      ),
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
        child: const Text("go to login"));
  }
}
