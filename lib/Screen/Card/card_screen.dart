import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appfront/Screen/Card/services/card_service.dart';
import 'package:appfront/userData.dart';
import 'package:appfront/Screen/Card/card_add_screen.dart';

class CardScreen extends ConsumerStatefulWidget {
  const CardScreen({super.key});

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends ConsumerState<CardScreen> {
  bool isLoading = true;
  String? cardNumber;

  @override
  void initState() {
    super.initState();
    _fetchCard();
  }

  Future<void> _fetchCard() async {
    final data = ref.read(userDataProvider);
    final accessToken = await data.storage!.read(key: "accessToken");
    final refreshToken = await data.storage!.read(key: "refreshToken");

    final fetchedCard =
        await CardService.fetchCard(accessToken!, refreshToken!);
    setState(() {
      cardNumber = fetchedCard;
      isLoading = false;
    });
  }

  Future<void> _deleteCard() async {
    final data = ref.read(userDataProvider);
    final accessToken = await data.storage!.read(key: "accessToken");
    final refreshToken = await data.storage!.read(key: "refreshToken");

    final success = await CardService.deleteCard(accessToken!, refreshToken!);
    if (success) {
      setState(() {
        cardNumber = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("카드 관리"),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : cardNumber == null
                ? ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CardAddScreen()),
                      );
                      _fetchCard();
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF39c5bb),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                    child: const Text('카드 등록'),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF39c5bb),
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('등록된 카드\n$cardNumber',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            )),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _deleteCard,
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF39c5bb),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          child: const Text('카드 삭제'),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
