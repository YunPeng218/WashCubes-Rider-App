import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Drawer Example')),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Darren Lee"),
                accountEmail: Text("darren9612@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with actual image url
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                leading: Icon(Icons.announcement),
                title: Text('Announcement'),
                trailing: Chip(
                  label: Text('1', style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.blue,
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('History'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.support),
                title: Text('Support'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Center(
          // The main content of the screen
          child: Text('Main content goes here'),
        ),
      ),
    );
  }
}
