import 'package:flutter/material.dart';

class ScanTagScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan'),
        leading: GestureDetector(
        onTap: () {
          
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             SizedBox(height: 40), 
            Text(
              'Scan the Barcode',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
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
            SizedBox(height: 8), 
            Text(
              'Tap to turn light on',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
             SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}
