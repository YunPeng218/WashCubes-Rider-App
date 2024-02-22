import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';

class BarcodeScannerWidget extends StatefulWidget {
  final Function(String) onScanResult;
  final bool isScanning;

  const BarcodeScannerWidget({
    Key? key,
    required this.onScanResult,
    required this.isScanning,
  }) : super(key: key);

  @override
  _BarcodeScannerWidgetState createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  @override
  Widget build(BuildContext context) {
    //Generate Scan Button
    return TextButton(
      onPressed: widget.isScanning ? null : _startScanning,
      child: Text(
        widget.isScanning ? 'Done' : 'Scan', //Change Button Text After Scanning
        style: TextStyle(
          color: widget.isScanning ? AppColors.cBlueColor3 : Colors.red, //Change Color After Scanning
        ),
      ),
    );
  }

  // Barcode Scanning Function
  //TODO: Change Barcode Scanning Behaviour Appropriately
  Future<void> _startScanning() async {
    try {
      final result = await FlutterBarcodeScanner.scanBarcode(
        '#438FF7', // Scan Line Color
        'Cancel', // Cancel Button
        true, // Flashlight Button
        ScanMode.BARCODE,
      );

      if (!mounted || result == '-1') return;

      setState(() {
        widget.onScanResult(result);
      });
    } on PlatformException catch (e) {
      print('Failed to get platform version: ${e.message}');
      // Handle error
    }
  }
}
