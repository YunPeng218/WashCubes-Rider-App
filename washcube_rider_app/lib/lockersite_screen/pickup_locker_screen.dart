import 'package:flutter/material.dart';
import 'locker_qr_screen.dart'; 
import 'identitycard_qr_screen.dart';
import 'scan_tag_screen.dart'; 
import'done_pickup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locker App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PickupLocker(),
    );
  }
}

class PickupLocker extends StatelessWidget {
  const PickupLocker({Key? key}) : super(key: key);

  void showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Need Help?'),
          content: const Text('If you need any help, please contact the admin hotline.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Contact Admin Hotline'),
              onPressed: () {
                // TODO: Implement the functionality to contact the admin hotline
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 50),
          SizedBox(height: MediaQuery.of(context).padding.top * 0.05), // Space for status bar
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Icons on the left
                Column(
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LockerQRScreen()), 
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: Color.fromRGBO(215, 236, 247, 1),
                              child: Icon(Icons.kitchen, color: Colors.black),
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => IdentityCardQRScreen()), 
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: Color.fromRGBO(215, 236, 247, 1),
                              child: Icon(Icons.contacts, color: Colors.black),
                            ),
                          ),
                        ],

                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Order: #9612',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '1 • Pick Up',
                      style: TextStyle(
                        color: Color(0xFF438FF7),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(215, 236, 247, 1),
                      ),
                      onPressed: () => showHelpDialog(context),
                      child: Text(
                        'Help',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Placeholder for the image on the right
                Expanded(
                  child: SizedBox(
                    width: 100, // Specify the desired width
                    height: 200, // Specify the desired height
                    child: Image.asset(
                      'assets/images/map01.png',
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Container 2
          ListTile(
            title: Text(
              'Location',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              'Sunway Geo Residences',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Street',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              'Persiaran Tasik Timur, Sunway South Quay, Bandar Sunway, 47500 Subang Jaya, Selangor',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: Container(
              child: const Icon(Icons.qr_code_scanner, color: Colors.black),
            ),
            title: Text(
              'Scan Tag',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Color.fromRGBO(215, 236, 247, 1),
              ),
              onPressed: () {
                Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => ScanTagScreen()), 
                );
              },
              child: const Text('SCAN'),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
