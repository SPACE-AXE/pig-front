import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductContainer extends StatefulWidget {
  Map<String, dynamic> data;
  ProductContainer({super.key, required this.data});

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xff39c5bb),
          width: 3,
        ),
      ),
      child: RadioListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: Text("${widget.data['id']}"),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: const Text("!@#"),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: const Text("!@#"),
                    ),
                  ],
                ),
              ),
              const Expanded(flex: 1, child: Text("data")),
            ],
          ),
          value: 1,
          groupValue: 'groupValue',
          onChanged: (value) {
            debugPrint("$value");
          }),
    );
  }
}
