import 'package:flutter/material.dart';
import 'package:washcube_rider_app/lockersite_screen/identitycard_qr_screen.dart';
import 'scan_tag_screen.dart';

class PickupLaundrySiteScreen extends StatefulWidget {
  const PickupLaundrySiteScreen({Key? key}) : super(key: key);

  @override
  _PickupLaundrySiteScreenState createState() => _PickupLaundrySiteScreenState();
}

class _PickupLaundrySiteScreenState extends State<PickupLaundrySiteScreen> {
  bool isCompleted = false;

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
                // Implement the functionality to contact the admin hotline.
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            SizedBox(height: MediaQuery.of(context).padding.top * 0.05), // Space for status bar
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => IdentityCardQRScreen()), 
                            );
                          },
                          child: const CircleAvatar(
                            backgroundColor: Color.fromRGBO(215, 236, 247, 1),
                            child: Icon(Icons.contacts, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Laundry Centre',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const Text(
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
                      child: const Text(
                        'Help',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    width: 100,
                    height: 200,
                    child: Image.asset(
                      'assets/images/map01.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const ListTile(
            title: Text(
              'Location',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              'Sunway Geo Doby Shop',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Item Qty',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            subtitle: const Text(
              '3 Item(s)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
            _buildScanItem(context, 'Item #1911109579612'),
            _buildScanItem(context, 'Item #1911109579625'),
            _buildScanItem(context, 'Item #1215020113224'),
            // Add more items as needed
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: isCompleted ? Colors.green : Colors.blue, // Text color
          ),
          onPressed: () {
            setState(() {
              isCompleted = !isCompleted;
            });
          },
          child: Text(isCompleted ? 'Completed' : 'Picked Up'),
        ),
      ),
    );
  }

  Widget _buildScanItem(BuildContext context, String tagNumber) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.qr_code_scanner, color: Colors.black),
        title: Text(
          tagNumber,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor: Color.fromRGBO(215, 236, 247, 1),
          ),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ScanTagScreen())),
          child: const Text('SCAN'),
        ),
      ),
    );
  }
}
