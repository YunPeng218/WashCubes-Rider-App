import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:washcube_rider_app/config.dart';
import 'package:washcube_rider_app/src/constants/colors.dart';
import 'package:washcube_rider_app/src/constants/image_strings.dart';
import 'package:washcube_rider_app/src/features/screens/job_history/history_page.dart';
import 'package:washcube_rider_app/src/features/screens/profile/edit_profile_page.dart';
import 'package:washcube_rider_app/src/features/screens/setting/system_settings_page.dart';
import 'package:washcube_rider_app/src/features/screens/welcome/welcome_screen.dart';
import 'package:washcube_rider_app/src/utilities/theme/widget_themes/text_theme.dart';
import 'package:http/http.dart' as http;

class LeftNavigationBar extends StatefulWidget {
  const LeftNavigationBar({super.key});

  @override
  _LeftNavigationBarState createState() => _LeftNavigationBarState();
}

class _LeftNavigationBarState extends State<LeftNavigationBar> {
  Map<String, dynamic> riderDetails = {};

  @override
  void initState() {
    super.initState();
    getRiderDetails();
  }

  Future<void> getRiderDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
      var reqUrl = '${url}rider?riderId=${jwtDecodedToken["_id"]}';
      final response = await http.get(
        Uri.parse(reqUrl),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          riderDetails = data['rider'];
        });
      } else {
        print('Failed to load rider details');
      }
    } catch (error) {
      print('Error fetching rider details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.cBarColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            //Account Profile Section
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RiderEditProfilePage()),
                );
              },
              child: UserAccountsDrawerHeader(
                accountName: Text(
                  riderDetails['name'] ?? "",
                  style: CTextTheme.whiteTextTheme.headlineLarge,
                ),
                accountEmail: Text(
                  riderDetails['email'] ?? "",
                  style: CTextTheme.greyTextTheme.headlineSmall,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: riderDetails['profilePicURL']!=null
                    ? NetworkImage(riderDetails['profilePicURL'])
                    : const AssetImage(cRiderPFP) as ImageProvider<Object>,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.cBarColor,
                ),
              ),
            ),
            //Anouncement Tab
            ListTile(
              leading: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.cWhiteColor,
              ),
              title: Text('Announcement',
                  style: CTextTheme.whiteTextTheme.headlineMedium),
              //New Content Chip
              trailing: Chip(
                label:
                    Text('1', style: CTextTheme.whiteTextTheme.headlineSmall),
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
              leading: const Icon(
                Icons.history,
                color: AppColors.cWhiteColor,
              ),
              title: Text('History',
                  style: CTextTheme.whiteTextTheme.headlineMedium),
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
              leading: const Icon(
                Icons.headset_mic_outlined,
                color: AppColors.cWhiteColor,
              ),
              title: Text('Support',
                  style: CTextTheme.whiteTextTheme.headlineMedium),
              onTap: () {
                // Update the state of the app
                // ...
              },
            ),
            //Settings Tab
            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
                color: AppColors.cWhiteColor,
              ),
              title: Text('Settings',
                  style: CTextTheme.whiteTextTheme.headlineMedium),
              onTap: () {
                // Update the state of the app
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SystemSettingsPage()),
                );
              },
            ),
            //Log Out Tab
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: AppColors.cWhiteColor,
              ),
              title: Text('Log Out',
                  style: CTextTheme.whiteTextTheme.headlineMedium),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
