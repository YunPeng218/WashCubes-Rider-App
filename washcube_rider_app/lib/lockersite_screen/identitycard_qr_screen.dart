import 'package:flutter/material.dart';

class IdentityCardQRScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID Verification'),
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
              CircleAvatar(
                radius: 50, 
                backgroundImage: AssetImage('assets/images/profile_picture.png'), 
              ),
              SizedBox(height: 8),
              Text(
                'Darren Lee',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
