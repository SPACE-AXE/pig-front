import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appfront/Screen/Car/services/car_service.dart';
import 'package:appfront/Screen/Car/widgets/car_list.dart';
import 'package:appfront/userData.dart';
import 'package:appfront/Screen/Car/car_add_screen.dart';

class CarScreen extends ConsumerStatefulWidget {
  const CarScreen({super.key});

  @override
  _CarScreenState createState() => _CarScreenState();
}

class _CarScreenState extends ConsumerState<CarScreen> {
  bool isLoading = true;
  List<Map<String, String>> cars = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = ref.read(userDataProvider);
      final accessToken = await data.storage!.read(key: "accessToken");
      final refreshToken = await data.storage!.read(key: "refreshToken");
      await _fetchCars(accessToken!, refreshToken!);
    });
  }

  Future<void> _fetchCars(String accessToken, String refreshToken) async {
    final fetchedCars = await CarService.fetchCars(accessToken, refreshToken);
    if (fetchedCars != null) {
      setState(() {
        cars = fetchedCars;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteCar(String carId) async {
    final data = ref.read(userDataProvider);
    final accessToken = await data.storage!.read(key: "accessToken");
    final refreshToken = await data.storage!.read(key: "refreshToken");
    await CarService.deleteCar(carId, accessToken!, refreshToken!);
    await _fetchCars(accessToken, refreshToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("차량 관리"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cars.isEmpty
              ? const Center(child: Text('차량이 없습니다.'))
              : CarList(cars: cars, onDelete: _deleteCar),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CarAddScreen()),
          );
          final data = ref.read(userDataProvider);
          final accessToken = await data.storage!.read(key: "accessToken");
          final refreshToken = await data.storage!.read(key: "refreshToken");
          await _fetchCars(accessToken!, refreshToken!);
        },
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF39c5bb),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
