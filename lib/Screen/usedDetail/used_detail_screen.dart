import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appfront/Screen/usedDetail/services/used_service.dart';
import 'package:appfront/Screen/usedDetail/widgets/used_list_item.dart';
import 'package:appfront/userData.dart';

class UsedScreen extends ConsumerStatefulWidget {
  const UsedScreen({super.key});

  @override
  _UsedScreenState createState() => _UsedScreenState();
}

class _UsedScreenState extends ConsumerState<UsedScreen> {
  bool isLoading = true;
  List<dynamic> jsonResponse = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = ref.read(userDataProvider);
      final accessToken = await data.storage!.read(key: "accessToken");
      final refreshToken = await data.storage!.read(key: "refreshToken");
      await _fetchUsedData(accessToken!, refreshToken!);
    });
  }

  Future<void> _fetchUsedData(String accessToken, String refreshToken) async {
    final fetchedData =
        await UsedService.fetchUsedData(accessToken, refreshToken);
    setState(() {
      jsonResponse = fetchedData ?? [];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("이용 내역"),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : jsonResponse.isEmpty
                ? const Text('이용 내역이 없습니다.')
                : ListView.builder(
                    itemCount: jsonResponse.length,
                    itemBuilder: (context, index) {
                      final item = jsonResponse[index];
                      return UsedListItem(item: item);
                    },
                  ),
      ),
    );
  }
}
