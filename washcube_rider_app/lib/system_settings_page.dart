import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SystemSettingsPage(),
    );
  }
}

class SystemSettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SystemSettingsPage> {
  bool autoReceiveOrder = false;
  bool receivePickUpAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Settings', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Auto receive order'),
            trailing: Switch(
              value: autoReceiveOrder,
              onChanged: (value) {
                setState(() {
                  autoReceiveOrder = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Receive pick up alerts'),
            trailing: Switch(
              value: receivePickUpAlerts,
              onChanged: (value) {
                setState(() {
                  receivePickUpAlerts = value;
                });
              },
              activeColor: Colors.green,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'ACCOUNT SETTING',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: Text('Reset Password'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement reset password functionality
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // background (button) color
                onPrimary: Colors.white, // foreground (text) color
              ),
              onPressed: () {
                // TODO: Implement delete account functionality
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Delete Account'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
