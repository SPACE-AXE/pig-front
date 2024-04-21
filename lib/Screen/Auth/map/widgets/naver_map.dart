import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MyNaverMap extends StatefulWidget {
  final NMarker marker;
  const MyNaverMap({super.key, required this.marker});

  @override
  State<MyNaverMap> createState() => _MyNaverMapState();
}

class _MyNaverMapState extends State<MyNaverMap> {
  @override
  Widget build(BuildContext context) {
    return NaverMap(
      options: const NaverMapViewOptions(
        mapType: NMapType.basic,
        pickTolerance: 8,
        rotationGesturesEnable: true,
        scrollGesturesEnable: true,
        tiltGesturesEnable: true,
        zoomGesturesEnable: true,
        stopGesturesEnable: true,
      ), // 지도 옵션을 설정할 수 있습니다.
      forceGesture: false, // 지도에 전달되는 제스처 이벤트의 우선순위를 가장 높게 설정할지 여부를 지정합니다.
      onMapReady: (controller) {
        controller.addOverlay(widget.marker);

        final onMarkerInfoWindow =
            NInfoWindow.onMarker(id: widget.marker.info.id, text: "인포윈도우 텍스트");
        widget.marker.openInfoWindow(onMarkerInfoWindow);
      },
      onMapTapped: (point, latLng) {},
      onSymbolTapped: (symbol) {},
      onCameraChange: (position, reason) {},
      onCameraIdle: () {},
      onSelectedIndoorChanged: (indoor) {},
    );
  }
}
