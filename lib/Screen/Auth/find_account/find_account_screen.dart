import 'package:appfront/Screen/Auth/find_account/widget/email_input.dart';
import 'package:appfront/Screen/Auth/find_account/widget/name_input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FindAccountScreen extends StatefulWidget {
  const FindAccountScreen({super.key});

  @override
  State<FindAccountScreen> createState() => _FindAccountScreenState();
}

class _FindAccountScreenState extends State<FindAccountScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final RegExp _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  bool emailCheck = true;
  String email = '';
  String name = '';
  String userName = '';

  void setEmailFlag(String value) {
    if (!_emailRegExp.hasMatch(value)) {
      setState(() {
        emailCheck = false;
      });
    } else {
      setState(() {
        emailCheck = true;
      });
    }
  }

  void findUserName(Map<String, dynamic> userData) async {
    String url = 'https://api.parkchargego.link/api/v1/auth/find-username';
    Uri uri = Uri.parse(url);
    http.Response response = await http.post(uri, body: userData);
    setState(() {
      userName = response.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("아이디 찾기"),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NameInput(name: _name),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              EmailInput(
                  email: _email,
                  emailCheck: emailCheck,
                  setEmailFlag: setEmailFlag),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  "아이디: $userName",
                  style: const TextStyle(fontSize: 17, color: Colors.black),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 10),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      email = _email.text;
                      name = _name.text;
                    });
                    Map<String, dynamic> userData = {
                      'name': name,
                      'email': email,
                    };
                    findUserName(userData);
                  }
                },
                child: const Text(
                  "아이디 찾기",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
