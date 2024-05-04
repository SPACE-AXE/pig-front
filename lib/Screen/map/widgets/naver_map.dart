import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MyNaverMap extends StatefulWidget {
  final double lat;
  final double lng;
  final int price;
  final int space;
  final String disabled;
  final List<NMarker> markers;
  const MyNaverMap({
    super.key,
    required this.markers,
    required this.lat,
    required this.lng,
    required this.price,
    required this.space,
    required this.disabled,
  });

  @override
  State<MyNaverMap> createState() => _MyNaverMapState();
}

class _MyNaverMapState extends State<MyNaverMap> {
  @override
  Widget build(BuildContext context) {
    return NaverMap(
      options: NaverMapViewOptions(
        locationButtonEnable: true,
        initialCameraPosition:
            NCameraPosition(target: NLatLng(widget.lat, widget.lng), zoom: 14),
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
        for (var marker in widget.markers) {
          controller.addOverlay(marker);
          marker.setOnTapListener((overlay) {
            print(overlay.info.id);
          });
        }

        // controller.addOverlay(widget.markers);
        // final onMarkerInfoWindow = NInfoWindow.onMarker(
        //     id: widget.markers.info.id, text: "${widget.lat}, ${widget.lng}");
        // widget.markers.openInfoWindow(onMarkerInfoWindow);
      },
      onMapTapped: (point, latLng) {},
      onSymbolTapped: (symbol) {},
      onCameraChange: (position, reason) {},
      onCameraIdle: () {},
      onSelectedIndoorChanged: (indoor) {},
    );
  }
}
