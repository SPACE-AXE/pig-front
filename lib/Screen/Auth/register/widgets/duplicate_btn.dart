import 'package:appfront/Screen/Auth/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class DuplicateButton extends StatefulWidget {
  final ButtonStateManager state;
  final String id;
  const DuplicateButton({super.key, required this.state, required this.id});

  @override
  State<DuplicateButton> createState() => _DuplicateButtonState();
}

class _DuplicateButtonState extends State<DuplicateButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.state.idDuplicateFlag ? null : checkUserIdDuplicate(widget.id);
      },
      style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(
              color: widget.state.idDuplicateFlag
                  ? const Color(0xff39c5bb)
                  : Colors.red))),
      child: const Text("중복확인"),
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
        widget.state.idDuplicateFlag = !widget.state.idDuplicateFlag;
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
