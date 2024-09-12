import 'package:flutter/material.dart';

class CarList extends StatelessWidget {
  final List<Map<String, String>> cars;
  final Function(String) onDelete;

  const CarList({super.key, required this.cars, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF39c5bb), width: 3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '차량 번호: ${cars[index]['carNum']}',
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.blueGrey),
                onPressed: () => onDelete(cars[index]['id']!),
              ),
            ],
          ),
        );
      },
    );
  }
}
