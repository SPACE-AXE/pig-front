import 'dart:convert';

import 'package:appfront/Screen/map/widgets/naver_map.dart';
import 'package:appfront/Screen/map/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final marker =
      NMarker(id: "test", position: const NLatLng(36.144786, 128.39281));
  List<NMarker> markers = [];
  final TextEditingController spaceController = TextEditingController();

  Location location = Location();
  double lat = 0.0;
  double lng = 0.0;
  int price = 5000;
  int space = 0;
  String disabled = 'N';
  String search = '';

  @override
  void initState() {
    super.initState();
    // 위치 정보를 가져오는 비동기 작업을 시작
    getPosition().then((_) {
      // 위치 정보를 가져오는 작업이 완료되면 getPark()를 호출
      getPark().then((parkData) {
        setState(() {
          markers = makeMarkers(parkData);
        });
      });
    });
  }

  void makeMap(String place) async {
    markers = [];
    String url = 'https://api.parkchargego.link/map/place?place=$place';

    Uri uri = Uri.parse(url);

    await http.get(uri).then((value) {
      http.Response response = value;
      var json = jsonDecode(response.body);
      var tmp1 = double.parse(json['y']);
      var tmp2 = double.parse(json['x']);
      setState(() {
        lat = double.parse(tmp1.toStringAsFixed(6));
        lng = double.parse(tmp2.toStringAsFixed(6));
      });
    });
    // 위치 정보를 가져오는 작업이 완료되면 getPark()를 호출
    getPark().then((parkData) {
      setState(() {
        markers = makeMarkers(parkData);
      });
    });
  }

  void setPrice(double value) {
    markers = [];
    setState(() {
      price = value.toInt();
    });
    getPark().then((parkData) {
      setState(() {
        markers = makeMarkers(parkData);
      });
    });
  }

  void setSpace(String value) {
    markers = [];
    setState(() {
      space = int.parse(value);
    });
    getPark().then((parkData) {
      setState(() {
        markers = makeMarkers(parkData);
      });
    });
  }

  void setDisabled(String value) {
    markers = [];
    setState(() {
      disabled = value;
    });
    getPark().then((parkData) {
      setState(() {
        markers = makeMarkers(parkData);
      });
    });
  }

  Future<void> getPosition() async {
    try {
      // 위치를 결정하고 완료될 때까지 기다림
      await location._determinePosition();
      // 위치 정보를 가져와 변수에 저장
      Map<String, dynamic> position = await location._getPosition();
      setState(() {
        lat = position['lat'];
        lng = position['lng'];
      });
      print({lat, lng});
    } catch (error) {
      // 에러가 발생하면 처리
      print('Error: $error');
    }
  }

  Future<Map<String, dynamic>> getPark() async {
    String url =
        'https://api.parkchargego.link/map?lat=$lat&lng=$lng&price=$price&space=$space&disabled=$disabled';
    print(
        "lat:$lat, lng: $lng, price: $price, space: $space, disabled: $disabled");
    Uri uri = Uri.parse(url);

    http.Response response = await http.get(uri);
    print(response.body);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return json;
    } else {
      throw Exception('Failed to load park data');
    }
  }

  List<NMarker> makeMarkers(Map<String, dynamic> parkData) {
    List<dynamic> pcg = parkData['pcg'];
    List<dynamic> public = parkData['public'];
    List<NMarker> markers = [];

    public.map((park) async {
      var latitude = park['latitude'];
      var longitude = park['longitude'];
      var name = park['prkplceNm'];
      http.Response response;
      if (latitude == '') {
        var addr = park['rdnmadr'] != "" ? park['rdnmadr'] : park['lnmadr'];

        String url = 'https://api.parkchargego.link/map/addr?addr=$addr';
        Uri uri = Uri.parse(url);

        await http.get(uri).then((value) {
          response = value;
          var json = jsonDecode(response.body);

          setState(() {
            markers.add(NMarker(
              id: name,
              position:
                  NLatLng(double.parse(json['y']), double.parse(json['x'])),
            ));
          });
        });
      } else {
        setState(() {
          markers.add(NMarker(
            id: name,
            position: NLatLng(double.parse(latitude), double.parse(longitude)),
          ));
        });
      }
    }).toList();

    return markers;
  }

// 지도에 추가된 마커에만 정보창을 띄울 수 있습니다.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("주차장 찾기"),
        centerTitle: true,
      ),
      body: lat != 0.0 && lng != 0.0 && markers.isNotEmpty
          ? Stack(
              children: [
                MyNaverMap(
                  markers: markers,
                  lat: lat,
                  lng: lng,
                  price: price,
                  space: space,
                  disabled: disabled,
                ),
                MySearchBar(
                  disabled: disabled,
                  sliderValue: price.toDouble(),
                  spaceController: spaceController,
                  search: search,
                  makeMap: makeMap,
                  setPrice: setPrice,
                  setSpace: setSpace,
                  setDisabled: setDisabled,
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
              ),
            ), // markers를 사용하는 위젯을 반환합니다.
    );
  }
}

class Location {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, dynamic>> _getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    position.longitude;

    return {'lat': position.latitude, 'lng': position.longitude};
  }
}
