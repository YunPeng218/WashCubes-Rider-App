import 'package:flutter/material.dart';
import 'package:washcube_rider_app/history_page.dart';
import 'package:washcube_rider_app/system_settings_page.dart';

class LeftNavigationBar extends StatelessWidget {
  const LeftNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Drawer Example')),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              //Account Profile Section
              const UserAccountsDrawerHeader(
                accountName: Text("Darren Lee"),
                accountEmail: Text("darren9612@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with actual image url
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              //Anouncement Tab
              ListTile(
                leading: Icon(Icons.announcement),
                title: Text('Announcement'),
                //New Content Chip
                trailing: Chip(
                  label: Text('1', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.blue,
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                },
              ),
              //History Tab
              ListTile(
                leading: Icon(Icons.history),
                title: Text('History'),
                onTap: () {
                  // Update the state of the app
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryPage()),
                  );
                },
              ),
              //Support Tab
              ListTile(
                leading: Icon(Icons.support),
                title: Text('Support'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
              //Settings Tab
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Update the state of the app
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SystemSettingsPage()),
                  );
                },
              ),
              //Log Out Tab
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
            ],
          ),
        ),
        //TODO: Map Page Here
        body: Center(
          // The main content of the screen
          child: Text('Main content goes here'),
        ),
      ),
    );
  }
}
