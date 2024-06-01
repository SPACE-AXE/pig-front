import 'package:appfront/Screen/prePayment/payScreen/pay_screen.dart';
import 'package:flutter/material.dart';

class EnterBtn extends StatefulWidget {
  final Function(int) dataGetter;
  int selectedId;
  EnterBtn({super.key, required this.dataGetter, required this.selectedId});

  @override
  State<EnterBtn> createState() => _EnterBtnState();
}

class _EnterBtnState extends State<EnterBtn> {
  late Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const double FabSize = 30;
    final double initialLeft = (screenSize.width / 2 - FabSize / 2);
    final double initialTop = screenSize.height - FabSize * 2;
    Offset position = Offset(initialLeft, initialTop);
    print("${screenSize.width}, ${screenSize.height}");
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: ElevatedButton(
              onPressed: () {
                widget.selectedId == 0
                    ? null
                    : {
                        data = widget.dataGetter(widget.selectedId),
                        debugPrint("$data"),
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PayScreen(data: data)))
                      };
              },
              child: const Text("!23")),
        ),
      ],
    );
  }
}
