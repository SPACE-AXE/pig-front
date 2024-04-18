import 'package:flutter/material.dart';

class IdAndPwd extends StatefulWidget {
  final GlobalKey<FormState> idPwdFormKey;
  final Function(String) updateId;
  final Function(String) updatePwd;
  const IdAndPwd({
    super.key,
    required this.updateId,
    required this.updatePwd,
    required this.idPwdFormKey,
  });

  @override
  State<IdAndPwd> createState() => _IdAndPwdState();
}

class _IdAndPwdState extends State<IdAndPwd> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      width: MediaQuery.of(context).size.width * 0.6,
      child: Form(
        key: widget.idPwdFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "필수 입력값입니다.";
                }
                return null;
              },
              onChanged: (value) {
                widget.updateId(value);
              },
              decoration: const InputDecoration(
                hintText: "아이디",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff39c5bb),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            TextFormField(
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "필수 입력값입니다.";
                }
                return null;
              },
              onChanged: (value) {
                widget.updatePwd(value);
              },
              decoration: const InputDecoration(
                hintText: "비밀번호",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff39c5bb),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
