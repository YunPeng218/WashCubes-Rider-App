import 'package:flutter/material.dart';

class LockerQRScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locker QR'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Image.asset('assets/images/qr_code_id.png'),
              SizedBox(height: 24),
              Text(
                'Show QR code to the locker for access.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 25),
              Text(
                'User Order ID : #906912',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Created by 23 Nov 2023, 14:29',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
