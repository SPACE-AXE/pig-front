import 'package:appfront/Screen/map/widgets/filter_page.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  final TextEditingController spaceController;
  final String disabled;
  final double sliderValue;
  final String search;
  final Function(String) makeMap;
  final Function(String) setSearch;
  final Function(double) setPrice;
  final Function(String) setSpace;
  final Function(String) setDisabled;
  const MySearchBar({
    super.key,
    required this.disabled,
    required this.sliderValue,
    required this.spaceController,
    required this.search,
    required this.makeMap,
    required this.setSearch,
    required this.setDisabled,
    required this.setPrice,
    required this.setSpace,
  });

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  String searchValue = '';

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20.0, // 지도의 상단에 위치
      left: 20.0, // 지도의 왼쪽에 위치
      right: 20.0, // 지도의 오른쪽에 위치
      child: Column(
        children: [
          SearchBar(
            backgroundColor: const MaterialStatePropertyAll(Color(0xffffffff)),
            side: const MaterialStatePropertyAll(
              BorderSide(
                color: Color(0xff39c5bb),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              onPressed: () {
                filter(
                  context,
                  widget.disabled,
                  widget.sliderValue,
                  widget.spaceController,
                  widget.setPrice,
                  widget.setSpace,
                  widget.setDisabled,
                );
              },
            ),
            trailing: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ],
            onChanged: (value) {
              widget.setSearch(value);
            },
            onSubmitted: (value) {
              widget.makeMap(value);
            },
          ),
        ],
      ),
    );
  }
}

void filter(context, disabled, sliderValue, spaceController, setPrice, setSpace,
    setDisabled) {
  showModalBottomSheet(
    enableDrag: true,
    context: context,
    builder: (BuildContext context) {
      return FilterPage(
        sliderValue: sliderValue,
        disabled: disabled,
        spaceController: spaceController,
        setPrice: setPrice,
        setSpace: setSpace,
        setDisabled: setDisabled,
      );
    },
  );
}
