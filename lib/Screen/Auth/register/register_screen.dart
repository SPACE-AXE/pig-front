import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  ButtonStateManager state = ButtonStateManager();

  final TextEditingController _id = TextEditingController();
  bool idDuplicateFlag = false;

  String id = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('회원가입'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    controller: _id,
                    decoration: const InputDecoration(
                      hintText: "아이디",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff39c5bb),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      id = _id.text;
                    });
                    idDuplicateFlag ? null : checkUserIdDuplicate(id);
                  },
                  style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide(
                          color: idDuplicateFlag
                              ? const Color(0xff39c5bb)
                              : Colors.red))),
                  child: const Text("중복확인"),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "닉네임",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff39c5bb),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "이메일",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff39c5bb),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "이름",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff39c5bb),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "비밀번호",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff39c5bb),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "생일",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff39c5bb),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "전화번호",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff39c5bb),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkUserIdDuplicate(String inputData) async {
    String url = 'https://api.parkchargego.link/auth/check-username-duplicate/';
    // URL을 올바르게 형성하기 위해 Uri 클래스를 사용합니다.
    Uri uri = Uri.parse('$url$inputData');
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      print(uri);
      Fluttertoast.showToast(
        msg: "사용할 수 있는 아이디입니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xff39c5bb),
        textColor: Colors.white,
        fontSize: 16,
      );
      setState(() {
        idDuplicateFlag = !idDuplicateFlag;
      });
    } else {
      print(uri);
      Fluttertoast.showToast(
        msg: '사용할 수 없는 아이디입니다.',
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xff39c5bb),
      );
    }
  }
}

class ButtonStateManager {
  bool idDuplicateFlag = false;
}
