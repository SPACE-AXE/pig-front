import 'package:appfront/Screen/map/widgets/fliters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FilterPage extends StatefulWidget {
  final TextEditingController spaceController;
  final String disabled;
  final Function(double) setPrice;
  final Function(String) setSpace;
  final Function(String) setDisabled;
  const FilterPage({
    super.key,
    required this.disabled,
    required this.spaceController,
    required this.setDisabled,
    required this.setPrice,
    required this.setSpace,
  });

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25.0), // 상단 모서리를 둥글게 만듭니다.
          ),
          border: Border.all(color: const Color(0xff39c5bb), width: 1),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Title(
                      color: Colors.black,
                      child: const Text(
                        "필터",
                        style: TextStyle(fontSize: 35),
                      ),
                    ),
                  ],
                ),
              ),
              Filters(
                disabled: widget.disabled,
                spaceController: widget.spaceController,
                setPrice: widget.setPrice,
                setSpace: widget.setSpace,
                setDisabled: widget.setDisabled,
              ),
            ],
          ),
        ));
  }
}
