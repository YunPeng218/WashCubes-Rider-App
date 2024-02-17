import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanTagScreen extends StatefulWidget {
  @override
  _ScanTagScreenState createState() => _ScanTagScreenState();
}

class _ScanTagScreenState extends State<ScanTagScreen> {
  String barcode = 'Unknown';

  Future<void> scanBarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Line color
        'Cancel', // Cancel button text
        true, // Show flash icon
        ScanMode.BARCODE,
      );
    } catch (e) {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      barcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Scan the Barcode',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Line up the barcode inside the blue corner & keep the phone steady!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          // Barcode scanning area or image placeholder
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Image.asset('assets/images/barcode_frame.png'), 
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: InkWell(
              onTap: () => scanBarcode(),
              child: Text(
                'Tap to turn light on',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
