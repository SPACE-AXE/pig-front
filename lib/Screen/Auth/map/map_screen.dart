import 'package:appfront/Screen/Auth/map/widgets/naver_map.dart';
import 'package:appfront/Screen/Auth/map/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final marker = NMarker(id: "test", position: const NLatLng(37.5666, 126.979));
// 지도에 추가된 마커에만 정보창을 띄울 수 있습니다.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("주차장 찾기"),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xff39c5bb),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(0, 2), // 그림자 위치 설정
                ),
              ]),
          child: IconButton(
            iconSize: 30,
            onPressed: () {},
            icon: const Icon(Icons.gps_fixed),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Stack(
          children: [
            MyNaverMap(marker: marker),
            const MySearchBar(),
          ],
        ));
  }
}
