import 'package:flutter/material.dart';

class IdAndPwd extends StatelessWidget {
  const IdAndPwd({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TextField(
            decoration: InputDecoration(hintText: "아이디"),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          const TextField(
            decoration: InputDecoration(hintText: "비밀번호"),
          ),
        ],
      ),
    );
  }
}
