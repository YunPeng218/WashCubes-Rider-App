import 'package:flutter/material.dart';
import 'done_pickup_screen.dart'; 
class ScanTagScreen extends StatelessWidget {
  const ScanTagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
        leading: GestureDetector(
          onTap: () {
           
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DonePickupScreen()),
            );
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             const SizedBox(height: 40), 
            const Text(
              'Scan the Barcode',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Line up the barcode inside the blue corner & keep the phone steady!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Image.asset('assets/images/barcode_frame.png'),
              ),
            ),
            Icon(
              Icons.flashlight_on, 
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8), 
            Text(
              'Tap to turn light on',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
             const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}
