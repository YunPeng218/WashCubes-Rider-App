import 'package:flutter/material.dart';
import 'locker_qr_screen.dart';
import 'identitycard_qr_screen.dart';

class DonePickupScreen extends StatefulWidget {
  const DonePickupScreen({Key? key}) : super(key: key);

  @override
  _DonePickupScreenState createState() => _DonePickupScreenState();
}

class _DonePickupScreenState extends State<DonePickupScreen> {
  bool isCompleted = false;
 // State to track if the item has been picked up

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
              child: const Icon(Icons.check, color: Colors.black),
            ),
            title: Text(
              'Apply Tag',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                // TODO: Implement the functionality when the "DONE" button is pressed
              },
              child: const Text('DONE', style: TextStyle(color: Colors.white)),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Uploaded on 23 Nov 2023, 22:03',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const Divider(),
           SizedBox(height: 150), 
                       ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: isCompleted ? Colors.white : Colors.black, backgroundColor: isCompleted ? Colors.blue : Colors.white,
            side: BorderSide(color: Colors.blue),
          ),
          onPressed: () {
            setState(() {
              // Toggle the completion status
              isCompleted = !isCompleted;
            });
          },
          child: Text(
            isCompleted ? 'Completed' : 'Picked Up',
            style: TextStyle(
              color: isCompleted ? Colors.white : Colors.black,
            ),
          ),
        ),

        ],
      ),
    );
  }
}
