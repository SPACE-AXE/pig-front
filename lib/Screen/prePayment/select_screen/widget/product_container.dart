import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ProductContainer extends StatefulWidget {
  int selectedId;
  final Function(int) updateId;
  Map<String, dynamic> data;
  ProductContainer(
      {super.key,
      required this.data,
      required this.selectedId,
      required this.updateId});

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  String? selectedValue;
  String date = '';
  @override
  void initState() {
    super.initState();
    DateTime original = DateTime.parse(widget.data['entryTime']);
    setState(() {
      date = DateFormat('yyyy.MM.dd. HH:MM').format(original);
      debugPrint("widget: ${widget.data}");
    });
  }

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
                    // Container(
                    //   child: Text(
                    //     "${widget.data['carNum']}",
                    //     style: const TextStyle(fontSize: 20),
                    //   ),
                    // ),
                    Container(
                      child: Text(
                        "${widget.data['carNum']}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      child: Text(
                        date,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(flex: 2, child: Text("5,400 ₩")),
            ],
          ),
          value: widget.data['id'],
          groupValue: widget.selectedId,
          onChanged: (value) {
            widget.updateId(value);
          }),
    );
  }
}
