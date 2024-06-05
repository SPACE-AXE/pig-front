import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:appfront/userData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QRScreen extends ConsumerStatefulWidget {
  const QRScreen({super.key});

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends ConsumerState<QRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: const Color(0xFF39c5bb),
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text('QR 코드를 스캔해 주세요.'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      setState(() {
        result = scanData;
      });
      debugPrint('\n\n\n${scanData.code}\n');
      await _sendPayment(scanData.code);
    });
  }

  Future<void> _sendPayment(String? paymentjson) async {
    final data = ref.read(userDataProvider);
    if (paymentjson != null) {
      final url = Uri.parse('https://api.parkchargego.link/api/v1/payment');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie':
              'access-token=${data.accessToken}; refresh-token=${data.refreshToken}'
        },
        body: paymentjson,
      );

      debugPrint('\n\n\npaymentID : $paymentjson\n');
      debugPrint(
          'Cookie : access-token=${data.accessToken}; refresh-token=${data.refreshToken}\n');
      debugPrint('response.statusCode : ${response.statusCode}\n\n\n');
      debugPrint('response.body : ${response.body}\n\n\n');

      if (response.statusCode == 200) {
        _showAlertDialog('결제가 완료되었습니다.');
      } else {
        _showAlertDialog('결제에 실패했습니다. 다시 시도해 주세요.');
      }
    } else {
      controller?.resumeCamera();
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    ).then((_) {
      if (message != '결제가 완료되었습니다.') {
        controller?.resumeCamera();
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
