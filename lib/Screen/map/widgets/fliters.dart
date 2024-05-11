import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Filters extends StatefulWidget {
  final TextEditingController spaceController;
  final String disabled;
  final double sliderValue;
  final Function(double) setPrice;
  final Function(String) setSpace;
  final Function(String) setDisabled;
  const Filters({
    super.key,
    required this.disabled,
    required this.sliderValue,
    required this.spaceController,
    required this.setDisabled,
    required this.setPrice,
    required this.setSpace,
  });
  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  final TextEditingController spaceController = TextEditingController();
  double _sliderValue = 5000.0;
  bool switchValue = false;

  void _onChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.sliderValue;
    if (widget.disabled == 'N') {
      switchValue = false;
    } else {
      switchValue = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Title(
                  color: Colors.black,
                  child: const Text(
                    "최대 가격",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Slider(
                    value: _sliderValue,
                    secondaryTrackValue: _sliderValue,
                    min: 0.0,
                    max: 5000.0,
                    divisions: 10, // 10개의 구간으로 나누어서 표시, 없으면 연속적
                    label: '${_sliderValue.toInt()}',
                    onChanged: (value) {
                      _onChanged(value);
                    },
                    onChangeEnd: (value) {
                      widget.setPrice(_sliderValue);
                    },
                  ),
                ),
                Expanded(flex: 1, child: Text("${_sliderValue.toInt()}")),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  flex: 5,
                  child: Text(
                    "최소 구획 수",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: spaceController,
                    onChanged: (value) {
                      widget.setSpace(value);
                    },
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff39c5bb),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const Expanded(
                  flex: 5,
                  child: Text(
                    "장애인 주차구역",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Switch(
                    value: switchValue,
                    onChanged: (value) {
                      print(value);
                      if (value) {
                        print("1");
                        setState(() {
                          switchValue = !switchValue;
                        });
                        print(switchValue);
                        widget.setDisabled('Y');
                      } else {
                        setState(() {
                          switchValue = !switchValue;
                        });
                        print(switchValue);
                        widget.setDisabled('N');
                      }
                    },
                    activeColor: const Color(0xff39c5bb),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
