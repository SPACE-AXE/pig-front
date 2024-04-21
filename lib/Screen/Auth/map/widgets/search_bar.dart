import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20.0, // 지도의 상단에 위치
      left: 20.0, // 지도의 왼쪽에 위치
      right: 20.0, // 지도의 오른쪽에 위치
      child: SearchBar(
        backgroundColor: const MaterialStatePropertyAll(Color(0xffffffff)),
        side: const MaterialStatePropertyAll(
          BorderSide(
            color: Color(0xff39c5bb),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.filter_list_rounded),
          onPressed: () {},
        ),
        trailing: const [Icon(Icons.search)],
      ),
    );
  }
}
